import 'package:e_commerce_client/domain/entity/wishlist/wishlist_entity.dart';
import 'package:equatable/equatable.dart';

class WishlistModel extends Equatable {
  final String id;
  final String name;
  final double finalPrice;
  final double initialPrice;
  final String imageUrl;

  const WishlistModel({
    required this.id,
    required this.name,
    required this.finalPrice,
    required this.initialPrice,
    required this.imageUrl,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['product_id'] ?? '',
      name: json['title'] ?? '',
      finalPrice: json['final_prices'] ?? 0.0,
      initialPrice: json['initial_prices'] ?? 0.0,
      imageUrl: json['image_url'] ?? '',
    );
  }

  WishlistEntity toEntity() {
    return WishlistEntity(
      productId: id,
      name: name,
      initialPrice: initialPrice,
      finalPrice: finalPrice,
      imageUrl: imageUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, initialPrice, finalPrice, imageUrl];
}
