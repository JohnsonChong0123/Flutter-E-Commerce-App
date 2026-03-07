import 'package:equatable/equatable.dart';

import '../../../domain/entity/product/product_summary_entity.dart';

class ProductSummaryModel extends Equatable {
  final String id;
  final String name;
  final double initialPrice;
  final double finalPrice;
  final String imageUrl;
  final int reviewCount;
  final double rating;
  
  const ProductSummaryModel({
    required this.id,
    required this.name,
    required this.initialPrice,
    required this.finalPrice,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  factory ProductSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProductSummaryModel(
      id: json['id'] ?? '',
      name: json['title'] ?? '',
      initialPrice: json['initial_prices'] ?? 0.0,
      finalPrice: json['final_prices'] ?? 0.0,
      imageUrl: json['image_url'] ?? '',
      rating: json['rating'] ?? 0,
      reviewCount: json['reviews_count'] ?? 0,
    );
  }

  ProductSummaryEntity toEntity() {
    return ProductSummaryEntity(
      id: id,
      name: name,
      initialPrice: initialPrice,
      finalPrice: finalPrice,
      imageUrl: imageUrl,
      rating: rating,
      reviewCount: reviewCount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    initialPrice,
    finalPrice,
    imageUrl,
    rating,
    reviewCount,
  ];
}
