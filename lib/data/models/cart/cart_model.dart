import 'package:equatable/equatable.dart';
import '../../../domain/entity/cart/cart_entity.dart';
import 'cart_item_model.dart';

class CartModel extends Equatable {
  final String id;
  final List<CartItemModel> items;
  final double cartTotal;
  const CartModel({
    required this.id,
    required this.items,
    required this.cartTotal,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];

    return CartModel(
      id: json['id']?.toString() ?? '',
      items: rawItems is List
          ? rawItems
                .whereType<Map>()
                .map(
                  (e) => CartItemModel.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList()
          : [],
      cartTotal: (json['cart_total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((model) => model.toJson()).toList(),
      'cart_total': cartTotal,
    };
  }

  CartEntity toEntity() {
    return CartEntity(
      id: id,
      items: items.map((model) => model.toEntity()).toList(),
      cartTotal: cartTotal,
    );
  }

  @override
  List<Object?> get props => [id, items, cartTotal];
}
