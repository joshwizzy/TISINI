import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/presentation/widgets/merchant_tile.dart';
import 'package:tisini/features/more/providers/more_provider.dart';

class PinnedMerchantsScreen extends ConsumerWidget {
  const PinnedMerchantsScreen({super.key});

  void _showRoleSheet(
    BuildContext context,
    String merchantId,
    MerchantRole currentRole,
  ) {
    showModalBottomSheet<MerchantRole>(
      context: context,
      builder: (_) => _RoleSelector(currentRole: currentRole),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchantsAsync = ref.watch(pinnedMerchantsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pinned Merchants'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: merchantsAsync.when(
        data: (merchants) {
          if (merchants.isEmpty) {
            return Center(
              child: Text(
                'No pinned merchants',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: merchants.length,
            itemBuilder: (context, index) {
              final merchant = merchants[index];
              return MerchantTile(
                merchant: merchant,
                onTap: () =>
                    _showRoleSheet(context, merchant.id, merchant.role),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to load merchants')),
      ),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({required this.currentRole});

  final MerchantRole currentRole;

  String _label(MerchantRole role) {
    return switch (role) {
      MerchantRole.supplier => 'Supplier',
      MerchantRole.rent => 'Rent',
      MerchantRole.wages => 'Wages',
      MerchantRole.tax => 'Tax',
      MerchantRole.pension => 'Pension',
      MerchantRole.utilities => 'Utilities',
    };
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: MerchantRole.values.map((role) {
          return ListTile(
            title: Text(_label(role)),
            trailing: role == currentRole
                ? const Icon(Icons.check, color: AppColors.success)
                : null,
            onTap: () => Navigator.pop(context, role),
          );
        }).toList(),
      ),
    );
  }
}
