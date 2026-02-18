import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/home/domain/entities/attention_item.dart';
import 'package:tisini/features/home/providers/home_repository_provider.dart';

final attentionItemsProvider = FutureProvider<List<AttentionItem>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getAttentionItems();
});
