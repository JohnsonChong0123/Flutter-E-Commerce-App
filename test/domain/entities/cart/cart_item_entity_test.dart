import 'package:e_commerce_client/domain/entity/cart/cart_item_entity.dart';
import 'package:e_commerce_client/domain/entity/shipping/money_entity.dart';
import 'package:e_commerce_client/domain/entity/shipping/shipping_option_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should return 0 when shipping options are empty', () {
    const item = CartItemEntity(
      productId: 'product-1',
      name: 'Item 1',
      price: 100,
      quantity: 2,
      imageUrl: 'https://example.com/item-1.png',
      shippingOptions: [],
    );

    final result = item.calculateShipping('express');

    expect(result, 0);
  });

  test('should calculate shipping using the selected service code', () {
    const item = CartItemEntity(
      productId: 'product-1',
      name: 'Item 1',
      price: 100,
      quantity: 3,
      imageUrl: 'https://example.com/item-1.png',
      shippingOptions: [
        ShippingOptionEntity(
          shippingServiceCode: 'express',
          type: 'Express',
          shippingCost: MoneyEntity(currency: 'USD', value: 10),
          additionalShippingCostPerUnit: MoneyEntity(currency: 'USD', value: 2),
        ),
        ShippingOptionEntity(
          shippingServiceCode: 'standard',
          type: 'Standard',
          shippingCost: MoneyEntity(currency: 'USD', value: 6),
          additionalShippingCostPerUnit: MoneyEntity(currency: 'USD', value: 1),
        ),
      ],
    );

    final result = item.calculateShipping('express');

    expect(result, 14);
  });

  test(
    'should fall back to the first shipping option when the code is null',
    () {
      const item = CartItemEntity(
        productId: 'product-1',
        name: 'Item 1',
        price: 100,
        quantity: 2,
        imageUrl: 'https://example.com/item-1.png',
        shippingOptions: [
          ShippingOptionEntity(
            shippingServiceCode: 'standard',
            type: 'Standard',
            shippingCost: MoneyEntity(currency: 'USD', value: 7),
            additionalShippingCostPerUnit: MoneyEntity(
              currency: 'USD',
              value: 3,
            ),
          ),
        ],
      );

      final result = item.calculateShipping(null);

      expect(result, 10);
    },
  );

  test('should use a minimum quantity of 1 when quantity is below 1', () {
    const item = CartItemEntity(
      productId: 'product-1',
      name: 'Item 1',
      price: 100,
      quantity: 0,
      imageUrl: 'https://example.com/item-1.png',
      shippingOptions: [
        ShippingOptionEntity(
          shippingServiceCode: 'standard',
          type: 'Standard',
          shippingCost: MoneyEntity(currency: 'USD', value: 8),
          additionalShippingCostPerUnit: MoneyEntity(currency: 'USD', value: 4),
        ),
      ],
    );

    final result = item.calculateShipping('standard');

    expect(result, 8);
  });
}
