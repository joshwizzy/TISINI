import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';

void main() {
  group('PaymentRail', () {
    test('has correct values', () {
      expect(PaymentRail.values, hasLength(4));
      expect(PaymentRail.values.map((e) => e.name), [
        'bank',
        'mobileMoney',
        'card',
        'wallet',
      ]);
    });
  });

  group('PaymentStatus', () {
    test('has correct values', () {
      expect(PaymentStatus.values, hasLength(5));
      expect(PaymentStatus.values.map((e) => e.name), [
        'pending',
        'processing',
        'completed',
        'failed',
        'reversed',
      ]);
    });
  });

  group('PaymentType', () {
    test('has correct values', () {
      expect(PaymentType.values, hasLength(6));
      expect(PaymentType.values.map((e) => e.name), [
        'send',
        'request',
        'scanPay',
        'businessPay',
        'topUp',
        'pensionContribution',
      ]);
    });
  });

  group('TransactionDirection', () {
    test('has correct values', () {
      expect(TransactionDirection.values, hasLength(2));
      expect(TransactionDirection.values.map((e) => e.name), [
        'inbound',
        'outbound',
      ]);
    });
  });

  group('TransactionCategory', () {
    test('has correct values', () {
      expect(TransactionCategory.values, hasLength(7));
      expect(TransactionCategory.values.map((e) => e.name), [
        'sales',
        'inventory',
        'bills',
        'people',
        'compliance',
        'agency',
        'uncategorised',
      ]);
    });
  });

  group('MerchantRole', () {
    test('has correct values', () {
      expect(MerchantRole.values, hasLength(6));
      expect(MerchantRole.values.map((e) => e.name), [
        'supplier',
        'rent',
        'wages',
        'tax',
        'pension',
        'utilities',
      ]);
    });
  });

  group('PiaActionType', () {
    test('has correct values', () {
      expect(PiaActionType.values, hasLength(5));
      expect(PiaActionType.values.map((e) => e.name), [
        'setReminder',
        'schedulePayment',
        'prepareExport',
        'askUserConfirmation',
        'markAsPinned',
      ]);
    });
  });

  group('PiaCardPriority', () {
    test('has correct values', () {
      expect(PiaCardPriority.values, hasLength(3));
      expect(PiaCardPriority.values.map((e) => e.name), [
        'high',
        'medium',
        'low',
      ]);
    });
  });

  group('PiaCardStatus', () {
    test('has correct values', () {
      expect(PiaCardStatus.values, hasLength(4));
      expect(PiaCardStatus.values.map((e) => e.name), [
        'active',
        'dismissed',
        'actioned',
        'expired',
      ]);
    });
  });

  group('IndicatorType', () {
    test('has correct values', () {
      expect(IndicatorType.values, hasLength(4));
      expect(IndicatorType.values.map((e) => e.name), [
        'paymentConsistency',
        'complianceReadiness',
        'businessMomentum',
        'dataCompleteness',
      ]);
    });
  });

  group('PensionLinkStatus', () {
    test('has correct values', () {
      expect(PensionLinkStatus.values, hasLength(3));
      expect(PensionLinkStatus.values.map((e) => e.name), [
        'linked',
        'notLinked',
        'verifying',
      ]);
    });
  });

  group('ContributionStatus', () {
    test('has correct values', () {
      expect(ContributionStatus.values, hasLength(3));
      expect(ContributionStatus.values.map((e) => e.name), [
        'pending',
        'completed',
        'failed',
      ]);
    });
  });

  group('AccountProvider', () {
    test('has correct values', () {
      expect(AccountProvider.values, hasLength(6));
      expect(AccountProvider.values.map((e) => e.name), [
        'mtn',
        'airtel',
        'stanbic',
        'dfcu',
        'equity',
        'centenary',
      ]);
    });
  });

  group('KycAccountType', () {
    test('has correct values', () {
      expect(KycAccountType.values, hasLength(2));
      expect(KycAccountType.values.map((e) => e.name), ['business', 'gig']);
    });
  });
}
