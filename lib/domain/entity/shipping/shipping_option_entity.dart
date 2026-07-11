import 'package:equatable/equatable.dart';

import '../../../core/extensions/currency_extension.dart';
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

  String formatShippingPrice(int quantity) {
    final cost = shippingCost;
    final additional = additionalShippingCostPerUnit;
    final additionalCost = additional != null
        ? additional.value * (quantity - 1)
        : 0;

    if (cost == null && additional == null) {
      return 'N/A';
    }

    final base = cost != null
        ? cost.value.formatCurrency(cost.currency)
        : 'N/A';

    final extra = additional != null && quantity > 1
        ? additionalCost.formatCurrency(additional.currency)
        : '';

    return extra.isEmpty ? base : '$base + $extra';
  }

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
      additionalShippingCostPerUnit:
          additionalShippingCostPerUnit ?? this.additionalShippingCostPerUnit,
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
