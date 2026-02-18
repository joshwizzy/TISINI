enum PaymentRail { bank, mobileMoney, card, wallet }

enum PaymentStatus { pending, processing, completed, failed, reversed }

enum PaymentType {
  send,
  request,
  scanPay,
  businessPay,
  topUp,
  pensionContribution,
}

enum TransactionDirection { inbound, outbound }

enum TransactionCategory {
  sales,
  inventory,
  bills,
  people,
  compliance,
  agency,
  uncategorised,
}

enum MerchantRole { supplier, rent, wages, tax, pension, utilities }

enum PiaActionType {
  setReminder,
  schedulePayment,
  prepareExport,
  askUserConfirmation,
  markAsPinned,
}

enum PiaCardPriority { high, medium, low }

enum PiaCardStatus { active, dismissed, actioned, expired }

enum IndicatorType {
  paymentConsistency,
  complianceReadiness,
  businessMomentum,
  dataCompleteness,
}

enum PensionLinkStatus { linked, notLinked, verifying }

enum ContributionStatus { pending, completed, failed }

enum AccountProvider { mtn, airtel, stanbic, dfcu, equity, centenary }

enum KycAccountType { business, gig }

enum ImportSource { bank, mobileMoney }

enum ImportJobStatus { uploading, mapping, processing, completed, failed }

enum KycDocumentType {
  idFront,
  idBack,
  selfie,
  businessRegistration,
  licence,
  tin,
}
