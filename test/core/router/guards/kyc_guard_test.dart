import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/router/guards/kyc_guard.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';

class _MockGoRouterState extends Mock implements GoRouterState {}

void main() {
  late GoRouterState mockState;

  setUp(() {
    mockState = _MockGoRouterState();
  });

  group('kycGuard', () {
    test('returns null when status is null', () {
      expect(kycGuard(mockState), isNull);
    });

    test('returns null when status is approved', () {
      final result = kycGuard(mockState, status: KycStatus.approved);
      expect(result, isNull);
    });

    test('redirects when notStarted', () {
      final result = kycGuard(mockState, status: KycStatus.notStarted);
      expect(result, '/more/kyc');
    });

    test('redirects when pending', () {
      final result = kycGuard(mockState, status: KycStatus.pending);
      expect(result, '/more/kyc');
    });

    test('redirects when inProgress', () {
      final result = kycGuard(mockState, status: KycStatus.inProgress);
      expect(result, '/more/kyc');
    });

    test('redirects when failed', () {
      final result = kycGuard(mockState, status: KycStatus.failed);
      expect(result, '/more/kyc');
    });
  });
}
