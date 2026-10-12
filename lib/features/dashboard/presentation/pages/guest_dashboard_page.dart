import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/map_painter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/toast_utils.dart';

class GuestDashboardPage extends StatelessWidget {
  const GuestDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64 + MediaQuery.of(context).padding.top),
        child: Container(
          height: 64 + MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.flash_on,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Super Car Repair',
                      style: AppTypography.headlineMd.copyWith(
                        fontSize: 20,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'login':
                        context.push('/login');
                        break;
                      case 'membership':
                        AppToast.showInfo(context, 'Please log in to view membership');
                        break;
                      case 'privacy':
                        AppToast.showInfo(context, 'Privacy Policy Displayed');
                        break;
                      case 'mechanic':
                        context.push('/mechanic/register');
                        break;
                      case 'support':
                        AppToast.showInfo(context, 'Connecting to Support...');
                        break;
                    }
                  },
                  offset: const Offset(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: AppColors.surfaceContainerLowest,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      border: Border.all(
                        color: AppColors.surfaceContainer,
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: AppColors.secondary,
                    ),
                  ),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'login',
                      child: Row(
                        children: [
                          const Icon(Icons.login, color: AppColors.primary, size: 20),
                          const SizedBox(width: 12),
                          Text('Log In', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface)),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'membership',
                      child: Row(
                        children: [
                          const Icon(Icons.card_membership, color: AppColors.secondary, size: 20),
                          const SizedBox(width: 12),
                          Text('Membership', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface)),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'privacy',
                      child: Row(
                        children: [
                          const Icon(Icons.privacy_tip_outlined, color: AppColors.secondary, size: 20),
                          const SizedBox(width: 12),
                          Text('Privacy Policy', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface)),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'mechanic',
                      child: Row(
                        children: [
                          const Icon(Icons.engineering_outlined, color: AppColors.primary, size: 20),
                          const SizedBox(width: 12),
                          Text('Apply for Mechanic', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface)),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'support',
                      child: Row(
                        children: [
                          const Icon(Icons.support_agent_outlined, color: AppColors.secondary, size: 20),
                          const SizedBox(width: 12),
                          Text('Contact Support', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Map Mockup Background
          Positioned.fill(
            child: Container(
              color: const Color(0xFFE5E2E0), // Soft Map background Color
              child: CustomPaint(
                painter: MapPainter(),
              ),
            ),
          ),

          // Floating controls
          Positioned(
            top: 24,
            right: 24,
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: const Icon(Icons.my_location, color: AppColors.onSurface),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: const Icon(Icons.layers, color: AppColors.onSurface),
                ),
              ],
            ),
          ),

          // Floating Content Card
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
                    'Premium Car Care, Anywhere.',
                    style: AppTypography.headlineMd.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore nearby elite mechanics and world-class detailing services.',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => context.push('/login'),
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
                            'Request Repair',
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
}
