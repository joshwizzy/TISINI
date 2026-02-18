import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/home/domain/entities/badge.dart';
import 'package:tisini/features/home/providers/home_repository_provider.dart';

final badgesProvider = FutureProvider<List<Badge>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getBadges();
});
