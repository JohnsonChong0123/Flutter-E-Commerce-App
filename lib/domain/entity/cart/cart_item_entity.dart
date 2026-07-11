import 'package:equatable/equatable.dart';

import '../shipping/shipping_option_entity.dart';

class CartItemEntity extends Equatable {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  final List<ShippingOptionEntity> shippingOptions;

  double get totalPrice => price * quantity;

  const CartItemEntity({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.shippingOptions,
  });

  double calculateShipping(String? selectedServiceCode) {
    if (shippingOptions.isEmpty) return 0.0;

    final option = selectedServiceCode == null
        ? shippingOptions.first
        : shippingOptions.firstWhere(
            (o) => o.shippingServiceCode == selectedServiceCode,
            orElse: () => shippingOptions.first,
          );

    final cost = option.shippingCost?.value ?? 0.0;
    final additional = option.additionalShippingCostPerUnit?.value ?? 0.0;
    
    final effectiveQuantity = quantity < 1 ? 1 : quantity;
    final extraUnits = effectiveQuantity - 1;
    final extraValue = extraUnits > 0 ? (additional * extraUnits) : 0.0;
    
    return cost + extraValue;
  }

  CartItemEntity copyWith({
    String? productId,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
    List<ShippingOptionEntity>? shippingOptions,
  }) {
    return CartItemEntity(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      shippingOptions: shippingOptions ?? this.shippingOptions,
    );
  }

  @override
  List<Object?> get props => [productId, name, price, quantity, imageUrl, shippingOptions];
}
