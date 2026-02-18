import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/activity/presentation/screens/activity_list_screen.dart';
import 'package:tisini/features/home/presentation/screens/home_screen.dart';
import 'package:tisini/features/more/presentation/screens/more_hub_screen.dart';
import 'package:tisini/features/pay/presentation/screens/pay_hub_screen.dart';
import 'package:tisini/features/pia/presentation/screens/pia_feed_screen.dart';
import 'package:tisini/shared/widgets/bottom_nav_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,
    routes: [
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
