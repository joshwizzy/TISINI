import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/home/domain/entities/dashboard_indicator.dart';
import 'package:tisini/features/home/providers/home_repository_provider.dart';

final dashboardIndicatorsProvider = FutureProvider<List<DashboardIndicator>>((
  ref,
) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getDashboardIndicators();
});
