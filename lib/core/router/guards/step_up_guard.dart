import 'package:go_router/go_router.dart';

/// Stub step-up guard — always allows access.
/// Will trigger PIN/biometric re-verification for risky actions.
String? stepUpGuard(GoRouterState state) {
  // TODO(tisini): Implement with lastVerifiedAt timestamp
  return null;
}
