import 'package:equatable/equatable.dart';

import '../../../domain/entity/shipping/shipping_option_entity.dart';
import 'money_model.dart';

class ShippingOptionModel extends Equatable {
  final String shippingServiceCode;
  final String type;
  final MoneyModel? shippingCost;
  final MoneyModel? additionalShippingCostPerUnit;
  final String? shippingCostType;

  const ShippingOptionModel({
    required this.shippingServiceCode,
    required this.type,
    this.shippingCost,
    this.additionalShippingCostPerUnit,
    this.shippingCostType,
  });

  factory ShippingOptionModel.fromJson(Map<String, dynamic> json) {
    return ShippingOptionModel(
      shippingServiceCode: json['shippingServiceCode'] ?? '',
      type: json['type'] ?? '',
      shippingCost: json['shippingCost'] is Map ? MoneyModel.fromJson(json['shippingCost']) : null,
      additionalShippingCostPerUnit: json['additionalShippingCostPerUnit'] is Map ? MoneyModel.fromJson(json['additionalShippingCostPerUnit']) : null,
      shippingCostType: json['shippingCostType']?.toString(),
    );
  }

  ShippingOptionEntity toEntity() {
    return ShippingOptionEntity(
      shippingServiceCode: shippingServiceCode,
      type: type,
      shippingCost: shippingCost?.toEntity(),
      additionalShippingCostPerUnit: additionalShippingCostPerUnit?.toEntity(),
      shippingCostType: shippingCostType,
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