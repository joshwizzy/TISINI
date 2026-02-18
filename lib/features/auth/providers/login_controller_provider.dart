import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/errors/exceptions.dart';
import 'package:tisini/core/providers/auth_state_provider.dart';
import 'package:tisini/core/providers/core_providers.dart';
import 'package:tisini/features/auth/domain/entities/login_state.dart';
import 'package:tisini/features/auth/providers/auth_repository_provider.dart';

class LoginController extends AutoDisposeAsyncNotifier<LoginState> {
  static final _phoneRegex = RegExp(r'^\+[1-9]\d{6,14}$');

  String? _lastPhoneNumber;
  String? _lastOtpId;

  @override
  Future<LoginState> build() async {
    return const LoginState.initial();
  }

  Future<void> requestOtp(String phoneNumber) async {
    if (!_phoneRegex.hasMatch(phoneNumber)) {
      state = const AsyncData(
        LoginState.error(
          message: 'Please enter a valid phone number',
          code: 'INVALID_PHONE',
        ),
      );
      return;
    }

    _lastPhoneNumber = phoneNumber;
    state = const AsyncData(LoginState.requestingOtp());

    try {
      final repo = ref.read(authRepositoryProvider);
      final response = await repo.requestOtp(phoneNumber: phoneNumber);
      _lastOtpId = response.otpId;
      state = AsyncData(
        LoginState.otpSent(
          otpId: response.otpId,
          expiresIn: response.expiresIn,
          phoneNumber: phoneNumber,
        ),
      );
    } on AppException catch (e) {
      state = AsyncData(LoginState.error(message: e.message, code: e.code));
    }
  }

  Future<void> verifyOtp(String code) async {
    final otpId = _lastOtpId;
    if (otpId == null) return;

    state = const AsyncData(LoginState.verifyingOtp());

    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.verifyOtp(otpId: otpId, code: code);

      // Save tokens
      final secureStorage = ref.read(secureStorageProvider);
      await secureStorage.saveTokens(
        accessToken: result.token.accessToken,
        refreshToken: result.token.refreshToken,
      );

      // Update auth state
      ref.read(authStateProvider.notifier).login(result.token, result.user);

      state = AsyncData(
        LoginState.verified(
          token: result.token,
          user: result.user,
          isNewUser: result.isNewUser,
        ),
      );
    } on ServerException catch (e) {
      state = AsyncData(
        LoginState.error(message: _mapErrorCode(e.code), code: e.code),
      );
    } on AppException catch (e) {
      state = AsyncData(LoginState.error(message: e.message, code: e.code));
    }
  }

  Future<void> resendOtp() async {
    final phone = _lastPhoneNumber;
    if (phone == null) return;
    await requestOtp(phone);
  }

  static String _mapErrorCode(String? code) {
    return switch (code) {
      'OTP_INVALID' => 'Incorrect code. Please try again.',
      'OTP_EXPIRED' => 'Code expired. Tap resend.',
      'OTP_RATE_LIMITED' => 'Too many attempts. Please wait.',
      _ => 'Something went wrong. Please try again.',
    };
  }
}

final loginControllerProvider =
    AutoDisposeAsyncNotifierProvider<LoginController, LoginState>(
      LoginController.new,
    );
