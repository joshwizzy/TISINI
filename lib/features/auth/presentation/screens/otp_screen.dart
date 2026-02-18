import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/features/auth/domain/entities/login_state.dart';
import 'package:tisini/features/auth/presentation/widgets/countdown_timer.dart';
import 'package:tisini/features/auth/providers/login_controller_provider.dart';
import 'package:tisini/shared/widgets/otp_input.dart';

class OtpScreen extends ConsumerWidget {
  const OtpScreen({super.key});

  String _maskPhone(String phone) {
    if (phone.length < 4) return phone;
    final visible = phone.substring(phone.length - 4);
    final masked = '*' * (phone.length - 4);
    return '$masked$visible';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginControllerProvider);
    final value = loginState.valueOrNull;

    // Get phone number from previous state
    String phoneNumber;
    if (value is LoginStateOtpSent) {
      phoneNumber = value.phoneNumber;
    } else {
      phoneNumber = '';
    }

    final isVerifying = value is LoginStateVerifyingOtp;

    final errorMessage = value is LoginStateError ? value.message : null;

    ref.listen(loginControllerProvider, (prev, next) {
      final nextValue = next.valueOrNull;
      if (nextValue is LoginStateVerified) {
        if (nextValue.isNewUser) {
          context.go('/create-pin');
        } else {
          context.go('/home');
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkBlue),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Enter verification code',
                style: AppTypography.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Code sent to ${_maskPhone(phoneNumber)}',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
              ),
              const SizedBox(height: AppSpacing.xl),
              OtpInput(
                onCompleted: (code) {
                  ref.read(loginControllerProvider.notifier).verifyOtp(code);
                },
                errorText: errorMessage,
                isEnabled: !isVerifying,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (isVerifying)
                const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                Center(
                  child: CountdownTimer(
                    seconds: 60,
                    builder: (remaining, {required isComplete}) {
                      if (isComplete) {
                        return TextButton(
                          onPressed: () {
                            ref
                                .read(loginControllerProvider.notifier)
                                .resendOtp();
                          },
                          child: Text(
                            'Resend code',
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.cyan,
                            ),
                          ),
                        );
                      }
                      return Text(
                        'Resend code in ${remaining}s',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.grey,
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
