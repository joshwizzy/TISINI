import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/auth/domain/entities/login_state.dart';
import 'package:tisini/features/auth/presentation/screens/otp_screen.dart';
import 'package:tisini/features/auth/providers/login_controller_provider.dart';
import 'package:tisini/shared/widgets/otp_input.dart';

void main() {
  Widget buildApp({LoginState? initialState}) {
    return ProviderScope(
      overrides: [
        if (initialState != null)
          loginControllerProvider.overrideWith(
            () => _MockLoginController(initialState),
          ),
      ],
      child: const MaterialApp(home: OtpScreen()),
    );
  }

  group('OtpScreen', () {
    testWidgets('displays verification code headline', (tester) async {
      await tester.pumpWidget(
        buildApp(
          initialState: const LoginState.otpSent(
            otpId: 'otp-1',
            expiresIn: 60,
            phoneNumber: '+256700000000',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Enter verification code'), findsOneWidget);
    });

    testWidgets('displays masked phone number', (tester) async {
      await tester.pumpWidget(
        buildApp(
          initialState: const LoginState.otpSent(
            otpId: 'otp-1',
            expiresIn: 60,
            phoneNumber: '+256700000000',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('0000'), findsOneWidget);
    });

    testWidgets('displays OTP input', (tester) async {
      await tester.pumpWidget(
        buildApp(
          initialState: const LoginState.otpSent(
            otpId: 'otp-1',
            expiresIn: 60,
            phoneNumber: '+256700000000',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OtpInput), findsOneWidget);
    });

    testWidgets('displays back button', (tester) async {
      await tester.pumpWidget(
        buildApp(
          initialState: const LoginState.otpSent(
            otpId: 'otp-1',
            expiresIn: 60,
            phoneNumber: '+256700000000',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}

class _MockLoginController extends LoginController {
  _MockLoginController(this._initialState);

  final LoginState _initialState;

  @override
  Future<LoginState> build() async => _initialState;
}
