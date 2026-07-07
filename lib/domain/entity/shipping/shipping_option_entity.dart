import 'package:equatable/equatable.dart';

import 'money_entity.dart';

class ShippingOptionEntity extends Equatable {
  final String shippingServiceCode;
  final String type;
  final MoneyEntity? shippingCost;
  final MoneyEntity? additionalShippingCostPerUnit;
  final String? shippingCostType;

  const ShippingOptionEntity({
    required this.shippingServiceCode,
    required this.type,
    this.shippingCost,
    this.additionalShippingCostPerUnit,
    this.shippingCostType,
  });

  ShippingOptionEntity copyWith({
    String? shippingServiceCode,
    String? type,
    MoneyEntity? shippingCost,
    MoneyEntity? additionalShippingCostPerUnit,
    String? shippingCostType,
  }) {
    return ShippingOptionEntity(
      shippingServiceCode: shippingServiceCode ?? this.shippingServiceCode,
      type: type ?? this.type,
      shippingCost: shippingCost ?? this.shippingCost,
      additionalShippingCostPerUnit: additionalShippingCostPerUnit ?? this.additionalShippingCostPerUnit,
      shippingCostType: shippingCostType ?? this.shippingCostType,
    );
  }

  @override
  List<Object?> get props => [
        shippingServiceCode,
        type,
        shippingCost,
        additionalShippingCostPerUnit,
        shippingCostType,
      ];
}
