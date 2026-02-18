import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/domain/entities/connected_account.dart';

class ConnectedAccountTile extends StatelessWidget {
  const ConnectedAccountTile({
    required this.account,
    this.onDisconnect,
    super.key,
  });

  final ConnectedAccount account;
  final VoidCallback? onDisconnect;

  String _providerLabel(AccountProvider provider) {
    return switch (provider) {
      AccountProvider.mtn => 'MTN MoMo',
      AccountProvider.airtel => 'Airtel Money',
      AccountProvider.stanbic => 'Stanbic Bank',
      AccountProvider.dfcu => 'DFCU Bank',
      AccountProvider.equity => 'Equity Bank',
      AccountProvider.centenary => 'Centenary Bank',
    };
  }

  String _formattedDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.darkBlue.withValues(alpha: 0.1),
        child: Text(
          account.provider.name.substring(0, 1).toUpperCase(),
          style: AppTypography.titleMedium.copyWith(color: AppColors.darkBlue),
        ),
      ),
      title: Text(
        _providerLabel(account.provider),
        style: AppTypography.bodyMedium,
      ),
      subtitle: Text(
        '${account.identifier}'
        ' \u2022 ${_formattedDate(account.connectedAt)}',
        style: AppTypography.bodySmall.copyWith(color: AppColors.grey),
      ),
      trailing: onDisconnect != null
          ? IconButton(
              icon: const Icon(Icons.link_off, color: AppColors.error),
              onPressed: onDisconnect,
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    );
  }
}
