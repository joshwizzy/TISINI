import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthState { initial, unauthenticated, authenticated }

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(AuthState.unauthenticated);

  void setAuthenticated() => state = AuthState.authenticated;

  void setUnauthenticated() => state = AuthState.unauthenticated;
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(),
);
