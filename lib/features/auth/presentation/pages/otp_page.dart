import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/toast_utils.dart';

class OtpPage extends StatefulWidget {
  final String phone;
  const OtpPage({super.key, required this.phone});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with SingleTickerProviderStateMixin {
  late final List<TextEditingController> _otpControllers;
  late final List<FocusNode> _otpFocusNodes;
  double _heroScale = 1.1;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(4, (_) => TextEditingController());
    _otpFocusNodes = List.generate(4, (_) => FocusNode());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _heroScale = 1.0;
      });
      _otpFocusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      _otpFocusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  bool get _isOtpComplete {
    return _otpControllers.every((controller) => controller.text.length == 1);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            AppToast.showSuccess(context, 'Access Granted!');
            if (state.token.contains('mechanic')) {
              context.go('/mechanic/dashboard');
            } else {
              context.go('/dashboard');
            }
          } else if (state is AuthFailure) {
            AppToast.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Stack(
            children: [
              // 1. Background Image covering the entire screen
              Positioned.fill(
                child: AnimatedScale(
                  scale: _heroScale,
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeOutBack,
                  child: Image.asset(
                    'assets/images/login-background.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // 2. Ambient Light Overlay
              Positioned(
                bottom: screenHeight * 0.45,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: const BorderRadius.all(
                        Radius.elliptical(200, 50),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Floating Content Card at the bottom
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom +
                    MediaQuery.of(context).viewInsets.bottom +
                    24,
                left: 24,
                right: 24,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: _buildOtpVerificationView(context, isLoading),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOtpVerificationView(BuildContext context, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Text(
          'Verification',
          style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Enter the 4-digit code sent to',
          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          widget.phone,
          style: AppTypography.labelBold.copyWith(color: AppColors.onSurface),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // 4 OTP Boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            return Container(
              width: 56,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: TextField(
                controller: _otpControllers[index],
                focusNode: _otpFocusNodes[index],
                onChanged: (val) => _onOtpChanged(index, val),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: AppTypography.metricXl.copyWith(
                  color: AppColors.onSurface,
                  fontSize: 28,
                ),
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),

        // Resend section
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive the code? ",
              style: AppTypography.bodyMd.copyWith(color: AppColors.secondary),
            ),
            GestureDetector(
              onTap: () {
                context.read<AuthBloc>().add(SendOtpEvent(widget.phone));
              },
              child: Text(
                'Resend',
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.primary,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 32),

        // Back to Phone / Reset & Verify Buttons
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.read<AuthBloc>().add(const ResetAuthEvent());
                context.pop();
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: isLoading
                    ? null
                    : () {
                        final code = _otpControllers.map((c) => c.text).join();
                        if (code.length == 4) {
                          context.read<AuthBloc>().add(VerifyOtpEvent(
                                widget.phone,
                                code,
                              ));
                        }
                      },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9999),
                    color: _isOtpComplete
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.5),
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
                      : Text(
                          'Verify & Continue',
                          style: AppTypography.labelBold.copyWith(
                            color: AppColors.onPrimary,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
