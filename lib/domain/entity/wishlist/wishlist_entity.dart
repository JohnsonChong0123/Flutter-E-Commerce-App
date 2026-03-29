import 'package:equatable/equatable.dart';

class WishlistEntity extends Equatable {
  final String productId;
  final String name;
  final String imageUrl;
  final double finalPrice;

  const WishlistEntity({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.finalPrice,
  });

  @override
  List<Object?> get props => [productId, name, finalPrice, imageUrl];
}
