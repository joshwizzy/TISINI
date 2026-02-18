import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/home/domain/entities/tisini_index.dart';
import 'package:tisini/features/home/providers/home_repository_provider.dart';

final tisiniIndexProvider = FutureProvider<TisiniIndex>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getDashboard();
});
