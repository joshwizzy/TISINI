import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/features/more/presentation/widgets/faq_expansion_tile.dart';
import 'package:tisini/features/more/providers/more_provider.dart';

class HelpSupportScreen extends ConsumerWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqsAsync = ref.watch(faqsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: faqsAsync.when(
        data: (faqs) => ListView(
          children: [
            ...faqs.map((faq) => FaqExpansionTile(faq: faq)),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contact support coming soon'),
                    ),
                  );
                },
                child: const Text('Contact Support'),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to load FAQs')),
      ),
    );
  }
}
