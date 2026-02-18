import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/providers/auth_state_provider.dart';
import 'package:tisini/features/auth/domain/entities/user.dart';

final userProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.user;
});
