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
import 'package:tisini/features/pay/providers/payee_search_provider.dart';
import 'package:tisini/features/pay/providers/recent_payees_provider.dart';
import 'package:tisini/features/pay/providers/send_controller_provider.dart';
import 'package:tisini/shared/widgets/payee_card.dart';

class SendRecipientScreen extends ConsumerStatefulWidget {
  const SendRecipientScreen({super.key});

  @override
  ConsumerState<SendRecipientScreen> createState() =>
      _SendRecipientScreenState();
}

class _SendRecipientScreenState extends ConsumerState<SendRecipientScreen> {
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
      appBar: AppBar(
        title: const Text('Send'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search name or number...',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.grey,
              ),
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
          ),
          const SizedBox(height: AppSpacing.md),
          if (_searchQuery.isNotEmpty)
            _SearchResults(query: _searchQuery)
          else
            const _RecentPayeesList(),
        ],
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
          children: payees
              .map(
                (payee) => PayeeCard(
                  payee: payee,
                  onTap: () {
                    ref
                        .read(sendControllerProvider.notifier)
                        .selectRecipient(payee);
                    context.goNamed(RouteNames.sendDetails);
                  },
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

class _RecentPayeesList extends ConsumerWidget {
  const _RecentPayeesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(recentPayeesProvider);

    return recentAsync.when(
      data: (payees) {
        if (payees.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'No recent payees',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recent', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            ...payees.map(
              (payee) => PayeeCard(
                payee: payee,
                onTap: () {
                  ref
                      .read(sendControllerProvider.notifier)
                      .selectRecipient(payee);
                  context.goNamed(RouteNames.sendDetails);
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) =>
          const Text('Unable to load payees', style: AppTypography.bodyMedium),
    );
  }
}
