import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/auth/domain/entities/auth_token.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/auth/domain/entities/login_state.dart';
import 'package:tisini/features/auth/domain/entities/user.dart';

void main() {
  group('LoginState', () {
    test('initial creates correct state', () {
      const state = LoginState.initial();
      expect(state, isA<LoginStateInitial>());
    });

    test('requestingOtp creates correct state', () {
      const state = LoginState.requestingOtp();
      expect(state, isA<LoginStateRequestingOtp>());
    });

    test('otpSent stores otpId, expiresIn, and phoneNumber', () {
      const state = LoginState.otpSent(
        otpId: 'otp-123',
        expiresIn: 60,
        phoneNumber: '+256700000000',
      );
      expect(state, isA<LoginStateOtpSent>());
      const otpSent = state as LoginStateOtpSent;
      expect(otpSent.otpId, 'otp-123');
      expect(otpSent.expiresIn, 60);
      expect(otpSent.phoneNumber, '+256700000000');
    });

    test('verifyingOtp creates correct state', () {
      const state = LoginState.verifyingOtp();
      expect(state, isA<LoginStateVerifyingOtp>());
    });

    test('verified stores token, user, and isNewUser', () {
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
      final state = LoginState.verified(
        token: token,
        user: user,
        isNewUser: true,
      );
      expect(state, isA<LoginStateVerified>());
      final verified = state as LoginStateVerified;
      expect(verified.token.accessToken, 'access');
      expect(verified.user.id, 'user-1');
      expect(verified.isNewUser, isTrue);
    });

    test('error stores message and optional code', () {
      const state = LoginState.error(
        message: 'Something went wrong',
        code: 'OTP_INVALID',
      );
      expect(state, isA<LoginStateError>());
      const error = state as LoginStateError;
      expect(error.message, 'Something went wrong');
      expect(error.code, 'OTP_INVALID');
    });

    test('error without code defaults to null', () {
      const state = LoginState.error(message: 'Error');
      const error = state as LoginStateError;
      expect(error.code, isNull);
    });

    test('equality works for same values', () {
      const state1 = LoginState.otpSent(
        otpId: 'otp-1',
        expiresIn: 60,
        phoneNumber: '+256700000000',
      );
      const state2 = LoginState.otpSent(
        otpId: 'otp-1',
        expiresIn: 60,
        phoneNumber: '+256700000000',
      );
      expect(state1, equals(state2));
    });

    test('different states are not equal', () {
      const state1 = LoginState.initial();
      const state2 = LoginState.requestingOtp();
      expect(state1, isNot(equals(state2)));
    });
  });
}
