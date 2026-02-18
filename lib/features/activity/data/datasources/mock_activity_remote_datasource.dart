import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/data/datasources/activity_remote_datasource.dart';
import 'package:tisini/features/activity/data/models/export_job_model.dart';
import 'package:tisini/features/activity/data/models/transaction_model.dart';
import 'package:tisini/features/activity/domain/entities/transaction_filters.dart';

class MockActivityRemoteDatasource implements ActivityRemoteDatasource {
  static const _readDelay = Duration(milliseconds: 300);
  static const _writeDelay = Duration(milliseconds: 800);

  static final _now = DateTime.now();

  final List<TransactionModel> _transactions = [
    TransactionModel(
      id: 'txn-001',
      type: 'send',
      direction: 'outbound',
      status: 'completed',
      amount: 150000,
      currency: 'UGX',
      counterpartyName: 'Nakawa Hardware',
      counterpartyIdentifier: '0772100200',
      category: 'inventory',
      rail: 'mobile_money',
      createdAt: _now.subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
      fee: 500,
    ),
    TransactionModel(
      id: 'txn-002',
      type: 'request',
      direction: 'inbound',
      status: 'completed',
      amount: 500000,
      currency: 'UGX',
      counterpartyName: 'Grace Auma',
      counterpartyIdentifier: '0701234567',
      category: 'sales',
      rail: 'mobile_money',
      createdAt: _now.subtract(const Duration(hours: 3)).millisecondsSinceEpoch,
    ),
    TransactionModel(
      id: 'txn-003',
      type: 'business_pay',
      direction: 'outbound',
      status: 'completed',
      amount: 1200000,
      currency: 'UGX',
      counterpartyName: 'Kampala Properties Ltd',
      counterpartyIdentifier: '0312456789',
      category: 'bills',
      rail: 'bank',
      createdAt: _now.subtract(const Duration(hours: 6)).millisecondsSinceEpoch,
      merchantRole: 'rent',
      fee: 2000,
    ),
    TransactionModel(
      id: 'txn-004',
      type: 'send',
      direction: 'outbound',
      status: 'pending',
      amount: 80000,
      currency: 'UGX',
      counterpartyName: 'David Ochieng',
      counterpartyIdentifier: '0782345678',
      category: 'people',
      rail: 'mobile_money',
      createdAt: _now
          .subtract(const Duration(days: 1, hours: 2))
          .millisecondsSinceEpoch,
    ),
    TransactionModel(
      id: 'txn-005',
      type: 'scan_pay',
      direction: 'outbound',
      status: 'completed',
      amount: 25000,
      currency: 'UGX',
      counterpartyName: 'Café Javas Acacia',
      counterpartyIdentifier: 'QR-CJ-001',
      category: 'bills',
      rail: 'wallet',
      createdAt: _now
          .subtract(const Duration(days: 1, hours: 5))
          .millisecondsSinceEpoch,
    ),
    TransactionModel(
      id: 'txn-006',
      type: 'request',
      direction: 'inbound',
      status: 'completed',
      amount: 750000,
      currency: 'UGX',
      counterpartyName: 'Sarah Nabwire',
      counterpartyIdentifier: '0756789012',
      category: 'sales',
      rail: 'mobile_money',
      createdAt: _now.subtract(const Duration(days: 2)).millisecondsSinceEpoch,
    ),
    TransactionModel(
      id: 'txn-007',
      type: 'top_up',
      direction: 'inbound',
      status: 'completed',
      amount: 2000000,
      currency: 'UGX',
      counterpartyName: 'Stanbic Bank',
      counterpartyIdentifier: 'ACC-9087654321',
      category: 'uncategorised',
      rail: 'bank',
      createdAt: _now.subtract(const Duration(days: 3)).millisecondsSinceEpoch,
      fee: 3000,
    ),
    TransactionModel(
      id: 'txn-008',
      type: 'pension_contribution',
      direction: 'outbound',
      status: 'completed',
      amount: 5000000,
      currency: 'UGX',
      counterpartyName: 'NSSF Uganda',
      counterpartyIdentifier: 'NSSF-EMP-2024',
      category: 'compliance',
      rail: 'bank',
      createdAt: _now.subtract(const Duration(days: 5)).millisecondsSinceEpoch,
      merchantRole: 'pension',
      fee: 5000,
    ),
    TransactionModel(
      id: 'txn-009',
      type: 'send',
      direction: 'outbound',
      status: 'failed',
      amount: 300000,
      currency: 'UGX',
      counterpartyName: 'Mukasa Traders',
      counterpartyIdentifier: '0772890123',
      category: 'inventory',
      rail: 'mobile_money',
      createdAt: _now.subtract(const Duration(days: 6)).millisecondsSinceEpoch,
    ),
    TransactionModel(
      id: 'txn-010',
      type: 'business_pay',
      direction: 'outbound',
      status: 'completed',
      amount: 450000,
      currency: 'UGX',
      counterpartyName: 'UMEME',
      counterpartyIdentifier: 'ACC-UMEME-4521',
      category: 'bills',
      rail: 'mobile_money',
      createdAt: _now.subtract(const Duration(days: 7)).millisecondsSinceEpoch,
      merchantRole: 'utilities',
      fee: 1000,
    ),
    TransactionModel(
      id: 'txn-011',
      type: 'request',
      direction: 'inbound',
      status: 'completed',
      amount: 180000,
      currency: 'UGX',
      counterpartyName: 'Peter Kasozi',
      counterpartyIdentifier: '0703456789',
      category: 'sales',
      rail: 'mobile_money',
      createdAt: _now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
    ),
    TransactionModel(
      id: 'txn-012',
      type: 'send',
      direction: 'outbound',
      status: 'completed',
      amount: 600000,
      currency: 'UGX',
      counterpartyName: 'Kampala Supplies Co',
      counterpartyIdentifier: '0312567890',
      category: 'inventory',
      rail: 'bank',
      createdAt: _now.subtract(const Duration(days: 12)).millisecondsSinceEpoch,
      merchantRole: 'supplier',
      fee: 2500,
    ),
    TransactionModel(
      id: 'txn-013',
      type: 'business_pay',
      direction: 'outbound',
      status: 'completed',
      amount: 350000,
      currency: 'UGX',
      counterpartyName: 'URA',
      counterpartyIdentifier: 'TIN-1234567890',
      category: 'compliance',
      rail: 'bank',
      createdAt: _now.subtract(const Duration(days: 15)).millisecondsSinceEpoch,
      merchantRole: 'tax',
      fee: 1500,
    ),
    TransactionModel(
      id: 'txn-014',
      type: 'send',
      direction: 'outbound',
      status: 'completed',
      amount: 200000,
      currency: 'UGX',
      counterpartyName: 'Agnes Namuli',
      counterpartyIdentifier: '0774567890',
      category: 'people',
      rail: 'mobile_money',
      createdAt: _now.subtract(const Duration(days: 18)).millisecondsSinceEpoch,
      note: 'Salary advance',
      merchantRole: 'wages',
    ),
    TransactionModel(
      id: 'txn-015',
      type: 'request',
      direction: 'inbound',
      status: 'processing',
      amount: 1500000,
      currency: 'UGX',
      counterpartyName: 'Jinja Wholesalers',
      counterpartyIdentifier: '0705678901',
      category: 'sales',
      rail: 'mobile_money',
      createdAt: _now.subtract(const Duration(days: 20)).millisecondsSinceEpoch,
    ),
    TransactionModel(
      id: 'txn-016',
      type: 'scan_pay',
      direction: 'outbound',
      status: 'completed',
      amount: 35000,
      currency: 'UGX',
      counterpartyName: 'Shell Bugolobi',
      counterpartyIdentifier: 'QR-SHELL-002',
      category: 'bills',
      rail: 'wallet',
      createdAt: _now.subtract(const Duration(days: 22)).millisecondsSinceEpoch,
    ),
    TransactionModel(
      id: 'txn-017',
      type: 'top_up',
      direction: 'inbound',
      status: 'completed',
      amount: 3000000,
      currency: 'UGX',
      counterpartyName: 'DFCU Bank',
      counterpartyIdentifier: 'ACC-DFCU-7890',
      category: 'uncategorised',
      rail: 'bank',
      createdAt: _now.subtract(const Duration(days: 25)).millisecondsSinceEpoch,
      fee: 3500,
    ),
    TransactionModel(
      id: 'txn-018',
      type: 'send',
      direction: 'outbound',
      status: 'completed',
      amount: 100000,
      currency: 'UGX',
      counterpartyName: 'Ronald Mugisha',
      counterpartyIdentifier: '0786789012',
      category: 'agency',
      rail: 'mobile_money',
      createdAt: _now.subtract(const Duration(days: 28)).millisecondsSinceEpoch,
    ),
  ];

