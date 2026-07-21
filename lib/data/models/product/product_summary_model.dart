import 'package:equatable/equatable.dart';

import '../../../domain/entity/product/product_summary_entity.dart';
import '../shipping/money_model.dart';

class ProductSummaryModel extends Equatable {
  final String id;
  final String name;
  final MoneyModel? initialPrice;
  final MoneyModel? finalPrice;
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
      initialPrice: json['original_price'] is Map ? MoneyModel.fromJson(json['original_price']) : null,
      finalPrice: json['price'] is Map ? MoneyModel.fromJson(json['price']) : null,
      imageUrl: json['image_url'] ?? '',
    );
  }

  ProductSummaryEntity toEntity() {
    return ProductSummaryEntity(
      id: id,
      name: name,
      initialPrice: initialPrice?.toEntity(),
      finalPrice: finalPrice?.toEntity(),
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
