import 'package:go_router/go_router.dart';

/// Stub KYC guard — always allows access.
/// Will block non-approved KYC users from payment flows.
String? kycGuard(GoRouterState state) {
  // TODO(tisini): Implement with KycStatus from kyc_provider
  return null;
}
