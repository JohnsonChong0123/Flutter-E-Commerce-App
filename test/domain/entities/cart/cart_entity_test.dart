import 'package:flutter_test/flutter_test.dart';

import 'package:e_commerce_client/domain/entity/cart/cart_entity.dart';
import 'package:e_commerce_client/domain/entity/cart/cart_item_entity.dart';
import 'package:e_commerce_client/domain/entity/shipping/money_entity.dart';
import 'package:e_commerce_client/domain/entity/shipping/shipping_option_entity.dart';

/// 1. When to Use Global Fixtures? (The Big Picture)
/// Summary: Use them when you want to test if the flow works, not what the data is.
/// Global fixtures are best for complex structures where the exact numbers do not matter.
///
/// Scenario 1: UI Tests
/// You just want to see if a page loads without crashing, if lists show up, and if buttons work.
/// It does not matter if a product costs $10 or $100.
/// Using a global fixture saves you from writing hundreds of lines of useless setup code.
///
/// Scenario 2: Navigation
/// You want to test if clicking a button takes you to the next page.
/// Any valid data object works here just to stop the app from crashing.
/// The actual content is just a pass to get through.
///
/// Scenario 3: State Management
/// You want to see if a red notification dot appears when the cart has items.
/// You do not need a custom cart; just pass in the global fixture data.
/// 💡 Benefit: They eliminate repetitive boilerplate code and keep your test files clean.
///
/// 2. When to Use Local Variables? (The Close-up View)
/// Summary: Use them when you are testing business logic, math formulas, or edge cases.
/// If changing a specific number changes the test result, that number belongs inside the test.
///
/// Scenario 1: Math and Calculations
/// In your formula:{Total Shipping} = {Base Cost} + {Additional Cost} * ({Quantity} - 1)
/// If you expect the result to be 22, the reader needs to see quantity: 3, base: 10, and additional: 2 right there.
/// Hiding these numbers in another file forces people to guess how the math works.
///
/// Scenario 2: Edge Cases (Boundaries)
/// If shipping is free for orders over $88, you need to test three exact numbers: $87.9, $88.0, and $88.1.
/// If you use a global fixture, your tests will break the moment someone changes that global data.
///
/// Scenario 3: Special Rules
/// If you are testing if international items trigger a special shipping rule,
/// you must manually set isInternational = true inside that specific test.
/// This makes the purpose of the test instantly clear.
/// 💡 Benefit: Self-containment. A good test explains itself.
/// The reader can see the exact cause and effect in just a few lines of code.

void main() {
  test('should update item quantity and recalculate total', () {
    const targetProductId = 'product-1';
    const tNewQuantity = 2;

    const tCart = CartEntity(
      id: 'cart-test-total',
      cartTotal: 200, // initial price (100*1 + 50*2)
      items: [
        CartItemEntity(
          productId: targetProductId,
          name: 'Item 1',
          price: 100,
          quantity: 1,
          imageUrl: 'https://example.com/item-1.png',
          shippingOptions: [],
        ),
        CartItemEntity(
          productId: 'product-2',
          name: 'Item 2',
          price: 50,
          quantity: 2,
          imageUrl: 'https://example.com/item-2.png',
          shippingOptions: [],
        ),
      ],
    );

    // 2. Act
    final result = tCart.updateQuantityAndTotal(targetProductId, tNewQuantity);

    final expectedTotal =
        (tCart.items[0].price * tNewQuantity) +
        (tCart.items[1].price * tCart.items[1].quantity); // 100*2 + 50*2 = 300

    // 4. Assert
    expect(result.items[0].quantity, tNewQuantity);
    expect(result.cartTotal, expectedTotal); // 300
  });

  test('should calculate total shipping using selected service codes', () {
    const tCart = CartEntity(
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

    final result = tCart.calculateTotalShipping({'product-1': 'express'});

    final expectedShippingCost =
        10 + // 10 is for product-1 express shipping
        (2 * 2) + // 2*(quantity - 1) is additional shipping for product-1 express shipping
        5 + // 5 is for product-2 standard shipping
        (1 * 1); // 1*(quantity - 1) is additional shipping for product-2 standard shipping

    expect(result, expectedShippingCost);
  });

  test('should calculate grand total from cart total and shipping', () {
    const tCart = CartEntity(
      id: 'cart-3',
      cartTotal: 250,
      items: [
        CartItemEntity(
          productId: 'product-1',
          name: 'Item 1',
          price: 100,
          quantity: 1,
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
          ],
        ),
      ],
    );

    final result = tCart.calculateGrandTotal({'product-1': 'express'});

    final expectedShippingCost = 10; // 10 is for product-1 express shipping
    final expectedGrandTotal = 250 + expectedShippingCost;

    expect(result, expectedGrandTotal);
  });

  test(
    'should calculate grand total using the first shipping option when no code is selected',
    () {
      const tCart = CartEntity(
        id: 'cart-4',
        cartTotal: 150,
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

      final result = tCart.calculateGrandTotal({});

      final expectedShippingCost = 7; // 7 is for product-1 standard shipping
      final expectedGrandTotal = 150 + expectedShippingCost;

      expect(result, expectedGrandTotal);
    },
  );

  test(
    'should fall back to the first shipping option when no code is selected',
    () {
      const tCart = CartEntity(
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

      final result = tCart.calculateTotalShipping({});

      expect(result, 7); // 7 is for product-1 standard shipping
    },
  );
}
