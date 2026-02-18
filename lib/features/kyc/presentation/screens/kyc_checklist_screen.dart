import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_flow_state.dart';
import 'package:tisini/features/kyc/presentation/widgets/document_checklist_item.dart';
import 'package:tisini/features/kyc/providers/kyc_flow_controller.dart';

class KycChecklistScreen extends ConsumerWidget {
  const KycChecklistScreen({super.key});

  List<KycDocumentType> _requiredDocs(KycAccountType type) {
    return switch (type) {
      KycAccountType.business => [
        KycDocumentType.idFront,
        KycDocumentType.idBack,
        KycDocumentType.selfie,
        KycDocumentType.businessRegistration,
      ],
      KycAccountType.gig => [
        KycDocumentType.idFront,
        KycDocumentType.idBack,
        KycDocumentType.selfie,
      ],
    };
  }

  String _routeForDocType(KycDocumentType type) {
    return switch (type) {
      KycDocumentType.idFront => RouteNames.kycIdFront,
      KycDocumentType.idBack => RouteNames.kycIdBack,
      KycDocumentType.selfie => RouteNames.kycSelfie,
      _ => RouteNames.kycIdFront,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(kycFlowControllerProvider);
    final state = stateAsync.valueOrNull;

    if (state is! KycCapturingDocuments) {
      return Scaffold(
        appBar: AppBar(title: const Text('Documents')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final required = _requiredDocs(state.accountType);
    final capturedTypes = state.documents.map((d) => d.type).toSet();
    final allCaptured = required.every(capturedTypes.contains);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Documents'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          const Text('Required documents', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Capture each document to continue.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: AppSpacing.md),
          ...required.map(
            (type) => DocumentChecklistItem(
              type: type,
              isCaptured: capturedTypes.contains(type),
              onTap: () {
                final route = _routeForDocType(type);
                context.goNamed(route);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: FilledButton(
            onPressed: allCaptured
                ? () => context.goNamed(RouteNames.kycReview)
                : null,
            child: const Text('Continue'),
          ),
        ),
      ),
    );
  }
}
