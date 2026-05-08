import 'package:e_commerce_client/domain/entity/cart_entity.dart';
import 'package:e_commerce_client/domain/entity/cart_item_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tProductId = 'B09NQJFRW6';
  const tQuantity = 2;
  const tCartEntity = CartEntity(
    id: '1d3ed0a0-b460-4137-81b6-7e4befc3b63b',
    items: [
      CartItemEntity(
        productId: 'B09NQJFRW6',
        name: 'Saucony Men\'s Kinvara 13 Running Shoe',
        price: 57.79,
        quantity: 3,
        imageUrl:
            'https://m.media-amazon.com/images/I/71QeGmahUnL._AC_UX500_.jpg',
      ),
      CartItemEntity(
        productId: 'B0CY242B8P',
        name:
            '4th of July Door Sign Independence Day Wreath Patriotic Door Decoration Flower US Wooden Sign for Memorial Day Front for Door Decor 12 Inch Outdoor',
        price: 7.99,
        quantity: 3,
        imageUrl:
            'https://m.media-amazon.com/images/I/81BvLYGKcuL._AC_SL1500_.jpg',
      ),
    ],
    cartTotal: 197.34,
  );

  test('should update item quantity and recalculate total', () {
    // Act
    final result = tCartEntity.updateQuantityAndTotal(tProductId, tQuantity);

    final expectedTotal =
        (tCartEntity.items[0].price * tQuantity) +
        (tCartEntity.items[1].price * 3);

    // Assert
    expect(result.items[0].quantity, tQuantity);
    expect(result.cartTotal, expectedTotal);
  });
}
