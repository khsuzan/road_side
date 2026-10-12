import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/map_painter.dart';

class RequestHelpPage extends StatefulWidget {
  const RequestHelpPage({super.key});

  @override
  State<RequestHelpPage> createState() => _RequestHelpPageState();
}

class _RequestHelpPageState extends State<RequestHelpPage>
    with TickerProviderStateMixin {
  String _selectedService = 'Tire Change';
  bool _isRecording = false;
  List<double> _waveformHeights = List.filled(12, 10.0);
  Timer? _waveformTimer;

  // Selected breakdown issue pills
  final Set<String> _selectedIssues = {};

  // Service type toggle (0: On-spot Repair, 1: Tow to Garage)
  int _selectedServiceTypeIndex = 0;

  // Search Radar Mode
  bool _isSearchingRadar = false;
  late final AnimationController _radarController;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _waveformTimer?.cancel();
    _radarController.dispose();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
    });
    _waveformTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (mounted) {
        setState(() {
          _waveformHeights = List.generate(12, (_) => Random().nextDouble() * 30 + 8);
        });
      }
    });
  }

  void _stopRecording() {
    _waveformTimer?.cancel();
    setState(() {
      _isRecording = false;
      _waveformHeights = List.filled(12, 10.0);
    });
  }

  void _showBreakdownSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handlebar
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),

                  Text(
                    'Detail Your Issue',
                    style: AppTypography.headlineMd.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select all that apply to help the mechanic prepare.',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Issue Pills Grid
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Smoke from Hood',
                      'Strange Noise',
                      'No Start',
                      'Oil Leak',
                      'Flat Tire',
                    ].map((issue) {
                      final isSelected = _selectedIssues.contains(issue);
                      return GestureDetector(
                        onTap: () {
                          setSheetState(() {
                            if (isSelected) {
                              _selectedIssues.remove(issue);
                            } else {
                              _selectedIssues.add(issue);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            issue,
                            style: AppTypography.labelBold.copyWith(
                              color: isSelected ? Colors.white : AppColors.onSurface,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Voice note recording layout
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setSheetState(() {
                              if (_isRecording) {
                                _stopRecording();
                              } else {
                                _startRecording();
                              }
                            });
                          },
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isRecording
                                  ? AppColors.errorContainer
                                  : AppColors.surfaceContainerLowest,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: Icon(
                              _isRecording ? Icons.stop : Icons.mic,
                              color: _isRecording
                                  ? AppColors.error
                                  : AppColors.primary,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(12, (index) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 4,
                                height: _waveformHeights[index],
                                decoration: BoxDecoration(
                                  color: _isRecording
                                      ? AppColors.primary
                                      : AppColors.secondaryFixedDim,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Slide Service toggle
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setSheetState(() {
                                _selectedServiceTypeIndex = 0;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                color: _selectedServiceTypeIndex == 0
                                    ? AppColors.surfaceContainerLowest
                                    : Colors.transparent,
                                boxShadow: _selectedServiceTypeIndex == 0
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 5,
                                        )
                                      ]
                                    : null,
                              ),
                              child: Text(
                                'On-spot Repair',
                                style: AppTypography.labelBold.copyWith(
                                  color: _selectedServiceTypeIndex == 0
                                      ? AppColors.onSurface
                                      : AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setSheetState(() {
                                _selectedServiceTypeIndex = 1;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                color: _selectedServiceTypeIndex == 1
                                    ? AppColors.surfaceContainerLowest
                                    : Colors.transparent,
                                boxShadow: _selectedServiceTypeIndex == 1
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 5,
                                        )
                                      ]
                                    : null,
                              ),
                              child: Text(
                                'Tow to Garage',
                                style: AppTypography.labelBold.copyWith(
                                  color: _selectedServiceTypeIndex == 1
                                      ? AppColors.onSurface
                                      : AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Confirmation Action button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _isSearchingRadar = true;
                      });
                      _radarController.repeat();
                    },
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9999),
                        gradient: AppColors.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Confirm & Find Mechanic',
                            style: AppTypography.labelBold.copyWith(
                              color: AppColors.onPrimary,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

    @override
    Widget build(BuildContext context) {
      if (_isSearchingRadar) {
        return _buildRadarScreen();
      }

      return Scaffold(
        body: Stack(
          children: [
            // Immersive Map background
            Positioned.fill(
              child: Container(
                color: const Color(0xFFE5E2E0),
                child: CustomPaint(
                  painter: MapPainter(),
                ),
              ),
            ),

            // Top Header back button
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 24,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: AppColors.onSurface,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Request Help',
                    style: AppTypography.headlineMd.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            // Map Controls
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              right: 24,
              child: Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9),
                    ),
                    child: const Icon(Icons.my_location, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9),
                    ),
                    child: const Icon(Icons.layers, color: AppColors.onSurface),
                  ),
                ],
              ),
            ),

            // Bottom Floating Card
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 24,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "What's the issue?",
                      style: AppTypography.headlineMd.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select the required service to dispatch the nearest unit.',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Service selectors
                    Row(
                      children: [
                        _buildServiceSelector('Tire Change', Icons.tire_repair),
                        const SizedBox(width: 12),
                        _buildServiceSelector('Battery Jump', Icons.battery_charging_full),
                        const SizedBox(width: 12),
                        _buildServiceSelector('Towing', Icons.local_shipping),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Request button
                    GestureDetector(
                      onTap: _showBreakdownSheet,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9999),
                          gradient: AppColors.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Request Rapid Response',
                              style: AppTypography.labelBold.copyWith(
                                color: AppColors.onPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildServiceSelector(String serviceName, IconData icon) {
      final isSelected = _selectedService == serviceName;
      return Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedService = serviceName;
            });
          },
          child: AnimatedScale(
            scale: isSelected ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: 32,
                    color: isSelected ? Colors.white : AppColors.onSurface,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    serviceName,
                    style: AppTypography.labelBold.copyWith(
                      color: isSelected ? Colors.white : AppColors.onSurface,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildRadarScreen() {
      return Scaffold(
        body: Stack(
          children: [
            // Map underlay
            Positioned.fill(
              child: Container(
                color: const Color(0xFFE5E2E0),
                child: CustomPaint(painter: MapPainter()),
              ),
            ),

            // Pulsing Radar Rings
            Center(
              child: AnimatedBuilder(
                animation: _radarController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: List.generate(3, (index) {
                      final progress = (_radarController.value + index / 3.0) % 1.0;
                      return Container(
                        width: 300 * progress,
                        height: 300 * progress,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 1.0 - progress),
                            width: 2.0,
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),

            // Center User location pin
            Center(
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),

            // Mock Mechanic pin 1
            Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              left: MediaQuery.of(context).size.width * 0.25,
              child: _buildMechanicPin('4 min away'),
            ),

            // Mock Mechanic pin 2
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              right: MediaQuery.of(context).size.width * 0.2,
              child: _buildMechanicPin('7 min away'),
            ),

            // Bottom Alert Sheet card
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 24,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 40,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Waiting for confirmation!',
                      style: AppTypography.headlineMd.copyWith(
                        color: AppColors.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your request has been dispatched to nearby elite mechanics.',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isSearchingRadar = false;
                        });
                        _radarController.stop();
                      },
                      child: Text(
                        'Cancel Request',
                        style: AppTypography.labelBold.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildMechanicPin(String label) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                )
              ],
            ),
            child: Text(
              label,
              style: AppTypography.labelBold.copyWith(
                fontSize: 10,
                color: AppColors.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Icon(
            Icons.location_on,
            color: AppColors.primary,
            size: 32,
          ),
        ],
      );
    }
}
