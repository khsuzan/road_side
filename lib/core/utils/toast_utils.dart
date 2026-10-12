import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppToast {
  static void showSuccess(BuildContext context, String message) {
    const duration = Duration(seconds: 4);
    toastification.showCustom(
      context: context,
      autoCloseDuration: duration,
      alignment: Alignment.topCenter,
      animationDuration: const Duration(milliseconds: 300),
      builder: (context, holder) {
        return CompactToastWidget(
          holder: holder,
          title: 'Success',
          description: message,
          icon: Icons.check_circle_outline,
          backgroundColor: AppColors.primary, // Primary color as requested
          textColor: AppColors.onPrimary,     // On-primary text as requested
          duration: duration,
        );
      },
    );
  }

  static void showError(BuildContext context, String message) {
    const duration = Duration(seconds: 5);
    toastification.showCustom(
      context: context,
      autoCloseDuration: duration,
      alignment: Alignment.topCenter,
      animationDuration: const Duration(milliseconds: 300),
      builder: (context, holder) {
        return CompactToastWidget(
          holder: holder,
          title: 'Error',
          description: message,
          icon: Icons.error_outline,
          backgroundColor: AppColors.error,   // Error red as requested
          textColor: Colors.white,
          duration: duration,
        );
      },
    );
  }

  static void showInfo(BuildContext context, String message) {
    const duration = Duration(seconds: 4);
    toastification.showCustom(
      context: context,
      autoCloseDuration: duration,
      alignment: Alignment.topCenter,
      animationDuration: const Duration(milliseconds: 300),
      builder: (context, holder) {
        return CompactToastWidget(
          holder: holder,
          title: 'Info',
          description: message,
          icon: Icons.info_outline,
          backgroundColor: AppColors.secondary, // Grayed background color as requested
          textColor: Colors.white,
          duration: duration,
        );
      },
    );
  }
}

class CompactToastWidget extends StatelessWidget {
  final ToastificationItem holder;
  final String title;
  final String description;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Duration duration;

  const CompactToastWidget({
    super.key,
    required this.holder,
    required this.title,
    required this.description,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: textColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelBold.copyWith(
                      color: textColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: AppTypography.bodyMd.copyWith(
                      color: textColor.withValues(alpha: 0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => toastification.dismiss(holder),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _ToastCountdownProgress(
                    duration: duration,
                    color: textColor,
                    onFinish: () {},
                  ),
                  Icon(
                    Icons.close,
                    color: textColor.withValues(alpha: 0.7),
                    size: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToastCountdownProgress extends StatefulWidget {
  final Duration duration;
  final Color color;
  final VoidCallback onFinish;

  const _ToastCountdownProgress({
    required this.duration,
    required this.color,
    required this.onFinish,
  });

  @override
  State<_ToastCountdownProgress> createState() => _ToastCountdownProgressState();
}

class _ToastCountdownProgressState extends State<_ToastCountdownProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.forward().then((_) {
      if (mounted) {
        widget.onFinish();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            value: 1.0 - _controller.value,
            strokeWidth: 2.0,
            backgroundColor: widget.color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(widget.color),
          ),
        );
      },
    );
  }
}
