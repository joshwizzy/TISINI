import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/domain/entities/send_state.dart';
import 'package:tisini/features/pay/providers/send_controller_provider.dart';
import 'package:tisini/shared/widgets/category_tag.dart';
import 'package:tisini/shared/widgets/payee_card.dart';

class SendDetailsScreen extends ConsumerStatefulWidget {
  const SendDetailsScreen({super.key});

  @override
  ConsumerState<SendDetailsScreen> createState() => _SendDetailsScreenState();
}

class _SendDetailsScreenState extends ConsumerState<SendDetailsScreen> {
  final _referenceController = TextEditingController();
  final _noteController = TextEditingController();
  TransactionCategory _selectedCategory = TransactionCategory.uncategorised;

  @override
  void dispose() {
    _referenceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sendState = ref.watch(sendControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Payment Details'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: sendState.when(
        data: (state) {
          if (state is! SendStateEnteringDetails) {
            return const Center(child: Text('Invalid state'));
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              PayeeCard(payee: state.payee),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Reference (optional)',
                style: AppTypography.labelLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _referenceController,
                decoration: const InputDecoration(
                  hintText: 'e.g. INV-001',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text('Category', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: TransactionCategory.values.map((cat) {
                  return CategoryTag(
                    category: cat,
                    isSelected: _selectedCategory == cat,
                    onTap: () {
                      setState(() => _selectedCategory = cat);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text('Note (optional)', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Add a note...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: () {
                  ref
                      .read(sendControllerProvider.notifier)
                      .enterDetails(
                        payee: state.payee,
                        category: _selectedCategory,
                        reference: _referenceController.text.trim().isEmpty
                            ? null
                            : _referenceController.text.trim(),
                        note: _noteController.text.trim().isEmpty
                            ? null
                            : _noteController.text.trim(),
                      );
                  context.goNamed(RouteNames.sendAmount);
                },
                child: const Text('Continue'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Something went wrong')),
      ),
    );
  }
}