  @override
  Future<
    ({List<TransactionModel> transactions, String? nextCursor, bool hasMore})
  >
  getTransactions({
    TransactionFilters? filters,
    String? cursor,
    int limit = 20,
  }) async {
    await Future<void>.delayed(_readDelay);

    var filtered = List<TransactionModel>.from(_transactions);

    if (filters != null && !filters.isEmpty) {
      if (filters.direction != null) {
        final dir = filters.direction == TransactionDirection.inbound
            ? 'inbound'
            : 'outbound';
        filtered = filtered.where((t) => t.direction == dir).toList();
      }

      if (filters.categories.isNotEmpty) {
        final cats = filters.categories.map((c) => c.name).toSet();
        filtered = filtered.where((t) => cats.contains(t.category)).toList();
      }

      if (filters.startDate != null) {
        final startMs = filters.startDate!.millisecondsSinceEpoch;
        filtered = filtered.where((t) => t.createdAt >= startMs).toList();
      }

      if (filters.endDate != null) {
        final endMs = filters.endDate!.millisecondsSinceEpoch;
        filtered = filtered.where((t) => t.createdAt <= endMs).toList();
      }
    }

    final startIndex = cursor != null
        ? filtered.indexWhere((t) => t.id == cursor) + 1
        : 0;

    final end = (startIndex + limit).clamp(0, filtered.length);
    final page = filtered.sublist(startIndex, end);
    final hasMore = end < filtered.length;
    final nextCursor = hasMore ? page.last.id : null;

    return (transactions: page, nextCursor: nextCursor, hasMore: hasMore);
  }

