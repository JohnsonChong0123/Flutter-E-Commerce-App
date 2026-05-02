import 'package:equatable/equatable.dart';

import 'money_entity.dart';

class ShippingOptionEntity extends Equatable {
  final String shippingServiceCode;
  final String type;
  final MoneyEntity? shippingCost;
  final int? quantityUsedForEstimate;
  final MoneyEntity? additionalShippingCostPerUnit;
  final String? shippingCostType;

  const ShippingOptionEntity({
    required this.shippingServiceCode,
    required this.type,
    this.shippingCost,
    this.quantityUsedForEstimate,
    this.additionalShippingCostPerUnit,
    this.shippingCostType,
  });

  ShippingOptionEntity copyWith({
    String? shippingServiceCode,
    String? type,
    MoneyEntity? shippingCost,
    int? quantityUsedForEstimate,
    MoneyEntity? additionalShippingCostPerUnit,
    String? shippingCostType,
  }) {
    return ShippingOptionEntity(
      shippingServiceCode: shippingServiceCode ?? this.shippingServiceCode,
      type: type ?? this.type,
      shippingCost: shippingCost ?? this.shippingCost,
      quantityUsedForEstimate: quantityUsedForEstimate ?? this.quantityUsedForEstimate,
      additionalShippingCostPerUnit: additionalShippingCostPerUnit ?? this.additionalShippingCostPerUnit,
      shippingCostType: shippingCostType ?? this.shippingCostType,
    );
  }

  @override
  List<Object?> get props => [
        shippingServiceCode,
        type,
        shippingCost,
        quantityUsedForEstimate,
        additionalShippingCostPerUnit,
        shippingCostType,
      ];
}
