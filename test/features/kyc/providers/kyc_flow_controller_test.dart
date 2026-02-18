import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_document.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_flow_state.dart';
import 'package:tisini/features/kyc/providers/kyc_flow_controller.dart';

void main() {
  group('KycFlowController', () {
    test('initial state is idle', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(kycFlowControllerProvider, (_, __) {});

      final state = await container.read(kycFlowControllerProvider.future);

      expect(state, isA<KycIdle>());
    });

    test('selectAccountType transitions to capturingDocuments', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(kycFlowControllerProvider, (_, __) {});

      await container.read(kycFlowControllerProvider.future);

      container
          .read(kycFlowControllerProvider.notifier)
          .selectAccountType(KycAccountType.business);

      final state = container.read(kycFlowControllerProvider).valueOrNull;

      expect(state, isA<KycCapturingDocuments>());
      final capturing = state! as KycCapturingDocuments;
      expect(capturing.accountType, KycAccountType.business);
      expect(capturing.documents, isEmpty);
    });

    test('captureDocument adds document to list', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(kycFlowControllerProvider, (_, __) {});

      await container.read(kycFlowControllerProvider.future);

      container
          .read(kycFlowControllerProvider.notifier)
          .selectAccountType(KycAccountType.gig);

      const doc = KycDocument(
        id: 'doc-1',
        type: KycDocumentType.idFront,
        isUploaded: false,
      );

      container.read(kycFlowControllerProvider.notifier).captureDocument(doc);

      final state = container.read(kycFlowControllerProvider).valueOrNull;

      expect(state, isA<KycCapturingDocuments>());
      final capturing = state! as KycCapturingDocuments;
      expect(capturing.documents, hasLength(1));
      expect(capturing.documents.first.type, KycDocumentType.idFront);
    });

    test('captureDocument replaces existing document of same type', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(kycFlowControllerProvider, (_, __) {});

      await container.read(kycFlowControllerProvider.future);

      container
          .read(kycFlowControllerProvider.notifier)
          .selectAccountType(KycAccountType.business);

      const doc1 = KycDocument(
        id: 'doc-1',
        type: KycDocumentType.idFront,
        isUploaded: false,
      );
      const doc2 = KycDocument(
        id: 'doc-2',
        type: KycDocumentType.idFront,
        isUploaded: true,
        filePath: '/tmp/updated.jpg',
      );

      container.read(kycFlowControllerProvider.notifier).captureDocument(doc1);
      container.read(kycFlowControllerProvider.notifier).captureDocument(doc2);

      final state = container.read(kycFlowControllerProvider).valueOrNull;

      expect(state, isA<KycCapturingDocuments>());
      final capturing = state! as KycCapturingDocuments;
      expect(capturing.documents, hasLength(1));
      expect(capturing.documents.first.id, 'doc-2');
    });

    test('retry transitions to selectingAccountType', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(kycFlowControllerProvider, (_, __) {});

      await container.read(kycFlowControllerProvider.future);

      container.read(kycFlowControllerProvider.notifier).retry();

      final state = container.read(kycFlowControllerProvider).valueOrNull;

      expect(state, isA<KycSelectingAccountType>());
    });

    test('reset transitions to idle', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(kycFlowControllerProvider, (_, __) {});

      await container.read(kycFlowControllerProvider.future);

      container
          .read(kycFlowControllerProvider.notifier)
          .selectAccountType(KycAccountType.business);

      container.read(kycFlowControllerProvider.notifier).reset();

      final state = container.read(kycFlowControllerProvider).valueOrNull;

      expect(state, isA<KycIdle>());
    });
  });
}
