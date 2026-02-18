import 'package:tisini/features/activity/data/models/transaction_model.dart';
import 'package:tisini/features/home/data/datasources/home_remote_datasource.dart';
import 'package:tisini/features/home/data/models/attention_item_model.dart';
import 'package:tisini/features/home/data/models/badge_model.dart';
import 'package:tisini/features/home/data/models/dashboard_indicator_model.dart';
import 'package:tisini/features/home/data/models/tisini_index_model.dart';
import 'package:tisini/features/home/data/models/wallet_balance_model.dart';
import 'package:tisini/features/pia/data/models/pia_action_model.dart';
import 'package:tisini/features/pia/data/models/pia_card_model.dart';

class MockHomeRemoteDatasource implements HomeRemoteDatasource {
  static const _delay = Duration(milliseconds: 300);

  @override
  Future<TisiniIndexModel> getDashboard() async {
    await Future<void>.delayed(_delay);
    return TisiniIndexModel(
      score: 64,
      paymentConsistency: 72,
      complianceReadiness: 55,
      businessMomentum: 68,
      dataCompleteness: 61,
      changeReason: 'Consistent payment activity this week',
      changeAmount: 3,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<List<DashboardIndicatorModel>> getDashboardIndicators() async {
    await Future<void>.delayed(_delay);
    return const [
      DashboardIndicatorModel(
        type: 'payment_consistency',
        label: 'Payment Consistency',
        value: 72,
        maxValue: 90,
        percentage: 0.8,
      ),
      DashboardIndicatorModel(
        type: 'compliance_readiness',
        label: 'Compliance Readiness',
        value: 55,
        maxValue: 90,
        percentage: 0.61,
      ),
      DashboardIndicatorModel(
        type: 'business_momentum',
        label: 'Business Momentum',
        value: 68,
        maxValue: 90,
        percentage: 0.76,
      ),
      DashboardIndicatorModel(
        type: 'data_completeness',
        label: 'Data Completeness',
        value: 61,
        maxValue: 90,
        percentage: 0.68,
      ),
    ];
  }

  @override
  Future<List<AttentionItemModel>> getAttentionItems() async {
    await Future<void>.delayed(_delay);
    final now = DateTime.now().millisecondsSinceEpoch;
    return [
      AttentionItemModel(
        id: 'att-001',
        title: 'Complete KYC verification',
        description:
            'Verify your identity to unlock higher transaction limits '
            'and all payment features.',
        actionLabel: 'Start verification',
        actionRoute: '/kyc',
        priority: 'high',
        createdAt: now,
      ),
      AttentionItemModel(
        id: 'att-002',
        title: 'Connect a bank account',
        description:
            'Link your bank account for faster payments and '
            'improved business insights.',
        actionLabel: 'Connect account',
        actionRoute: '/more/connected-accounts',
        priority: 'medium',
        createdAt: now,
      ),
      AttentionItemModel(
        id: 'att-003',
        title: 'Set up pension contributions',
        description:
            'Start contributing to your pension to improve '
            'your compliance score.',
        actionLabel: 'Set up pension',
        actionRoute: '/pension',
        priority: 'low',
        createdAt: now,
      ),
    ];
  }

  @override
  Future<AttentionItemModel> getInsight({required String id}) async {
    await Future<void>.delayed(_delay);
    final items = await getAttentionItems();
    return items.firstWhere((item) => item.id == id, orElse: () => items.first);
  }

  @override
  Future<WalletBalanceModel> getWalletBalance() async {
    await Future<void>.delayed(_delay);
    return const WalletBalanceModel(balance: 1250000, currency: 'UGX');
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions() async {
    await Future<void>.delayed(_delay);
    final now = DateTime.now();
    return [
      TransactionModel(
        id: 'tx-001',
        type: 'send',
        direction: 'outbound',
        status: 'completed',
        amount: 150000,
        currency: 'UGX',
        counterpartyName: 'Jane Nakamya',
        counterpartyIdentifier: '+256700100200',
        category: 'people',
        rail: 'mobile_money',
        createdAt: now
            .subtract(const Duration(hours: 2))
            .millisecondsSinceEpoch,
      ),
      TransactionModel(
        id: 'tx-002',
        type: 'request',
        direction: 'inbound',
        status: 'completed',
        amount: 500000,
        currency: 'UGX',
        counterpartyName: 'Kampala Traders Ltd',
        counterpartyIdentifier: 'BIZ-KTL-001',
        category: 'sales',
        rail: 'mobile_money',
        createdAt: now
            .subtract(const Duration(hours: 5))
            .millisecondsSinceEpoch,
      ),
      TransactionModel(
        id: 'tx-003',
        type: 'business_pay',
        direction: 'outbound',
        status: 'completed',
        amount: 320000,
        currency: 'UGX',
        counterpartyName: 'ABC Supplies',
        counterpartyIdentifier: 'BIZ-ABC-001',
        category: 'inventory',
        rail: 'bank',
        merchantRole: 'supplier',
        note: 'Weekly stock order',
        fee: 1500,
        createdAt: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
      ),
      TransactionModel(
        id: 'tx-004',
        type: 'top_up',
        direction: 'inbound',
        status: 'completed',
        amount: 1000000,
        currency: 'UGX',
        counterpartyName: 'MTN Mobile Money',
        counterpartyIdentifier: 'MM-MTN',
        category: 'uncategorised',
        rail: 'mobile_money',
        createdAt: now.subtract(const Duration(days: 2)).millisecondsSinceEpoch,
      ),
      TransactionModel(
        id: 'tx-005',
        type: 'business_pay',
        direction: 'outbound',
        status: 'completed',
        amount: 85000,
        currency: 'UGX',
        counterpartyName: 'UMEME',
        counterpartyIdentifier: 'BIZ-UMEME',
        category: 'bills',
        rail: 'mobile_money',
        merchantRole: 'utilities',
        createdAt: now.subtract(const Duration(days: 3)).millisecondsSinceEpoch,
      ),
    ];
  }

  @override
  Future<List<BadgeModel>> getBadges() async {
    await Future<void>.delayed(_delay);
    final now = DateTime.now().millisecondsSinceEpoch;
    return [
      BadgeModel(
        id: 'badge-001',
        label: 'First Payment',
        iconName: 'rocket',
        isEarned: true,
        earnedAt: now,
      ),
      const BadgeModel(
        id: 'badge-002',
        label: 'KYC Verified',
        iconName: 'shieldCheck',
        isEarned: false,
      ),
      BadgeModel(
        id: 'badge-003',
        label: 'Consistent Payer',
        iconName: 'chartLineUp',
        isEarned: true,
        earnedAt: now,
      ),
      const BadgeModel(
        id: 'badge-004',
        label: 'Data Champion',
        iconName: 'database',
        isEarned: false,
      ),
      const BadgeModel(
        id: 'badge-005',
        label: 'Pension Saver',
        iconName: 'piggyBank',
        isEarned: false,
      ),
    ];
  }

  @override
  Future<PiaCardModel?> getPiaGuidanceCard() async {
    await Future<void>.delayed(_delay);
    final now = DateTime.now().millisecondsSinceEpoch;
    return PiaCardModel(
      id: 'pia-guidance-001',
      title: 'Supplier payment due soon',
      what: 'ABC Supplies invoice of UGX 320,000 is due in 3 days',
      why: 'Paying on time keeps your payment consistency score high',
      details:
          'You have a recurring order with ABC Supplies. '
          'Scheduling this payment ensures you maintain your '
          'supplier relationship and consistency score.',
      actions: const [
        PiaActionModel(
          id: 'pia-action-001',
          type: 'schedule_payment',
          label: 'Schedule payment',
        ),
        PiaActionModel(
          id: 'pia-action-002',
          type: 'set_reminder',
          label: 'Remind me later',
        ),
      ],
      priority: 'medium',
      status: 'active',
      isPinned: false,
      createdAt: now,
    );
  }
}
