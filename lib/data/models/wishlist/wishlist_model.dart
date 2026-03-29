import 'package:e_commerce_client/domain/entity/wishlist/wishlist_entity.dart';
import 'package:equatable/equatable.dart';

class WishlistModel extends Equatable {
  final String productId;
  final String name;
  final double finalPrice;
  final String imageUrl;

  const WishlistModel({
    required this.productId,
    required this.name,
    required this.finalPrice,
    required this.imageUrl,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      productId: json['product_id'] ?? '',
      name: json['name'] ?? '',
      finalPrice: json['price'] ?? 0.0,
      imageUrl: json['image_url'] ?? '',
    );
  }

  WishlistEntity toEntity() {
    return WishlistEntity(
      productId: productId,
      name: name,
      finalPrice: finalPrice,
      imageUrl: imageUrl,
    );
  }

  @override
  List<Object?> get props => [productId, name, finalPrice, imageUrl];
}
