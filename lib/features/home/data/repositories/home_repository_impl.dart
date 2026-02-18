import 'package:tisini/features/activity/domain/entities/transaction.dart';
import 'package:tisini/features/home/data/datasources/home_remote_datasource.dart';
import 'package:tisini/features/home/domain/entities/attention_item.dart';
import 'package:tisini/features/home/domain/entities/badge.dart';
import 'package:tisini/features/home/domain/entities/dashboard_indicator.dart';
import 'package:tisini/features/home/domain/entities/tisini_index.dart';
import 'package:tisini/features/home/domain/entities/wallet_balance.dart';
import 'package:tisini/features/home/domain/repositories/home_repository.dart';
import 'package:tisini/features/pia/domain/entities/pia_card.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required HomeRemoteDatasource datasource})
    : _datasource = datasource;

  final HomeRemoteDatasource _datasource;

  @override
  Future<TisiniIndex> getDashboard() async {
    final model = await _datasource.getDashboard();
    return model.toEntity();
  }

  @override
  Future<List<DashboardIndicator>> getDashboardIndicators() async {
    final models = await _datasource.getDashboardIndicators();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<AttentionItem>> getAttentionItems() async {
    final models = await _datasource.getAttentionItems();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<AttentionItem> getInsight({required String id}) async {
    final model = await _datasource.getInsight(id: id);
    return model.toEntity();
  }

  @override
  Future<WalletBalance> getWalletBalance() async {
    final model = await _datasource.getWalletBalance();
    return model.toEntity();
  }

  @override
  Future<List<Transaction>> getRecentTransactions() async {
    final models = await _datasource.getRecentTransactions();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Badge>> getBadges() async {
    final models = await _datasource.getBadges();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<PiaCard?> getPiaGuidanceCard() async {
    final model = await _datasource.getPiaGuidanceCard();
    return model?.toEntity();
  }
}
