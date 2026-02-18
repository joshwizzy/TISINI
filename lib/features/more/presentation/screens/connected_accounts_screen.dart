import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/more/presentation/widgets/connected_account_tile.dart';
import 'package:tisini/features/more/providers/more_provider.dart';

class ConnectedAccountsScreen extends ConsumerWidget {
  const ConnectedAccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(connectedAccountsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Connected Accounts'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: accountsAsync.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'No accounts connected',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton(
                    onPressed: () => context.goNamed(RouteNames.connectAccount),
                    child: const Text('Add Account'),
                  ),
                ],
              ),
            );
          }
          return ListView(
            children: [
              ...accounts.map(
                (account) =>
                    ConnectedAccountTile(account: account, onDisconnect: () {}),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: OutlinedButton(
                  onPressed: () => context.goNamed(RouteNames.connectAccount),
                  child: const Text('Add Account'),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to load accounts')),
      ),
    );
  }
}
