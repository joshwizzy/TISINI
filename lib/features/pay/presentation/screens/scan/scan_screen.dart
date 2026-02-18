import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/domain/entities/scan_state.dart';
import 'package:tisini/features/pay/providers/scan_controller_provider.dart';

class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<ScanState>>(scanControllerProvider, (_, next) {
      final state = next.valueOrNull;
      if (state is ScanStateResolved) {
        context.goNamed(RouteNames.scanConfirm);
      } else if (state is ScanStateManualEntry) {
        context.goNamed(RouteNames.scanManual);
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera placeholder
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    PhosphorIconsBold.qrCode,
                    size: 120,
                    color: Colors.white24,
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    'Point camera at QR code',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            // QR frame overlay
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.green, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            // Top bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        PhosphorIconsBold.arrowLeft,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // TODO(tisini): Toggle flash
                      },
                      icon: const Icon(
                        PhosphorIconsBold.flashlight,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                    ),
                    onPressed: () {
                      ref.read(scanControllerProvider.notifier).enterManually();
                    },
                    child: const Text('Enter manually'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
