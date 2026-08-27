import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart'; // Import MapPainter
import '../bloc/mechanic_job_bloc.dart';
import '../bloc/mechanic_job_event.dart';
import '../bloc/mechanic_job_state.dart';
import 'job_detail_page.dart';

class IncomingJobPage extends StatefulWidget {
  final String jobId;
  const IncomingJobPage({super.key, required this.jobId});

  @override
  State<IncomingJobPage> createState() => _IncomingJobPageState();
}

class _IncomingJobPageState extends State<IncomingJobPage> {
  @override
  void initState() {
    super.initState();
    context.read<MechanicJobBloc>().add(FetchJobDetailEvent(widget.jobId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MechanicJobBloc, MechanicJobState>(
        builder: (context, state) {
          if (state is MechanicJobLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MechanicJobDetailSuccess) {
            final job = state.job;

            return Stack(
              children: [
                // Simulated Map underlay
                Positioned.fill(
                  child: Container(
                    color: const Color(0xFFE5E2E0),
                    child: CustomPaint(
                      painter: MapPainter(),
                    ),
                  ),
                ),

                // Top appbar back button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 24,
                  child: GestureDetector(
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
                ),

                // Center animated marker pin
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        child: const Icon(Icons.build, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom floating client card details
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 40,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Customer header row
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    job.customerName,
                                    style: AppTypography.headlineMd.copyWith(
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: AppColors.onSurfaceVariant,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '0.5 mi • ${job.etaText}',
                                        style: AppTypography.bodyMd.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.surfaceContainer,
                              backgroundImage:
                                  const AssetImage('assets/images/person.png'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Reported issues pills
                        Text(
                          'REPORTED ISSUES',
                          style: AppTypography.labelBold.copyWith(
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 1.2,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: job.reportedIssues
                              .map(
                                (issue) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainer,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: AppColors.surfaceContainerHigh,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Text(
                                    issue,
                                    style: AppTypography.bodyMd.copyWith(
                                      color: AppColors.onSurface,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 20),

                        // Audio Message Player Box
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: AppColors.primaryContainer,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(12, (index) {
                                    final activeColor = index > 5
                                        ? AppColors.primaryContainer
                                        : AppColors.onSurfaceVariant;
                                    final heights = [
                                      0.4,
                                      0.6,
                                      1.0,
                                      0.8,
                                      0.5,
                                      0.9,
                                      0.7,
                                      0.3,
                                      0.6,
                                      0.4,
                                      0.8,
                                      0.5
                                    ];
                                    return Container(
                                      width: 3,
                                      height: 24 * heights[index],
                                      decoration: BoxDecoration(
                                        color: activeColor,
                                        borderRadius:
                                            BorderRadius.circular(1.5),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                job.audioDurationText,
                                style: AppTypography.labelBold.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Evidence pictures list
                        Text(
                          'PHOTOS / VIDEO',
                          style: AppTypography.labelBold.copyWith(
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 1.2,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 96,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.outlineVariant,
                                    style: BorderStyle.solid,
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.videocam,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/car.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Action accept button
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => JobDetailPage(jobId: job.id),
                              ),
                            );
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9999),
                              color: AppColors.primaryContainer,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Accept & Start Navigation',
                                  style: AppTypography.headlineMd.copyWith(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.navigation,
                                  color: Colors.white,
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
            );
          }

          return const Center(child: Text('Failed to load incoming job.'));
        },
      ),
    );
  }
}
