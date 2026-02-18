import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/presentation/widgets/pay_category_tile.dart';
import 'package:tisini/features/pay/providers/payee_search_provider.dart';
import 'package:tisini/features/pay/providers/pinned_payees_provider.dart';
import 'package:tisini/features/pay/providers/recent_payees_provider.dart';
import 'package:tisini/shared/widgets/payee_card.dart';

class PayHubScreen extends ConsumerStatefulWidget {
  const PayHubScreen({super.key});

  @override
  ConsumerState<PayHubScreen> createState() => _PayHubScreenState();
}

class _PayHubScreenState extends ConsumerState<PayHubScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() => _searchQuery = query.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            const Text('Pay', style: AppTypography.headlineLarge),
            const SizedBox(height: AppSpacing.md),
            _SearchBar(
              controller: _searchController,
              onChanged: _onSearchChanged,
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              _SearchResults(query: _searchQuery),
            ] else ...[
              const SizedBox(height: AppSpacing.lg),
              const _QuickActionsRow(),
              const SizedBox(height: AppSpacing.lg),
              const _CategoriesGrid(),
              const SizedBox(height: AppSpacing.lg),
              const _RecentPayeesSection(),
              const SizedBox(height: AppSpacing.lg),
              const _PinnedPayeesSection(),
            ],
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search payees...',
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
        prefixIcon: const Icon(
          PhosphorIconsBold.magnifyingGlass,
          color: AppColors.grey,
          size: 20,
        ),
        filled: true,
        fillColor: AppColors.cardWhite,
        border: OutlineInputBorder(
          borderRadius: AppRadii.inputBorder,
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.inputBorder,
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
    );
  }
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(payeeSearchProvider(query));

    return results.when(
      data: (payees) {
        if (payees.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'No payees found',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: payees
              .map(
                (payee) => PayeeCard(
                  payee: payee,
                  onTap: () => context.goNamed(RouteNames.sendRecipient),
                ),
              )
              .toList(),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) =>
          const Text('Search failed', style: AppTypography.bodyMedium),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickAction(
          icon: PhosphorIconsBold.paperPlaneTilt,
          label: 'Send',
          onTap: () => context.goNamed(RouteNames.sendRecipient),
        ),
        _QuickAction(
          icon: PhosphorIconsBold.handCoins,
          label: 'Request',
          onTap: () => context.goNamed(RouteNames.requestCreate),
        ),
        _QuickAction(
          icon: PhosphorIconsBold.qrCode,
          label: 'Scan',
          onTap: () => context.goNamed(RouteNames.scan),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.darkBlue, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTypography.labelSmall),
        ],
      ),
    );
  }
}

class _CategoriesGrid extends StatelessWidget {
  const _CategoriesGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Categories', style: AppTypography.titleMedium),
        const SizedBox(height: AppSpacing.sm),
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
              onTap: () => context.goNamed(RouteNames.businessCategory),
            ),
            PayCategoryTile(
              icon: PhosphorIconsBold.receipt,
              label: 'Bills',
              onTap: () => context.goNamed(RouteNames.businessCategory),
            ),
            PayCategoryTile(
              icon: PhosphorIconsBold.users,
              label: 'Wages',
              onTap: () => context.goNamed(RouteNames.businessCategory),
            ),
            PayCategoryTile(
              icon: PhosphorIconsBold.scales,
              label: 'Statutory',
              onTap: () => context.goNamed(RouteNames.businessCategory),
            ),
            PayCategoryTile(
              icon: PhosphorIconsBold.plus,
              label: 'Top Up',
              onTap: () => context.goNamed(RouteNames.topupSource),
            ),
          ],
        ),
      ],
    );
  }
}

class _RecentPayeesSection extends ConsumerWidget {
  const _RecentPayeesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(recentPayeesProvider);

    return recentAsync.when(
      data: (payees) {
        if (payees.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recent', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: payees.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) {
                  final payee = payees[index];
                  return _PayeeAvatar(
                    name: payee.name,
                    onTap: () => context.goNamed(RouteNames.sendRecipient),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _PinnedPayeesSection extends ConsumerWidget {
  const _PinnedPayeesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinnedAsync = ref.watch(pinnedPayeesProvider);

    return pinnedAsync.when(
      data: (payees) {
        if (payees.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pinned', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: payees.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) {
                  final payee = payees[index];
                  return _PayeeAvatar(
                    name: payee.name,
                    onTap: () => context.goNamed(RouteNames.sendRecipient),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _PayeeAvatar extends StatelessWidget {
  const _PayeeAvatar({required this.name, this.onTap});

  final String name;
  final VoidCallback? onTap;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.darkBlue.withValues(alpha: 0.1),
              child: Text(
                _initials(name),
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.darkBlue,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name.split(' ').first,
              style: AppTypography.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
