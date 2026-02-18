import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/home/domain/entities/attention_item.dart';
import 'package:tisini/features/home/providers/home_repository_provider.dart';

final insightDetailProvider = FutureProvider.family<AttentionItem, String>((
  ref,
  id,
) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getInsight(id: id);
});
