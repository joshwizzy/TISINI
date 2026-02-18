import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/providers/auth_state_provider.dart';
import 'package:tisini/core/providers/core_providers.dart';
import 'package:tisini/core/storage/secure_storage.dart';
import 'package:tisini/features/auth/domain/entities/auth_token.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/auth/domain/entities/user.dart';

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  group('AuthStateNotifier', () {
    late ProviderContainer container;
    late MockSecureStorage mockSecureStorage;

    setUp(() {
      mockSecureStorage = MockSecureStorage();
      container = ProviderContainer(
        overrides: [secureStorageProvider.overrideWithValue(mockSecureStorage)],
      );
    });

    tearDown(() => container.dispose());

    test('initial state is unauthenticated', () {
      final state = container.read(authStateProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
      expect(state.token, isNull);
      expect(state.isAuthenticated, isFalse);
    });

    test('login sets authenticated with token and user', () {
      final token = AuthToken(
        accessToken: 'access',
        refreshToken: 'refresh',
        expiresAt: DateTime(2026, 3),
      );
      final user = User(
        id: 'user-1',
        phoneNumber: '+256700000000',
        kycStatus: KycStatus.notStarted,
        createdAt: DateTime(2026, 2, 18),
      );

      container.read(authStateProvider.notifier).login(token, user);

      final state = container.read(authStateProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.isAuthenticated, isTrue);
      expect(state.user?.id, 'user-1');
      expect(state.token?.accessToken, 'access');
    });

    test('logout clears state and storage', () async {
      when(() => mockSecureStorage.clearTokens()).thenAnswer((_) async {});

      final token = AuthToken(
        accessToken: 'access',
        refreshToken: 'refresh',
        expiresAt: DateTime(2026, 3),
      );
      final user = User(
        id: 'user-1',
        phoneNumber: '+256700000000',
        kycStatus: KycStatus.notStarted,
        createdAt: DateTime(2026, 2, 18),
      );

      final notifier = container.read(authStateProvider.notifier)
        ..login(token, user);

      await notifier.logout();

      final state = container.read(authStateProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
      expect(state.token, isNull);
      verify(() => mockSecureStorage.clearTokens()).called(1);
    });

    test('updateToken updates only the token', () {
      final token1 = AuthToken(
        accessToken: 'access-1',
        refreshToken: 'refresh-1',
        expiresAt: DateTime(2026, 3),
      );
      final user = User(
        id: 'user-1',
        phoneNumber: '+256700000000',
        kycStatus: KycStatus.notStarted,
        createdAt: DateTime(2026, 2, 18),
      );
      final token2 = AuthToken(
        accessToken: 'access-2',
        refreshToken: 'refresh-2',
        expiresAt: DateTime(2026, 3, 2),
      );

      container.read(authStateProvider.notifier)
        ..login(token1, user)
        ..updateToken(token2);

      final state = container.read(authStateProvider);
      expect(state.token?.accessToken, 'access-2');
      expect(state.user?.id, 'user-1');
    });

    test('setAuthenticated updates status', () {
      container.read(authStateProvider.notifier).setAuthenticated();
      expect(
        container.read(authStateProvider).status,
        AuthStatus.authenticated,
      );
    });

    test('setUnauthenticated clears state', () {
      final token = AuthToken(
        accessToken: 'access',
        refreshToken: 'refresh',
        expiresAt: DateTime(2026, 3),
      );
      final user = User(
        id: 'user-1',
        phoneNumber: '+256700000000',
        kycStatus: KycStatus.notStarted,
        createdAt: DateTime(2026, 2, 18),
      );

      container.read(authStateProvider.notifier)
        ..login(token, user)
        ..setUnauthenticated();

      final state = container.read(authStateProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
    });
  });
}
