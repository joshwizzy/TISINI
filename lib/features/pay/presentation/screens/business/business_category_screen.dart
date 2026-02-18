import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/presentation/widgets/pay_category_tile.dart';
import 'package:tisini/features/pay/providers/business_pay_controller_provider.dart';

class BusinessCategoryScreen extends ConsumerWidget {
  const BusinessCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Business Pay'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select a category', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.md),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 2,
              children: [
                PayCategoryTile(
                  icon: PhosphorIconsBold.package,
                  label: 'Suppliers',
                  onTap: () => _selectCategory(context, ref, 'Suppliers'),
                ),
                PayCategoryTile(
                  icon: PhosphorIconsBold.receipt,
                  label: 'Bills',
                  onTap: () => _selectCategory(context, ref, 'Bills'),
                ),
                PayCategoryTile(
                  icon: PhosphorIconsBold.users,
                  label: 'Wages',
                  onTap: () => _selectCategory(context, ref, 'Wages'),
                ),
                PayCategoryTile(
                  icon: PhosphorIconsBold.scales,
                  label: 'Statutory',
                  onTap: () => _selectCategory(context, ref, 'Statutory'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _selectCategory(BuildContext context, WidgetRef ref, String category) {
    ref.read(businessPayControllerProvider.notifier).selectCategory(category);
    context.goNamed(RouteNames.businessPayee);
  }
}
