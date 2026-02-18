import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';

class PiaEmptyScreen extends StatelessWidget {
  const PiaEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pia')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                PhosphorIconsBold.sparkle,
                size: 80,
                color: AppColors.darkBlue50,
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'No insights yet',
                style: AppTypography.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Pia will start showing you guidance once '
                'you make a few payments or import '
                'your history.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.darkBlue50,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () {
                  // TODO(tisini): Navigate to import flow
                },
                child: const Text('Import transactions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
