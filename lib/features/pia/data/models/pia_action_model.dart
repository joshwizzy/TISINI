import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/domain/entities/pia_action.dart';

part 'pia_action_model.freezed.dart';
part 'pia_action_model.g.dart';

@freezed
class PiaActionModel with _$PiaActionModel {
  const factory PiaActionModel({
    required String id,
    required String type,
    required String label,
    @Default({}) Map<String, dynamic> params,
  }) = _PiaActionModel;

  const PiaActionModel._();

  factory PiaActionModel.fromJson(Map<String, dynamic> json) =>
      _$PiaActionModelFromJson(json);

  PiaAction toEntity() => PiaAction(
    id: id,
    type: _parseActionType(type),
    label: label,
    params: params,
  );

  static PiaActionType _parseActionType(String type) {
    return switch (type) {
      'set_reminder' => PiaActionType.setReminder,
      'schedule_payment' => PiaActionType.schedulePayment,
      'prepare_export' => PiaActionType.prepareExport,
      'ask_user_confirmation' => PiaActionType.askUserConfirmation,
      'mark_as_pinned' => PiaActionType.markAsPinned,
      _ => PiaActionType.askUserConfirmation,
    };
  }
}
