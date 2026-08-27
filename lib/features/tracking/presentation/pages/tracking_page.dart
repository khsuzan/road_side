import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/tracking_bloc.dart';
import '../bloc/tracking_event.dart';
import '../bloc/tracking_state.dart';

class TrackingPage extends StatefulWidget {
  final String requestId;
  const TrackingPage({super.key, required this.requestId});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _routeAnimController;

  @override
  void initState() {
    super.initState();
    _routeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    context
        .read<TrackingBloc>()
        .add(FetchTrackingStatusEvent(widget.requestId));
  }

  @override
  void dispose() {
    _routeAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Active Service Tracking',
          style: AppTypography.headlineMd.copyWith(
            fontSize: 20,
            color: AppColors.onSurface,
          ),
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
      body: BlocBuilder<TrackingBloc, TrackingState>(
        builder: (context, state) {
          if (state is TrackingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TrackingSuccess) {
            final status = state.status;

            return Stack(
              children: [
                // Full Screen Map with Animated route Polyline
                Positioned.fill(
                  child: Container(
                    color: const Color(0xFFE5E2E0),
                    child: CustomPaint(
                      painter: RoutePainter(
                        animationValue: _routeAnimController.value,
                      ),
                    ),
                  ),
                ),

                // Top status overlay banner
                Positioned(
                  top: 24,
                  left: 24,
                  right: 24,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Mechanic is on the way • ${status.etaMinutes} mins',
                            style: AppTypography.labelBold.copyWith(
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom sheet sliding layout containing mechanic and verification PIN info
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 24,
                      bottom: MediaQuery.of(context).padding.bottom + 24,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 30,
                          offset: const Offset(0, -10),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Handler bar decoration
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ),

                        // Mechanic Profile card info
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: AppColors.surfaceContainer,
                              backgroundImage:
                                  const AssetImage('assets/images/person.png'),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        status.mechanicName,
                                        style: AppTypography.headlineMd.copyWith(
                                          fontSize: 18,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceVariant,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: AppColors.primary,
                                              size: 12,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${status.mechanicRating}',
                                              style: AppTypography.labelBold
                                                  .copyWith(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    status.vanModel,
                                    style: AppTypography.bodyMd.copyWith(
                                      color: AppColors.secondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${status.etaMinutes}',
                                  style: AppTypography.metricXl.copyWith(
                                    fontSize: 32,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                Text(
                                  'MINS',
                                  style: AppTypography.labelBold.copyWith(
                                    fontSize: 9,
                                    color: AppColors.secondary,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Connected Stepper timeline progress
                        _buildStepperTimeline(status.currentStep),
                        const SizedBox(height: 24),

                        // Action controls
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                  'Call', Icons.call, () {}),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildActionButton(
                                  'Chat', Icons.chat_bubble, () {}),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                // SOS Trigger
                              },
                              child: Container(
                                width: 56,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.sos,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Glass verification pin box
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.inverseSurface,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.lock_outline,
                                        color: AppColors.inversePrimary,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Job Verification PIN',
                                        style: AppTypography.labelBold.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Share on arrival',
                                    style: AppTypography.bodyMd.copyWith(
                                      color: AppColors.secondaryFixedDim,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: status.verificationPin
                                    .split('')
                                    .map((digit) => _buildPinCell(digit))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('Failed to load tracking status.'));
        },
      ),
    );
  }

  Widget _buildPinCell(String val) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        val,
        style: AppTypography.metricXl.copyWith(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.onSurface, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.labelBold.copyWith(
                color: AppColors.onSurface,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperTimeline(String activeStep) {
    final steps = ['Dispatched', 'En Route', 'Arrived', 'Repairing'];
    final activeIndex = steps.indexOf(activeStep);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (index) {
        final step = steps[index];
        final isCompleted = index < activeIndex;
        final isActive = index == activeIndex;

        return Expanded(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Timeline connector
                  if (index < 3)
                    Positioned(
                      left: 20,
                      right: -20,
                      child: Container(
                        height: 2,
                        color: index < activeIndex
                            ? AppColors.primary
                            : AppColors.surfaceVariant,
                      ),
                    ),
                  Container(
                    width: isActive ? 24 : 16,
                    height: isActive ? 24 : 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? AppColors.primary
                          : (isActive
                              ? AppColors.surfaceContainerLowest
                              : AppColors.surfaceVariant),
                      border: isActive
                          ? Border.all(color: AppColors.primary, width: 3)
                          : null,
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 10,
                          )
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                step,
                style: AppTypography.labelBold.copyWith(
                  fontSize: 9,
                  color: isActive
                      ? AppColors.primary
                      : (isCompleted
                          ? AppColors.onSurface
                          : AppColors.secondary),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }),
    );
  }
}

// Route Painter that animates sliding dashes along a Bezier path
class RoutePainter extends CustomPainter {
  final double animationValue;

  RoutePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw static grid underlay
    final gridPaint = Paint()
      ..color = AppColors.onSurface.withValues(alpha: 0.04)
      ..strokeWidth = 1.0;

    const patternSize = 40.0;
    for (double x = 0; x < size.width; x += patternSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += patternSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 2. Draw static background map road
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 12.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.35, size.height * 0.25);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.5,
      size.width * 0.65,
      size.height * 0.75,
    );

    canvas.drawPath(path, roadPaint);

    // 3. Draw animated sliding route polyline
    final activeRoutePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final pathMetrics = path.computeMetrics();
    for (var metric in pathMetrics) {
      final totalLength = metric.length;
      final offset = (animationValue * totalLength) % totalLength;
      
      final activePath = Path();
      // Draw segmented dashes sliding along path length
      for (double d = 0; d < totalLength; d += 20) {
        final start = (d + offset) % totalLength;
        final end = (start + 10) % totalLength;
        if (start < end) {
          activePath.addPath(metric.extractPath(start, end), Offset.zero);
        }
      }
      canvas.drawPath(activePath, activeRoutePaint);
    }

    // 4. Draw endpoints
    final customerPaint = Paint()
      ..color = AppColors.onSurface
      ..style = PaintingStyle.fill;
    final customerBorder = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final startOffset = Offset(size.width * 0.35, size.height * 0.25);
    canvas.drawCircle(startOffset, 8, customerPaint);
    canvas.drawCircle(startOffset, 8, customerBorder);

    final mechanicPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    final mechanicBorder = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final endOffset = Offset(size.width * 0.65, size.height * 0.75);
    canvas.drawCircle(endOffset, 12, mechanicPaint);
    canvas.drawCircle(endOffset, 12, mechanicBorder);
  }

  @override
  bool shouldRepaint(covariant RoutePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
