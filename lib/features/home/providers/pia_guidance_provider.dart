import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/home/providers/home_repository_provider.dart';
import 'package:tisini/features/pia/domain/entities/pia_card.dart';

final piaGuidanceProvider = FutureProvider<PiaCard?>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getPiaGuidanceCard();
});
