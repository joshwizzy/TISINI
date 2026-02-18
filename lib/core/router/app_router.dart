import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/providers/auth_state_provider.dart';
import 'package:tisini/core/router/guards/auth_guard.dart';
import 'package:tisini/core/router/guards/step_up_guard.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/activity/presentation/screens/activity_list_screen.dart';
import 'package:tisini/features/auth/presentation/screens/create_pin_screen.dart';
import 'package:tisini/features/auth/presentation/screens/login_screen.dart';
import 'package:tisini/features/auth/presentation/screens/otp_screen.dart';
import 'package:tisini/features/home/presentation/screens/attention_list_screen.dart';
import 'package:tisini/features/home/presentation/screens/dashboard_screen.dart';
import 'package:tisini/features/home/presentation/screens/home_screen.dart';
import 'package:tisini/features/home/presentation/screens/insight_detail_screen.dart';
import 'package:tisini/features/more/presentation/screens/more_hub_screen.dart';
import 'package:tisini/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:tisini/features/onboarding/presentation/screens/permissions_screen.dart';
import 'package:tisini/features/pay/presentation/screens/business/business_category_screen.dart';
import 'package:tisini/features/pay/presentation/screens/business/business_confirm_screen.dart';
import 'package:tisini/features/pay/presentation/screens/business/business_payee_screen.dart';
import 'package:tisini/features/pay/presentation/screens/business/business_receipt_screen.dart';
import 'package:tisini/features/pay/presentation/screens/pay_hub_screen.dart';
import 'package:tisini/features/pay/presentation/screens/request/request_create_screen.dart';
import 'package:tisini/features/pay/presentation/screens/request/request_share_screen.dart';
import 'package:tisini/features/pay/presentation/screens/request/request_status_screen.dart';
import 'package:tisini/features/pay/presentation/screens/scan/scan_confirm_screen.dart';
import 'package:tisini/features/pay/presentation/screens/scan/scan_manual_entry_screen.dart';
import 'package:tisini/features/pay/presentation/screens/scan/scan_receipt_screen.dart';
import 'package:tisini/features/pay/presentation/screens/scan/scan_screen.dart';
import 'package:tisini/features/pay/presentation/screens/send/send_amount_screen.dart';
import 'package:tisini/features/pay/presentation/screens/send/send_confirm_screen.dart';
import 'package:tisini/features/pay/presentation/screens/send/send_details_screen.dart';
import 'package:tisini/features/pay/presentation/screens/send/send_failed_screen.dart';
import 'package:tisini/features/pay/presentation/screens/send/send_receipt_screen.dart';
import 'package:tisini/features/pay/presentation/screens/send/send_recipient_screen.dart';
import 'package:tisini/features/pay/presentation/screens/topup/topup_amount_screen.dart';
import 'package:tisini/features/pay/presentation/screens/topup/topup_confirm_screen.dart';
import 'package:tisini/features/pay/presentation/screens/topup/topup_receipt_screen.dart';
import 'package:tisini/features/pay/presentation/screens/topup/topup_source_screen.dart';
import 'package:tisini/features/pensions/presentation/screens/pension_confirm_screen.dart';
import 'package:tisini/features/pensions/presentation/screens/pension_contribute_screen.dart';
import 'package:tisini/features/pensions/presentation/screens/pension_history_screen.dart';
import 'package:tisini/features/pensions/presentation/screens/pension_hub_screen.dart';
import 'package:tisini/features/pensions/presentation/screens/pension_receipt_screen.dart';
import 'package:tisini/features/pia/presentation/screens/pia_card_detail_screen.dart';
import 'package:tisini/features/pia/presentation/screens/pia_empty_screen.dart';
import 'package:tisini/features/pia/presentation/screens/pia_feed_screen.dart';
import 'package:tisini/features/pia/presentation/screens/pia_pinned_items_screen.dart';
import 'package:tisini/features/splash/presentation/screens/splash_screen.dart';
import 'package:tisini/shared/widgets/bottom_nav_scaffold.dart';

