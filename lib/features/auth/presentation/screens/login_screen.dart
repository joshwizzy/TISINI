import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/features/auth/domain/entities/login_state.dart';
import 'package:tisini/features/auth/providers/login_controller_provider.dart';
import 'package:tisini/shared/widgets/primary_button.dart';
import 'package:tisini/shared/widgets/tisini_logo.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  static const _countryPrefix = '+256';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool get _isPhoneValid => _phoneController.text.length >= 9;

  String get _fullPhoneNumber => '$_countryPrefix${_phoneController.text}';

  void _onContinue() {
    ref.read(loginControllerProvider.notifier).requestOtp(_fullPhoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState.valueOrNull is LoginStateRequestingOtp;

    ref.listen(loginControllerProvider, (prev, next) {
      final value = next.valueOrNull;
      if (value is LoginStateOtpSent) {
        context.go('/otp');
      }
    });

    final errorMessage = loginState.valueOrNull is LoginStateError
        ? (loginState.valueOrNull! as LoginStateError).message
        : null;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const TisiniLogo(size: 32),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              const Text(
                'Enter your phone number',
                style: AppTypography.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                "We'll send you a verification code",
                style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: const Center(
                      child: Text(
                        _countryPrefix,
                        style: AppTypography.bodyLarge,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: AppTypography.bodyLarge,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: '7XX XXX XXX',
                          hintStyle: AppTypography.bodyLarge.copyWith(
                            color: AppColors.grey40,
                          ),
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.cardBorder,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.cardBorder,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.cyan,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  errorMessage,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.red),
                ),
              ],
              const Spacer(),
              PrimaryButton(
                label: 'Continue',
                onPressed: _isPhoneValid ? _onContinue : null,
                isLoading: isLoading,
                isEnabled: _isPhoneValid,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
