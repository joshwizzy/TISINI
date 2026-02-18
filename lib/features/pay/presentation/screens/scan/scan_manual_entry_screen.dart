import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/domain/entities/scan_state.dart';
import 'package:tisini/features/pay/providers/scan_controller_provider.dart';

class ScanManualEntryScreen extends ConsumerStatefulWidget {
  const ScanManualEntryScreen({super.key});

  @override
  ConsumerState<ScanManualEntryScreen> createState() =>
      _ScanManualEntryScreenState();
}

class _ScanManualEntryScreenState extends ConsumerState<ScanManualEntryScreen> {
  final _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<ScanState>>(scanControllerProvider, (_, next) {
      final state = next.valueOrNull;
      if (state is ScanStateResolved) {
        context.goNamed(RouteNames.scanConfirm);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Enter Details'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter phone, account, or till number',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _identifierController,
              decoration: InputDecoration(
                hintText: 'e.g. +256700100200',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.grey,
                ),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              onChanged: (_) => setState(() {}),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _identifierController.text.trim().isNotEmpty
                    ? () {
                        ref
                            .read(scanControllerProvider.notifier)
                            .resolveManualPayee(
                              _identifierController.text.trim(),
                            );
                      }
                    : null,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
