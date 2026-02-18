import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/features/onboarding/providers/permissions_provider.dart';
import 'package:tisini/shared/widgets/permission_card.dart';
import 'package:tisini/shared/widgets/primary_button.dart';

class PermissionsScreen extends ConsumerWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(permissionsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxxl),
              const Text(
                'A couple of things',
                style: AppTypography.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'These permissions help us give you '
                'the best experience.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
              ),
              const SizedBox(height: AppSpacing.xl),
              PermissionCard(
                icon: PhosphorIconsBold.bell,
                title: 'Notifications',
                description:
                    'Get alerts for payments, '
                    'reminders, and important updates.',
                isGranted: state.notificationsGranted,
                onRequest: () {
                  // TODO(tisini): Request actual permission
                  ref
                      .read(permissionsProvider.notifier)
                      .setNotificationsGranted(granted: true);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              PermissionCard(
                icon: PhosphorIconsBold.camera,
                title: 'Camera',
                description:
                    'Scan QR codes for quick payments '
                    'and verify your identity.',
                isGranted: state.cameraGranted,
                onRequest: () {
                  // TODO(tisini): Request actual permission
                  ref
                      .read(permissionsProvider.notifier)
                      .setCameraGranted(granted: true);
                },
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Get started',
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
