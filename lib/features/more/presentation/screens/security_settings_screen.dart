import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/features/more/presentation/widgets/settings_toggle_tile.dart';
import 'package:tisini/features/more/providers/more_provider.dart';

class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(securitySettingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Security'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: settingsAsync.when(
        data: (settings) => ListView(
          children: [
            SettingsToggleTile(
              title: 'PIN',
              value: settings.pinEnabled,
              onChanged: (_) {},
              enabled: false,
            ),
            SettingsToggleTile(
              title: 'Biometric Login',
              value: settings.biometricEnabled,
              onChanged: (_) {},
            ),
            SettingsToggleTile(
              title: 'Two-Step Verification',
              value: settings.twoStepEnabled,
              onChanged: (_) {},
            ),
            if (settings.trustedDevices.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  'Trusted Devices',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.darkBlue,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...settings.trustedDevices.map(
                (device) => ListTile(
                  leading: const Icon(
                    Icons.phone_android,
                    color: AppColors.grey,
                  ),
                  title: Text(device, style: AppTypography.bodyMedium),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                ),
              ),
            ],
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text('Failed to load security settings')),
      ),
    );
  }
}
