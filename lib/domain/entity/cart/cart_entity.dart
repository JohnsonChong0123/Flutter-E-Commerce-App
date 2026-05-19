import 'package:equatable/equatable.dart';

import 'cart_item_entity.dart';

class CartEntity extends Equatable {
  final String id;
  final List<CartItemEntity> items;
  final double cartTotal;

  const CartEntity({
    required this.id,
    required this.items,
    required this.cartTotal,
  });

  CartEntity updateQuantityAndTotal(String productId, int newQuantity) {
    final updatedItems = items.map((item) {
      if (item.productId == productId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    final newTotal = updatedItems.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return copyWith(items: updatedItems, cartTotal: newTotal);
  }

  CartEntity copyWith({
    String? id,
    List<CartItemEntity>? items,
    double? cartTotal,
  }) {
    return CartEntity(
      id: id ?? this.id,
      items: items ?? this.items,
      cartTotal: cartTotal ?? this.cartTotal,
    );
  }

  @override
  List<Object?> get props => [id, items, cartTotal];
}
