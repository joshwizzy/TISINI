import 'package:tisini/features/activity/data/models/transaction_model.dart';
import 'package:tisini/features/home/data/models/attention_item_model.dart';
import 'package:tisini/features/home/data/models/badge_model.dart';
import 'package:tisini/features/home/data/models/dashboard_indicator_model.dart';
import 'package:tisini/features/home/data/models/tisini_index_model.dart';
import 'package:tisini/features/home/data/models/wallet_balance_model.dart';
import 'package:tisini/features/pia/data/models/pia_card_model.dart';

abstract class HomeRemoteDatasource {
  Future<TisiniIndexModel> getDashboard();

  Future<List<DashboardIndicatorModel>> getDashboardIndicators();

  Future<List<AttentionItemModel>> getAttentionItems();

  Future<AttentionItemModel> getInsight({required String id});

  Future<WalletBalanceModel> getWalletBalance();

  Future<List<TransactionModel>> getRecentTransactions();

  Future<List<BadgeModel>> getBadges();

  Future<PiaCardModel?> getPiaGuidanceCard();
}
