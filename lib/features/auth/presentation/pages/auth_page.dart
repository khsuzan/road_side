import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  late final PageController _pageController;
  late final TextEditingController _phoneController;
  late final List<TextEditingController> _otpControllers;
  late final List<FocusNode> _otpFocusNodes;

  double _heroScale = 1.1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _phoneController = TextEditingController();
    _otpControllers = List.generate(4, (_) => TextEditingController());
    _otpFocusNodes = List.generate(4, (_) => FocusNode());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _heroScale = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _phoneController.dispose();
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpSentState) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
            _otpFocusNodes[0].requestFocus();
          } else if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Access Granted!')),
            );
            // Navigate to Home dashboard page.
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
                child: Column(
                  children: [
                    // Top Image Hero Container
                    Expanded(
                      flex: 4,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedScale(
                            scale: _heroScale,
                            duration: const Duration(seconds: 2),
                            curve: Curves.easeOutBack,
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Image.asset(
                                'assets/images/login-background.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          // Ambient Light blur circle shadow
                          Positioned(
                            bottom: 20,
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
                        ],
                      ),
                    ),

                    // Elevated Card Content
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            // PHONE INPUT VIEW
                            _buildPhoneInputView(context, isLoading),
                            // OTP VERIFICATION VIEW
                            _buildOtpVerificationView(context, isLoading),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhoneInputView(BuildContext context, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          const SizedBox(height: 48),

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
          const Spacer(),

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
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOtpVerificationView(BuildContext context, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
            '+880 ${_phoneController.text}',
            style: AppTypography.labelBold.copyWith(color: AppColors.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
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
                  context
                      .read<AuthBloc>()
                      .add(SendOtpEvent(_phoneController.text.trim()));
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

          const Spacer(),

          // Back to Phone / Reset & Verify Buttons
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.read<AuthBloc>().add(const ResetAuthEvent());
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: isLoading
                      ? null
                      : () {
                          final code = _otpControllers
                              .map((c) => c.text)
                              .join();
                          if (code.length == 4) {
                            context.read<AuthBloc>().add(VerifyOtpEvent(
                                  _phoneController.text.trim(),
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