class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier(this._ref) {
    _ref.listen<AuthState>(authStateProvider, (_, __) {
      notifyListeners();
    });
  }

  final Ref _ref;
}

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = _AuthStateNotifier(ref);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      return authGuard(location: state.matchedLocation, authState: authState);
    },
    routes: [
      // Pre-auth routes
      GoRoute(
        path: '/',
        name: RouteNames.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: RouteNames.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: RouteNames.otp,
        builder: (_, __) => const OtpScreen(),
      ),
      GoRoute(
        path: '/create-pin',
        name: RouteNames.createPin,
        builder: (_, __) => const CreatePinScreen(),
      ),
      GoRoute(
        path: '/permissions',
        name: RouteNames.permissions,
        builder: (_, __) => const PermissionsScreen(),
      ),

      // Authenticated shell routes
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) =>
            BottomNavScaffold(navigationShell: navigationShell),
        branches: [
          // Tab 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: RouteNames.home,
                builder: (_, __) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'dashboard',
                    name: RouteNames.dashboard,
                    builder: (_, __) => const DashboardScreen(),
                  ),
                  GoRoute(
                    path: 'attention',
                    name: RouteNames.attentionList,
                    builder: (_, __) => const AttentionListScreen(),
                  ),
                  GoRoute(
                    path: 'insight/:id',
                    name: RouteNames.insightDetail,
                    builder: (_, state) => InsightDetailScreen(
                      insightId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Tab 1: Pay
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/pay',
                name: RouteNames.payHub,
                builder: (_, __) => const PayHubScreen(),
                routes: [
                  GoRoute(
                    path: 'send/recipient',
                    name: RouteNames.sendRecipient,
                    builder: (_, __) => const SendRecipientScreen(),
                  ),
                  GoRoute(
                    path: 'send/details',
                    name: RouteNames.sendDetails,
                    builder: (_, __) => const SendDetailsScreen(),
                  ),
                  GoRoute(
                    path: 'send/amount',
                    name: RouteNames.sendAmount,
                    builder: (_, __) => const SendAmountScreen(),
                  ),
                  GoRoute(
                    path: 'send/confirm',
                    name: RouteNames.sendConfirm,
                    builder: (_, __) => const SendConfirmScreen(),
                  ),
                  GoRoute(
                    path: 'send/receipt/:txId',
                    name: RouteNames.sendReceipt,
                    builder: (_, state) => SendReceiptScreen(
                      transactionId: state.pathParameters['txId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'send/failed',
                    name: RouteNames.sendFailed,
                    builder: (_, __) => const SendFailedScreen(),
                  ),
                  // Request flow
                  GoRoute(
                    path: 'request/create',
                    name: RouteNames.requestCreate,
                    builder: (_, __) => const RequestCreateScreen(),
                  ),
                  GoRoute(
                    path: 'request/share/:id',
                    name: RouteNames.requestShare,
                    builder: (_, state) => RequestShareScreen(
                      requestId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'request/status/:id',
                    name: RouteNames.requestStatus,
                    builder: (_, state) => RequestStatusScreen(
                      requestId: state.pathParameters['id']!,
                    ),
                  ),
                  // Scan flow
                  GoRoute(
                    path: 'scan',
                    name: RouteNames.scan,
                    builder: (_, __) => const ScanScreen(),
                  ),
                  GoRoute(
                    path: 'scan/manual',
                    name: RouteNames.scanManual,
                    builder: (_, __) => const ScanManualEntryScreen(),
                  ),
                  GoRoute(
                    path: 'scan/confirm',
                    name: RouteNames.scanConfirm,
                    builder: (_, __) => const ScanConfirmScreen(),
                  ),
                  GoRoute(
                    path: 'scan/receipt/:txId',
                    name: RouteNames.scanReceipt,
                    builder: (_, state) => ScanReceiptScreen(
                      transactionId: state.pathParameters['txId']!,
                    ),
                  ),
                  // Business pay flow
                  GoRoute(
                    path: 'business/category',
                    name: RouteNames.businessCategory,
                    builder: (_, __) => const BusinessCategoryScreen(),
                  ),
                  GoRoute(
                    path: 'business/payee',
                    name: RouteNames.businessPayee,
                    builder: (_, __) => const BusinessPayeeScreen(),
                  ),
                  GoRoute(
                    path: 'business/confirm',
                    name: RouteNames.businessConfirm,
                    builder: (_, __) => const BusinessConfirmScreen(),
                  ),
                  GoRoute(
                    path: 'business/receipt/:txId',
                    name: RouteNames.businessReceipt,
                    builder: (_, state) => BusinessReceiptScreen(
                      transactionId: state.pathParameters['txId']!,
                    ),
                  ),
                  // Top up flow
                  GoRoute(
                    path: 'topup/source',
                    name: RouteNames.topupSource,
                    builder: (_, __) => const TopupSourceScreen(),
                  ),
                  GoRoute(
                    path: 'topup/amount',
                    name: RouteNames.topupAmount,
                    builder: (_, __) => const TopupAmountScreen(),
                  ),
                  GoRoute(
                    path: 'topup/confirm',
                    name: RouteNames.topupConfirm,
                    builder: (_, __) => const TopupConfirmScreen(),
                  ),
                  GoRoute(
                    path: 'topup/receipt/:txId',
                    name: RouteNames.topupReceipt,
                    builder: (_, state) => TopupReceiptScreen(
                      transactionId: state.pathParameters['txId']!,
                    ),
                  ),
                  // Pension flow
                  GoRoute(
                    path: 'pensions',
                    name: RouteNames.pensionHub,
                    builder: (_, __) => const PensionHubScreen(),
                  ),
                  GoRoute(
                    path: 'pensions/contribute',
                    name: RouteNames.pensionContribute,
                    builder: (_, __) => const PensionContributeScreen(),
                  ),
                  GoRoute(
                    path: 'pensions/confirm',
                    name: RouteNames.pensionConfirm,
                    redirect: (_, state) => stepUpGuard(state),
                    builder: (_, __) => const PensionConfirmScreen(),
                  ),
                  GoRoute(
                    path: 'pensions/receipt/:txId',
                    name: RouteNames.pensionReceipt,
                    builder: (_, state) => PensionReceiptScreen(
                      transactionId: state.pathParameters['txId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'pensions/history',
                    name: RouteNames.pensionHistory,
                    builder: (_, __) => const PensionHistoryScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Tab 2: Pia
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/pia',
                name: RouteNames.piaFeed,
                builder: (_, __) => const PiaFeedScreen(),
                routes: [
                  GoRoute(
                    path: 'empty',
                    name: RouteNames.piaEmpty,
                    builder: (_, __) => const PiaEmptyScreen(),
                  ),
                  GoRoute(
                    path: 'card/:id',
                    name: RouteNames.piaCardDetail,
                    builder: (_, state) =>
                        PiaCardDetailScreen(id: state.pathParameters['id']!),
                  ),
                  GoRoute(
                    path: 'pinned',
                    name: RouteNames.piaPinned,
                    builder: (_, __) => const PiaPinnedItemsScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Tab 3: Activity
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/activity',
                name: RouteNames.activityList,
                builder: (_, __) => const ActivityListScreen(),
              ),
            ],
          ),

          // Tab 4: More
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                name: RouteNames.moreHub,
                builder: (_, __) => const MoreHubScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
