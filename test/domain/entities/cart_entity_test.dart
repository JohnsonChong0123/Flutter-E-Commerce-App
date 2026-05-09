import 'package:flutter_test/flutter_test.dart';

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
}
