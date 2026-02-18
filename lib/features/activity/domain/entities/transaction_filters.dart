import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';

part 'transaction_filters.freezed.dart';

@freezed
class TransactionFilters with _$TransactionFilters {
  const factory TransactionFilters({
    TransactionDirection? direction,
    @Default([]) List<TransactionCategory> categories,
    DateTime? startDate,
    DateTime? endDate,
  }) = _TransactionFilters;

  const TransactionFilters._();

  bool get isEmpty =>
      direction == null &&
      categories.isEmpty &&
      startDate == null &&
      endDate == null;

  int get activeCount {
    var count = 0;
    if (direction != null) count++;
    if (categories.isNotEmpty) count++;
    if (startDate != null || endDate != null) count++;
    return count;
  }
}