  @override
  Future<TransactionModel> getTransaction(String id) async {
    await Future<void>.delayed(_readDelay);

    return _transactions.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Transaction not found: $id'),
    );
  }

  @override
  Future<TransactionModel> updateCategory({
    required String transactionId,
    required TransactionCategory category,
  }) async {
    await Future<void>.delayed(_writeDelay);

    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index == -1) {
      throw Exception('Transaction not found: $transactionId');
    }

    final current = _transactions[index];
    final updated = _copyWith(current, category: category.name);
    _transactions[index] = updated;
    return updated;
  }

  @override
  Future<TransactionModel> pinMerchant({
    required String transactionId,
    required MerchantRole role,
  }) async {
    await Future<void>.delayed(_writeDelay);

    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index == -1) {
      throw Exception('Transaction not found: $transactionId');
    }

    final current = _transactions[index];
    final updated = _copyWith(current, merchantRole: role.name);
    _transactions[index] = updated;
    return updated;
  }

  @override
  Future<TransactionModel> updateNote({
    required String transactionId,
    required String note,
  }) async {
    await Future<void>.delayed(_writeDelay);

    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index == -1) {
      throw Exception('Transaction not found: $transactionId');
    }

    final current = _transactions[index];
    final updated = _copyWith(current, note: note);
    _transactions[index] = updated;
    return updated;
  }

  @override
  Future<ExportJobModel> createExport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future<void>.delayed(_writeDelay);

    final now = DateTime.now();
    return ExportJobModel(
      id: 'exp-${now.millisecondsSinceEpoch}',
      startDate: startDate.millisecondsSinceEpoch,
      endDate: endDate.millisecondsSinceEpoch,
      status: 'completed',
      createdAt: now.millisecondsSinceEpoch,
      downloadUrl:
          'https://api.tisini.co/v1/exports/'
          'exp-${now.millisecondsSinceEpoch}.csv',
    );
  }

  @override
  Future<int> getEstimatedExportRows({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future<void>.delayed(_readDelay);

    final startMs = startDate.millisecondsSinceEpoch;
    final endMs = endDate.millisecondsSinceEpoch;
    return _transactions
        .where((t) => t.createdAt >= startMs && t.createdAt <= endMs)
        .length;
  }

  TransactionModel _copyWith(
    TransactionModel original, {
    String? category,
    String? merchantRole,
    String? note,
  }) {
    return TransactionModel(
      id: original.id,
      type: original.type,
      direction: original.direction,
      status: original.status,
      amount: original.amount,
      currency: original.currency,
      counterpartyName: original.counterpartyName,
      counterpartyIdentifier: original.counterpartyIdentifier,
      category: category ?? original.category,
      rail: original.rail,
      createdAt: original.createdAt,
      merchantRole: merchantRole ?? original.merchantRole,
      note: note ?? original.note,
      fee: original.fee,
    );
  }
}
