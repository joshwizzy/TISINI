import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';

part 'pia_action.freezed.dart';

@freezed
class PiaAction with _$PiaAction {
  const factory PiaAction({
    required String id,
    required PiaActionType type,
    required String label,
    @Default({}) Map<String, dynamic> params,
  }) = _PiaAction;
}
