import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/providers/core_providers.dart';

final splashTargetRouteProvider = AutoDisposeFutureProvider<String>((
  ref,
) async {
  final secureStorage = ref.read(secureStorageProvider);
  final preferences = ref.read(preferencesProvider);

  final accessToken = await secureStorage.getAccessToken();
  final refreshToken = await secureStorage.getRefreshToken();

  // Has stored valid tokens → go home
  if (accessToken != null && refreshToken != null) {
    return '/home';
  }

  // No tokens + first launch → onboarding
  if (!preferences.hasSeenOnboarding) {
    return '/onboarding';
  }

  // No tokens + returning user → login
  return '/login';
});
