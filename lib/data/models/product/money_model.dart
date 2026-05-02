import 'package:equatable/equatable.dart';

import '../../../domain/entity/product/money_entity.dart';

class MoneyModel extends Equatable {
  final String currency;
  final double value;

  const MoneyModel({required this.currency, required this.value});

  factory MoneyModel.fromJson(Map<String, dynamic> json) => MoneyModel(
        currency: json['currency'] ?? '',
        value: json['value'] ?? 0.0,
      );

  MoneyEntity toEntity() {
    return MoneyEntity(
      currency: currency,
      value: value,
    );
  }

  @override
  List<Object?> get props => [currency, value];
}