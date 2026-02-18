import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/domain/entities/send_state.dart';
import 'package:tisini/features/pay/providers/send_controller_provider.dart';

class SendFailedScreen extends ConsumerWidget {
  const SendFailedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendState = ref.watch(sendControllerProvider);
    final state = sendState.valueOrNull;
    final message = state is SendStateFailed
        ? state.message
        : 'Something went wrong';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            children: [
              const Spacer(),
              const Icon(
                PhosphorIconsBold.xCircle,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('Payment Failed', style: AppTypography.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ref.read(sendControllerProvider.notifier).reset();
                        context.goNamed(RouteNames.payHub);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        ref.read(sendControllerProvider.notifier).reset();
                        context.goNamed(RouteNames.sendRecipient);
                      },
                      child: const Text('Try again'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
