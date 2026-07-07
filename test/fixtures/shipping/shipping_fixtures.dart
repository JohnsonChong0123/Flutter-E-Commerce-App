import 'package:e_commerce_client/data/models/shipping/money_model.dart';
import 'package:e_commerce_client/data/models/shipping/shipping_option_model.dart';
import 'package:e_commerce_client/domain/entity/shipping/money_entity.dart';
import 'package:e_commerce_client/domain/entity/shipping/shipping_option_entity.dart';

const tShippingOptionModelList = [
  ShippingOptionModel(
    shippingServiceCode: "Standard Shipping",
    type: "Standard Shipping",
    shippingCost: tMoneyModel,
    additionalShippingCostPerUnit: tMoneyModel,
    shippingCostType: "FIXED",
  ),
];

const tShippingOptionEntityList = [
  ShippingOptionEntity(
    shippingServiceCode: "Standard Shipping",
    type: "Standard Shipping",
    shippingCost: tMoneyEntity,
    additionalShippingCostPerUnit: tMoneyEntity,
    shippingCostType: "FIXED",
  ),
];

const tShippingOptionEntity = ShippingOptionEntity(
  shippingServiceCode: "Standard Shipping",
  type: "Standard Shipping",
  shippingCost: tMoneyEntity,
  additionalShippingCostPerUnit: tMoneyEntity,
  shippingCostType: "FIXED",
);

const tShippingOptionEntityNullValues = ShippingOptionEntity(
  shippingServiceCode: "Standard Shipping",
  type: "Standard Shipping",
  shippingCost: null,
  additionalShippingCostPerUnit: null,
  shippingCostType: null,
);

const tMoneyModel = MoneyModel(value: 0.00, currency: "USD");

const tMoneyEntity = MoneyEntity(value: 0.00, currency: "USD");