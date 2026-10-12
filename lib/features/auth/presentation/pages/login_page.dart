import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/toast_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late final TextEditingController _phoneController;
  double _heroScale = 1.1;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _heroScale = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpSentState) {
            final phone = _phoneController.text.trim();
            context.push('/otp?phone=$phone');
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
                  child: _buildPhoneInputView(context, isLoading),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPhoneInputView(BuildContext context, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Text(
          'Secure Access',
          style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your phone number to continue',
          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Country selection + Phone number input
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.surfaceVariant,
                width: 1.0,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              DropdownButton<String>(
                value: '+880',
                underline: const SizedBox(),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.onSurface,
                  size: 18,
                ),
                onChanged: null,
                items: [
                  DropdownMenuItem(
                    value: '+880',
                    child: Text(
                      '+880',
                      style: AppTypography.labelBold.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: AppTypography.bodyLg.copyWith(color: AppColors.onSurface),
                  decoration: InputDecoration(
                    hintText: '017XX XXXXXX',
                    hintStyle: AppTypography.bodyLg.copyWith(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),

        // Submit Button
        GestureDetector(
          onTap: isLoading
              ? null
              : () {
                  final phone = _phoneController.text.trim();
                  if (phone.isNotEmpty) {
                    context.read<AuthBloc>().add(SendOtpEvent(phone));
                  }
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
            alignment: Alignment.center,
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    'Get Verification Code',
                    style: AppTypography.labelBold.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
