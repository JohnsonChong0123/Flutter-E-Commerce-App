import 'package:equatable/equatable.dart';

class WishlistEntity extends Equatable {
  final String productId;
  final String name;
  final String imageUrl;
  final double finalPrice;
  final double initialPrice;

  const WishlistEntity({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.finalPrice,
    required this.initialPrice,
  });

  @override
  List<Object?> get props => [productId, name, finalPrice, initialPrice, imageUrl];
}
