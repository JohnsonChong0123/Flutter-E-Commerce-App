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
    return CartItemModel(
      productId: json['product_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      shippingOptions:
          (json['shipping_options'] as List<dynamic>?)
              ?.map((e) => ShippingOptionModel.fromJson(e))
              .toList() ??          
          [],
    );
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
  List<Object?> get props => [productId, name, price, quantity, imageUrl, shippingOptions];
}
