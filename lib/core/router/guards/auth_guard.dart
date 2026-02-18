import 'package:tisini/core/providers/auth_state_provider.dart';

const publicPaths = <String>{
  '/',
  '/onboarding',
  '/login',
  '/otp',
  '/create-pin',
  '/permissions',
};

String? authGuard({required String location, required AuthState authState}) {
  final isAuthenticated = authState.isAuthenticated;
  final isPublicPath = publicPaths.contains(location);

  // Unauthenticated user trying to access private route
  if (!isAuthenticated && !isPublicPath) {
    return '/login';
  }

  // Authenticated user on a public path (except splash)
  if (isAuthenticated && isPublicPath && location != '/') {
    return '/home';
  }

  return null;
}
