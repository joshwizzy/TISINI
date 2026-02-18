import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/providers/core_providers.dart';
import 'package:tisini/features/auth/domain/entities/auth_token.dart';
import 'package:tisini/features/auth/domain/entities/user.dart';

enum AuthStatus { initial, unauthenticated, authenticated }

class AuthState {
  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.user,
    this.token,
  });

  final AuthStatus status;
  final User? user;
  final AuthToken? token;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({AuthStatus? status, User? user, AuthToken? token}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier(this._ref) : super(const AuthState());

  final Ref _ref;

  void login(AuthToken token, User user) {
    state = AuthState(
      status: AuthStatus.authenticated,
      token: token,
      user: user,
    );
  }

  Future<void> logout() async {
    final secureStorage = _ref.read(secureStorageProvider);
    await secureStorage.clearTokens();
    state = const AuthState();
  }

  void updateToken(AuthToken token) {
    state = state.copyWith(token: token);
  }

  void setAuthenticated() {
    state = state.copyWith(status: AuthStatus.authenticated);
  }

  void setUnauthenticated() {
    state = const AuthState();
  }
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  AuthStateNotifier.new,
);
