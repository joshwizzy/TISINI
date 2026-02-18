import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/kyc/data/models/kyc_submission_model.dart';

void main() {
  group('KycSubmissionModel', () {
    final json = <String, dynamic>{
      'id': 'sub-001',
      'account_type': 'business',
      'status': 'pending',
      'documents': <Map<String, dynamic>>[
        {
          'id': 'doc-001',
          'type': 'id_front',
          'is_uploaded': true,
          'file_path': '/uploads/id_front.jpg',
        },
        {'id': 'doc-002', 'type': 'selfie', 'is_uploaded': false},
      ],
      'rejection_reason': null,
      'submitted_at': 1718409600000,
      'reviewed_at': null,
    };

    test('fromJson parses correctly', () {
      final model = KycSubmissionModel.fromJson(json);
      expect(model.id, 'sub-001');
      expect(model.accountType, 'business');
      expect(model.status, 'pending');
      expect(model.documents, hasLength(2));
      expect(model.documents.first.id, 'doc-001');
      expect(model.documents.last.id, 'doc-002');
      expect(model.rejectionReason, isNull);
      expect(model.submittedAt, 1718409600000);
      expect(model.reviewedAt, isNull);
    });

    test('toJson produces snake_case keys', () {
      final model = KycSubmissionModel.fromJson(json);
      final output = model.toJson();
      expect(output['id'], 'sub-001');
      expect(output['account_type'], 'business');
      expect(output['status'], 'pending');
      expect(output['documents'], isA<List<dynamic>>());
      expect((output['documents'] as List).length, 2);
      expect(output['rejection_reason'], isNull);
      expect(output['submitted_at'], 1718409600000);
      expect(output['reviewed_at'], isNull);
    });

    test('toEntity converts correctly', () {
      final model = KycSubmissionModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity.id, 'sub-001');
      expect(entity.accountType, KycAccountType.business);
      expect(entity.status, KycStatus.pending);
      expect(entity.documents, hasLength(2));
      expect(entity.documents.first.type, KycDocumentType.idFront);
      expect(entity.documents.first.isUploaded, true);
      expect(entity.documents.last.type, KycDocumentType.selfie);
      expect(entity.documents.last.isUploaded, false);
      expect(entity.rejectionReason, isNull);
      expect(
        entity.submittedAt,
        DateTime.fromMillisecondsSinceEpoch(1718409600000),
      );
      expect(entity.reviewedAt, isNull);
    });

    test('toEntity parses gig account type', () {
      final gigJson = Map<String, dynamic>.from(json)..['account_type'] = 'gig';
      final entity = KycSubmissionModel.fromJson(gigJson).toEntity();
      expect(entity.accountType, KycAccountType.gig);
    });

    test('toEntity parses unknown account type as business', () {
      final unknown = Map<String, dynamic>.from(json)
        ..['account_type'] = 'unknown';
      final entity = KycSubmissionModel.fromJson(unknown).toEntity();
      expect(entity.accountType, KycAccountType.business);
    });

    test('toEntity parses all status values', () {
      for (final entry in <String, KycStatus>{
        'not_started': KycStatus.notStarted,
        'in_progress': KycStatus.inProgress,
        'pending': KycStatus.pending,
        'approved': KycStatus.approved,
        'failed': KycStatus.failed,
      }.entries) {
        final statusJson = Map<String, dynamic>.from(json)
          ..['status'] = entry.key;
        final entity = KycSubmissionModel.fromJson(statusJson).toEntity();
        expect(entity.status, entry.value);
      }
    });

    test('toEntity parses unknown status as notStarted', () {
      final unknown = Map<String, dynamic>.from(json)..['status'] = 'unknown';
      final entity = KycSubmissionModel.fromJson(unknown).toEntity();
      expect(entity.status, KycStatus.notStarted);
    });

    test('toEntity with rejection reason', () {
      final rejected = Map<String, dynamic>.from(json)
        ..['status'] = 'failed'
        ..['rejection_reason'] = 'ID photo is blurry'
        ..['reviewed_at'] = 1718413200000;
      final entity = KycSubmissionModel.fromJson(rejected).toEntity();
      expect(entity.status, KycStatus.failed);
      expect(entity.rejectionReason, 'ID photo is blurry');
      expect(
        entity.reviewedAt,
        DateTime.fromMillisecondsSinceEpoch(1718413200000),
      );
    });

    test('toEntity without submittedAt and reviewedAt', () {
      final noTimestamps = Map<String, dynamic>.from(json)
        ..remove('submitted_at')
        ..remove('reviewed_at');
      final entity = KycSubmissionModel.fromJson(noTimestamps).toEntity();
      expect(entity.submittedAt, isNull);
      expect(entity.reviewedAt, isNull);
    });

    test('round-trip serialization preserves data', () {
      final model = KycSubmissionModel.fromJson(json);
      final encoded = jsonEncode(model.toJson());
      final roundTrip = KycSubmissionModel.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );
      expect(roundTrip, equals(model));
    });
  });
}
