import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';

class OngoingServicesPage extends StatelessWidget {
  const OngoingServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Active Service',
          style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surfaceContainer,
              backgroundImage: const AssetImage('assets/images/person.png'),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: Column(
          children: [
            // Active Job Card 1: Toyota Corolla '23
            _buildActiveJobCard(
              context: context,
              title: "Toyota Corolla '23",
              plate: "LXO 892V",
              statusText: "In Progress",
              isPulsing: true,
              imageUrl: "assets/images/car.png",
              techName: "Marcus T.",
              techRole: "Master Technician",
              etaLabel: "Est. Completion",
              etaValue: "14:30",
              progress: 0.70,
              progressLabels: const ["Request", "Dispatch", "Repair", "Complete"],
              btn1Text: "Contact",
              btn1Icon: Icons.chat,
              btn2Text: "Track Live",
              btn2Icon: Icons.location_on,
              onBtn2Tap: () {
                context.push('/tracking/req_1');
              },
            ),
            const SizedBox(height: 24),

            // Active Job Card 2: Yamaha R15
            _buildActiveJobCard(
              context: context,
              title: "Yamaha R15",
              plate: "MTC 401",
              statusText: "En Route",
              isPulsing: false,
              imageUrl: "assets/images/bike.png",
              techName: "Elena R.",
              techRole: "Mobile Unit 4",
              etaLabel: "Arriving in",
              etaValue: "12 min",
              progress: 0.45,
              progressLabels: const ["Request", "Dispatch", "Repair", "Complete"],
              btn1Text: "Call",
              btn1Icon: Icons.call,
              btn2Text: "Map View",
              btn2Icon: Icons.map,
              onBtn2Tap: () {
                context.push('/tracking/req_2');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveJobCard({
    required BuildContext context,
    required String title,
    required String plate,
    required String statusText,
    required bool isPulsing,
    required String imageUrl,
    required String techName,
    required String techRole,
    required String etaLabel,
    required String etaValue,
    required double progress,
    required List<String> progressLabels,
    required String btn1Text,
    required IconData btn1Icon,
    required String btn2Text,
    required IconData btn2Icon,
    required VoidCallback onBtn2Tap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header: Vehicle & Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.headlineMd.copyWith(
                            fontSize: 18,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Text(
                          plate,
                          style: AppTypography.labelBold.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isPulsing)
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          Text(
                            statusText,
                            style: AppTypography.labelBold.copyWith(
                              color: AppColors.primary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Vehicle Image
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Mechanic Profile & ETA
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('assets/images/person.png'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              techName,
                              style: AppTypography.labelBold.copyWith(
                                color: AppColors.onSurface,
                              ),
                            ),
                            Text(
                              techRole,
                              style: AppTypography.bodyMd.copyWith(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            etaLabel,
                            style: AppTypography.bodyMd.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            etaValue,
                            style: AppTypography.headlineMd.copyWith(
                              fontSize: 18,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Progress Tracker
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(progressLabels.length, (index) {
                    final label = progressLabels[index];
                    final stepVal = index / (progressLabels.length - 1);
                    final isReached = stepVal <= progress;

                    return Text(
                      label,
                      style: AppTypography.labelBold.copyWith(
                        fontSize: 11,
                        color: isReached ? AppColors.primary : AppColors.onSurfaceVariant,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 20),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Btn 1 Tap
                        },
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: AppColors.surfaceVariant),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(btn1Icon, color: AppColors.onSurface, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                btn1Text,
                                style: AppTypography.labelBold.copyWith(
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: onBtn2Tap,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(btn2Icon, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                btn2Text,
                                style: AppTypography.labelBold.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
