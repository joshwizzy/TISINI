import 'package:tisini/features/activity/domain/entities/transaction.dart';
import 'package:tisini/features/home/domain/entities/attention_item.dart';
import 'package:tisini/features/home/domain/entities/badge.dart';
import 'package:tisini/features/home/domain/entities/dashboard_indicator.dart';
import 'package:tisini/features/home/domain/entities/tisini_index.dart';
import 'package:tisini/features/home/domain/entities/wallet_balance.dart';
import 'package:tisini/features/pia/domain/entities/pia_card.dart';

abstract class HomeRepository {
  Future<TisiniIndex> getDashboard();

  Future<List<DashboardIndicator>> getDashboardIndicators();

  Future<List<AttentionItem>> getAttentionItems();

  Future<AttentionItem> getInsight({required String id});

  Future<WalletBalance> getWalletBalance();

  Future<List<Transaction>> getRecentTransactions();

  Future<List<Badge>> getBadges();

  Future<PiaCard?> getPiaGuidanceCard();
}
