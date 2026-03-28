import 'package:equatable/equatable.dart';

import '../../../domain/entity/product/product_summary_entity.dart';

class ProductSummaryModel extends Equatable {
  final String id;
  final String name;
  final double initialPrice;
  final double finalPrice;
  final String imageUrl;
  
  const ProductSummaryModel({
    required this.id,
    required this.name,
    required this.initialPrice,
    required this.finalPrice,
    required this.imageUrl,
  });

  factory ProductSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProductSummaryModel(
      id: json['id'] ?? '',
      name: json['title'] ?? '',
      initialPrice: json['original_price'] ?? 0.0,
      finalPrice: json['price'] ?? 0.0,
      imageUrl: json['image_url'] ?? '',
    );
  }

  ProductSummaryEntity toEntity() {
    return ProductSummaryEntity(
      id: id,
      name: name,
      initialPrice: initialPrice,
      finalPrice: finalPrice,
      imageUrl: imageUrl,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    initialPrice,
    finalPrice,
    imageUrl,
  ];
}
