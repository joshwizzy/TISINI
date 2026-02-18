import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_page.freezed.dart';

@freezed
class OnboardingPage with _$OnboardingPage {
  const factory OnboardingPage({
    required String title,
    required String body,
    required String assetPath,
  }) = _OnboardingPage;

  static const pages = [
    OnboardingPage(
      title: 'Simple payments',
      body:
          'Send and receive money instantly. '
          'Pay bills, top up airtime, and manage '
          'all your transactions in one place.',
      assetPath: 'assets/images/onboarding_payments.png',
    ),
    OnboardingPage(
      title: 'Your business picture',
      body:
          'Track income and expenses automatically. '
          'See where your money goes and make '
          'smarter decisions for your business.',
      assetPath: 'assets/images/onboarding_business.png',
    ),
    OnboardingPage(
      title: 'Personal insights',
      body:
          'Get tailored tips and actions based on '
          'your spending patterns. Pia helps you '
          'stay on top of your finances.',
      assetPath: 'assets/images/onboarding_pia.png',
    ),
    OnboardingPage(
      title: 'Pension made easy',
      body:
          'Start saving for retirement with small, '
          'regular contributions. Build your future '
          'one step at a time.',
      assetPath: 'assets/images/onboarding_pension.png',
    ),
  ];
}
