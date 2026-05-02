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
