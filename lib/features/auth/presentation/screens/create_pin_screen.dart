import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/features/auth/domain/entities/pin_state.dart';
import 'package:tisini/features/auth/providers/biometric_available_provider.dart';
import 'package:tisini/features/auth/providers/pin_controller_provider.dart';
import 'package:tisini/shared/widgets/pin_dots.dart';
import 'package:tisini/shared/widgets/pin_numpad.dart';

class CreatePinScreen extends ConsumerStatefulWidget {
  const CreatePinScreen({super.key});

  @override
  ConsumerState<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends ConsumerState<CreatePinScreen> {
  String _currentPin = '';

  void _onDigit(String digit) {
    if (_currentPin.length >= 4) return;
    setState(() => _currentPin += digit);

    if (_currentPin.length == 4) {
      _onPinComplete();
    }
  }

  void _onBackspace() {
    if (_currentPin.isEmpty) return;
    setState(() {
      _currentPin = _currentPin.substring(0, _currentPin.length - 1);
    });
  }

  void _onPinComplete() {
    final state = ref.read(pinControllerProvider).valueOrNull;
    if (state is PinStateEnteringPin) {
      ref.read(pinControllerProvider.notifier).enterPin(_currentPin);
      setState(() => _currentPin = '');
    } else if (state is PinStateConfirmingPin) {
      ref.read(pinControllerProvider.notifier).confirmPin(_currentPin);
      setState(() => _currentPin = '');
    }
  }

  Future<void> _showBiometricDialog() async {
    final router = GoRouter.of(context);
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Enable biometric login?'),
        content: const Text(
          'Use your fingerprint or face to log in '
          'faster next time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Skip',
              style: AppTypography.labelLarge.copyWith(color: AppColors.grey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Enable',
              style: AppTypography.labelLarge.copyWith(color: AppColors.cyan),
            ),
          ),
        ],
      ),
    );

    if (result ?? false) {
      await ref.read(pinControllerProvider.notifier).enableBiometric();
    }

    router.go('/permissions');
  }

  @override
  Widget build(BuildContext context) {
    final pinState = ref.watch(pinControllerProvider);
    final value = pinState.valueOrNull;
    final isConfirming = value is PinStateConfirmingPin;
    final hasError = value is PinStateError;

    ref.listen(pinControllerProvider, (prev, next) async {
      final nextValue = next.valueOrNull;
      if (nextValue is PinStatePinCreated) {
        final router = GoRouter.of(context);
        final biometricAvailable = await ref.read(
          biometricAvailableProvider.future,
        );
        if (biometricAvailable && mounted) {
          await _showBiometricDialog();
        } else if (mounted) {
          router.go('/permissions');
        }
      }
      if (nextValue is PinStateError) {
        setState(() => _currentPin = '');
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl),
              Text(
                isConfirming ? 'Confirm your PIN' : 'Create your PIN',
                style: AppTypography.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                isConfirming
                    ? 'Enter your PIN again to confirm'
                    : 'Choose a 4-digit PIN to secure '
                          'your account',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              PinDots(filledCount: _currentPin.length, hasError: hasError),
              if (value case final PinStateError error) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  error.message,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.red),
                ),
              ],
              const Spacer(),
              PinNumpad(
                onDigit: _onDigit,
                onBackspace: _onBackspace,
                isEnabled: value is! PinStateCreatingPin,
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
