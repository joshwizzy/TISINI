import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_document.dart';
import 'package:tisini/features/kyc/providers/kyc_flow_controller.dart';
import 'package:tisini/features/kyc/providers/kyc_provider.dart';

class KycIdFrontScreen extends ConsumerStatefulWidget {
  const KycIdFrontScreen({super.key});

  @override
  ConsumerState<KycIdFrontScreen> createState() => _KycIdFrontScreenState();
}

class _KycIdFrontScreenState extends ConsumerState<KycIdFrontScreen> {
  bool _captured = false;
  bool _isCapturing = false;
  KycDocument? _document;

  Future<void> _capture() async {
    setState(() => _isCapturing = true);
    try {
      final repo = ref.read(kycRepositoryProvider);
      final doc = await repo.captureDocument(type: KycDocumentType.idFront);
      setState(() {
        _captured = true;
        _document = doc;
      });
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  void _retake() {
    setState(() {
      _captured = false;
      _document = null;
    });
  }

  void _usePhoto() {
    if (_document == null) return;
    ref.read(kycFlowControllerProvider.notifier).captureDocument(_document!);
    context.goNamed(RouteNames.kycChecklist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ID Card (Front)'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 280,
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _captured ? AppColors.success : AppColors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                color: _captured
                    ? AppColors.success.withValues(alpha: 0.08)
                    : AppColors.darkBlue.withValues(alpha: 0.04),
              ),
              child: Center(
                child: _captured
                    ? const Icon(
                        PhosphorIconsBold.checkCircle,
                        size: 48,
                        color: AppColors.success,
                      )
                    : const Icon(
                        PhosphorIconsBold.camera,
                        size: 48,
                        color: AppColors.grey,
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _captured
                  ? 'Photo captured'
                  : 'Position the front of your ID '
                        'within the frame',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: _captured
              ? Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _retake,
                        child: const Text('Retake'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FilledButton(
                        onPressed: _usePhoto,
                        child: const Text('Use this'),
                      ),
                    ),
                  ],
                )
              : FilledButton(
                  onPressed: _isCapturing ? null : _capture,
                  child: _isCapturing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Capture'),
                ),
        ),
      ),
    );
  }
}
