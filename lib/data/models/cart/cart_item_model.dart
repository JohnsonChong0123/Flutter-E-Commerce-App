import 'package:equatable/equatable.dart';

import '../../../domain/entity/cart/cart_item_entity.dart';
import '../shipping/shipping_option_model.dart';

class CartItemModel extends Equatable {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  final List<ShippingOptionModel> shippingOptions;

  const CartItemModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.shippingOptions,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final rawShippingOptions = json['shipping_options'];

    return CartItemModel(
      productId: json['product_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      imageUrl: json['image_url']?.toString() ?? '',
      shippingOptions: rawShippingOptions is List
          ? rawShippingOptions
                .whereType<Map>()
                .map(
                  (e) => ShippingOptionModel.fromJson(
                    Map<String, dynamic>.from(e),
                  ),
                )
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image_url': imageUrl,
      'shipping_options': shippingOptions.map((e) => e.toJson()).toList(),
    };
  }

  CartItemEntity toEntity() {
    return CartItemEntity(
      productId: productId,
      name: name,
      price: price,
      quantity: quantity,
      imageUrl: imageUrl,
      shippingOptions: shippingOptions.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [
    productId,
    name,
    price,
    quantity,
    imageUrl,
    shippingOptions,
  ];
}
