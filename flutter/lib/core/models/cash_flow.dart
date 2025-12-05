import 'package:freezed_annotation/freezed_annotation.dart';

part 'cash_flow.freezed.dart';
part 'cash_flow.g.dart';

@freezed
class CashFlow with _$CashFlow {
  const factory CashFlow({
    required String id,
    required double amount,
    required String date,
    required String category,
    required String type, // 'income' or 'outcome'
    String? description,
  }) = _CashFlow;

  factory CashFlow.fromJson(Map<String, dynamic> json) =>
      _$CashFlowFromJson(json);
}
