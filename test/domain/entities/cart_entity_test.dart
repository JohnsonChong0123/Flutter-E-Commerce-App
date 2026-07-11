import 'package:flutter_test/flutter_test.dart';

import 'package:e_commerce_client/domain/entity/cart/cart_entity.dart';
import 'package:e_commerce_client/domain/entity/cart/cart_item_entity.dart';
import 'package:e_commerce_client/domain/entity/shipping/money_entity.dart';
import 'package:e_commerce_client/domain/entity/shipping/shipping_option_entity.dart';

import '../../fixtures/cart/cart_fixtures.dart';
import '../../fixtures/product/product_fixtures.dart';

void main() {
  const tQuantity = 2;

  test('should update item quantity and recalculate total', () {
    // Act
    final result = tCartEntity.updateQuantityAndTotal(tProductId, tQuantity);

    final expectedTotal =
        (tCartEntity.items[0].price * tQuantity) +
        (tCartEntity.items[1].price * tCartEntity.items[1].quantity);

    // Assert
    expect(result.items[0].quantity, tQuantity);
    expect(result.cartTotal, expectedTotal);
  });

  test('should calculate total shipping using selected service codes', () {
    const cart = CartEntity(
      id: 'cart-1',
      cartTotal: 0,
      items: [
        CartItemEntity(
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
              additionalShippingCostPerUnit: MoneyEntity(
                currency: 'USD',
                value: 2,
              ),
            ),
            ShippingOptionEntity(
              shippingServiceCode: 'standard',
              type: 'Standard',
              shippingCost: MoneyEntity(currency: 'USD', value: 6),
              additionalShippingCostPerUnit: MoneyEntity(
                currency: 'USD',
                value: 1,
              ),
            ),
          ],
        ),
        CartItemEntity(
          productId: 'product-2',
          name: 'Item 2',
          price: 50,
          quantity: 2,
          imageUrl: 'https://example.com/item-2.png',
          shippingOptions: [
            ShippingOptionEntity(
              shippingServiceCode: 'standard',
              type: 'Standard',
              shippingCost: MoneyEntity(currency: 'USD', value: 5),
              additionalShippingCostPerUnit: MoneyEntity(
                currency: 'USD',
                value: 1,
              ),
            ),
          ],
        ),
      ],
    );

    final result = cart.calculateTotalShipping({'product-1': 'express'});

    expect(result, 20);
  });

  test(
    'should fall back to the first shipping option when no code is selected',
    () {
      const cart = CartEntity(
        id: 'cart-2',
        cartTotal: 0,
        items: [
          CartItemEntity(
            productId: 'product-1',
            name: 'Item 1',
            price: 100,
            quantity: 1,
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
          ),
        ],
      );

      final result = cart.calculateTotalShipping({});

      expect(result, 7);
    },
  );
}
