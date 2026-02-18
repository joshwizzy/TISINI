import 'package:go_router/go_router.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';

/// KYC guard — redirects non-approved users to /more/kyc.
String? kycGuard(GoRouterState state, {KycStatus? status}) {
  if (status == null || status == KycStatus.approved) {
    return null;
  }
  return '/more/kyc';
}
