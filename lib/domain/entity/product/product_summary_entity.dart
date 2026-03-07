import 'package:equatable/equatable.dart';

class ProductSummaryEntity extends Equatable {
  final String id;
  final String name;
  final double initialPrice;
  final double finalPrice;
  final String imageUrl;
  final int reviewCount;
  final double rating;

  const ProductSummaryEntity({
    required this.id,
    required this.name,
    required this.initialPrice,
    required this.finalPrice,
    required this.imageUrl,
    required this.reviewCount,
    required this.rating,
  });

  bool get hasDiscount => finalPrice < initialPrice;

  @override
  List<Object?> get props => [
    id,
    name,
    initialPrice,
    finalPrice,
    imageUrl,
    reviewCount,
    rating,
  ];
}
