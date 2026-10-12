import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/mechanic_dashboard_bloc.dart';
import '../bloc/mechanic_dashboard_event.dart';
import '../bloc/mechanic_dashboard_state.dart';
import 'package:go_router/go_router.dart';

class MechanicDashboardPage extends StatefulWidget {
  const MechanicDashboardPage({super.key});

  @override
  State<MechanicDashboardPage> createState() => _MechanicDashboardPageState();
}

class _MechanicDashboardPageState extends State<MechanicDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<MechanicDashboardBloc>().add(const FetchOngoingJobsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
        elevation: 0,
        title: Text(
          'Dashboard',
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
      body: BlocBuilder<MechanicDashboardBloc, MechanicDashboardState>(
        builder: (context, state) {
          if (state is MechanicDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MechanicDashboardSuccess) {
            final jobs = state.jobs;

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Queue Status Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'CURRENT QUEUE',
                              style: AppTypography.labelBold.copyWith(
                                color: AppColors.onPrimary.withValues(alpha: 0.8),
                                letterSpacing: 1.5,
                              ),
                            ),
                            const Icon(
                              Icons.engineering,
                              color: Colors.white,
                              size: 32,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${jobs.length}',
                              style: AppTypography.metricXl.copyWith(
                                color: Colors.white,
                                fontSize: 48,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Active Jobs',
                              style: AppTypography.headlineMd.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Receiving new requests',
                                style: AppTypography.labelBold.copyWith(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Ongoing Tasks Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ongoing Tasks',
                        style: AppTypography.headlineMd.copyWith(
                          color: AppColors.onSurface,
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.filter_list,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tasks List
                  ...jobs.map((job) => _buildJobCard(job)),
                ],
              ),
            );
          }

          return const Center(child: Text('Failed to load queue data.'));
        },
      ),
    );
  }

  Widget _buildJobCard(dynamic job) {
    IconData getStatusIcon(String status) {
      if (status == 'Repairing') return Icons.build;
      if (status == 'En Route') return Icons.near_me;
      return Icons.search;
    }

    return GestureDetector(
      onTap: () => context.push('/mechanic/incoming/${job.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            children: [
              Container(
                height: 140,
                width: double.infinity,
                color: AppColors.surfaceContainerLow,
                child: Image.asset(
                  'assets/images/car.png',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${job.title} (${job.vehicleModel})',
                      style: AppTypography.headlineMd.copyWith(
                        fontSize: 18,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job.description,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          getStatusIcon(job.status),
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${job.status} • ${job.timestamp}',
                          style: AppTypography.labelBold.copyWith(
                            color: AppColors.primary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
