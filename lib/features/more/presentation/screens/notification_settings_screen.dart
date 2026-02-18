import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/features/more/presentation/widgets/settings_toggle_tile.dart';
import 'package:tisini/features/more/providers/more_provider.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(notificationSettingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: settingsAsync.when(
        data: (settings) => ListView(
          children: [
            SettingsToggleTile(
              title: 'Payment Received',
              value: settings.paymentReceived,
              onChanged: (_) {},
            ),
            SettingsToggleTile(
              title: 'PIA Cards',
              value: settings.piaCards,
              onChanged: (_) {},
            ),
            SettingsToggleTile(
              title: 'Pension Reminders',
              value: settings.pensionReminders,
              onChanged: (_) {},
            ),
            SettingsToggleTile(
              title: 'Promotions',
              value: settings.promotions,
              onChanged: (_) {},
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text('Failed to load notification settings')),
      ),
    );
  }
}
