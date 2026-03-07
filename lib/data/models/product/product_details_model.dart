import 'package:equatable/equatable.dart';

import '../../../domain/entity/product/product_details_entity.dart';

class ProductDetailsModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final double initialPrice;
  final double finalPrice;
  final String imageUrl;

  const ProductDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.initialPrice,
    required this.finalPrice,
    required this.imageUrl,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['id'] ?? '',
      name: json['title'] ?? '',
      description: json['description'] ?? '',
      initialPrice: json['initial_prices'] ?? 0.0,
      finalPrice: json['final_prices'] ?? 0.0,
      imageUrl: json['image_url'] ?? '',
    );
  }

  ProductDetailsEntity toEntity() {
    return ProductDetailsEntity(
      id: id,
      name: name,
      description: description,
      initialPrice: initialPrice,
      finalPrice: finalPrice,
      imageUrl: imageUrl,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    initialPrice,
    finalPrice,
    imageUrl,
  ];
}
