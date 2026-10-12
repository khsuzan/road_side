import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/map_painter.dart';
import '../../domain/entities/mechanic_application_entity.dart';
import '../bloc/mechanic_bloc.dart';
import '../bloc/mechanic_event.dart';
import '../bloc/mechanic_state.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/toast_utils.dart';

class MechanicApplicationPage extends StatefulWidget {
  const MechanicApplicationPage({super.key});

  @override
  State<MechanicApplicationPage> createState() =>
      _MechanicApplicationPageState();
}

class _MechanicApplicationPageState extends State<MechanicApplicationPage> {
  String? _uploadedIdName;
  bool _isUploadingId = false;

  final Set<String> _selectedExpertise = {'Car Engine', 'Electrical'};
  int _businessTypeIndex = 0; // 0: Mobile Freelancer, 1: Garage Owner

  void _simulateUploadId() async {
    setState(() {
      _isUploadingId = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isUploadingId = false;
        _uploadedIdName = 'national_id_card.png';
      });
    }
  }

  void _submitApplication() {
    final application = MechanicApplicationEntity(
      id: 'mech_123',
      idPhotoPath: _uploadedIdName,
      expertise: _selectedExpertise.toList(),
      businessType: _businessTypeIndex == 0 ? 'Mobile Freelancer' : 'Garage Owner',
      latitude: 34.0522,
      longitude: -118.2437,
      status: 'Pending',
    );

    context.read<MechanicBloc>().add(SubmitApplicationEvent(application));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Mechanic Apply',
          style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surfaceContainer,
              backgroundImage: const AssetImage('assets/images/person.png'),
            ),
          )
        ],
      ),
      body: BlocConsumer<MechanicBloc, MechanicState>(
        listener: (context, state) {
          if (state is MechanicSubmitSuccess) {
            context.go('/mechanic/pending');
          } else if (state is MechanicFailure) {
            AppToast.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is MechanicLoading;

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).padding.bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Section 1: ID Verification
                      Text(
                        'ID Verification',
                        style: AppTypography.headlineMd.copyWith(
                          color: AppColors.onSurface,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Upload your National ID or Passport to verify your identity.',
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),

                      GestureDetector(
                        onTap: _simulateUploadId,
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.outlineVariant,
                              style: BorderStyle.solid,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isUploadingId)
                                const CircularProgressIndicator()
                              else if (_uploadedIdName != null) ...[
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: AppColors.tertiary,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _uploadedIdName!,
                                  style: AppTypography.labelBold.copyWith(
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ] else ...[
                                const Icon(
                                  Icons.add_a_photo,
                                  color: AppColors.primary,
                                  size: 36,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to Upload ID',
                                  style: AppTypography.labelBold.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section 2: Expertise selection
                      Text(
                        'Your Expertise',
                        style: AppTypography.headlineMd.copyWith(
                          color: AppColors.onSurface,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          'Bike Specialist',
                          'Car Engine',
                          'Tire & Suspension',
                          'Electrical',
                        ].map((skill) {
                          final isChecked = _selectedExpertise.contains(skill);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isChecked) {
                                  _selectedExpertise.remove(skill);
                                } else {
                                  _selectedExpertise.add(skill);
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
                                color: isChecked
                                    ? AppColors.primary
                                    : AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                skill,
                                style: AppTypography.labelBold.copyWith(
                                  color: isChecked ? Colors.white : AppColors.onSurface,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Section 3: Business Type sliding selector
                      Text(
                        'Business Type',
                        style: AppTypography.headlineMd.copyWith(
                          color: AppColors.onSurface,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
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
                                  setState(() {
                                    _businessTypeIndex = 0;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    color: _businessTypeIndex == 0
                                        ? AppColors.surfaceContainerLowest
                                        : Colors.transparent,
                                  ),
                                  child: Text(
                                    'Mobile Freelancer',
                                    style: AppTypography.labelBold.copyWith(
                                      color: _businessTypeIndex == 0
                                          ? AppColors.onSurface
                                          : AppColors.onSurfaceVariant,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _businessTypeIndex = 1;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    color: _businessTypeIndex == 1
                                        ? AppColors.surfaceContainerLowest
                                        : Colors.transparent,
                                  ),
                                  child: Text(
                                    'Garage Owner',
                                    style: AppTypography.labelBold.copyWith(
                                      color: _businessTypeIndex == 1
                                          ? AppColors.onSurface
                                          : AppColors.onSurfaceVariant,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section 4: Operating Area radius mockup map
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Operating Area',
                            style: AppTypography.headlineMd.copyWith(
                              color: AppColors.onSurface,
                              fontSize: 18,
                            ),
                          ),
                          const Icon(
                            Icons.my_location,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap map to lock your service radius coordinates.',
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Container(
                                  color: const Color(0xFFE5E2E0),
                                  child: CustomPaint(
                                    painter: MapPainter(),
                                  ),
                                ),
                              ),
                              Center(
                                child: Icon(
                                  Icons.location_on,
                                  color: AppColors.primary,
                                  size: 36,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                GestureDetector(
                  onTap: isLoading ? null : _submitApplication,
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
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Submit for Verification',
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
          );
        },
      ),
    );
  }
}
