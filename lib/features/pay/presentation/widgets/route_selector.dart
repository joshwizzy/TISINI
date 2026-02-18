import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/providers/payment_routes_provider.dart';
import 'package:tisini/shared/widgets/route_chip.dart';

class RouteSelector extends ConsumerWidget {
  const RouteSelector({
    required this.selectedRoute,
    required this.onRouteSelected,
    super.key,
  });

  final PaymentRoute? selectedRoute;
  final ValueChanged<PaymentRoute> onRouteSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routesAsync = ref.watch(paymentRoutesProvider);

    return routesAsync.when(
      data: (routes) => SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: routes.length,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
          itemBuilder: (context, index) {
            final route = routes[index];
            return RouteChip(
              rail: route.rail,
              label: route.label,
              isSelected: selectedRoute?.rail == route.rail,
              isAvailable: route.isAvailable,
              onTap: () => onRouteSelected(route),
            );
          },
        ),
      ),
      loading: () => const SizedBox(height: 36),
      error: (_, __) => const SizedBox(height: 36),
    );
  }
}
