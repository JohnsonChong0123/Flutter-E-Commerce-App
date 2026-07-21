import 'package:e_commerce_client/data/models/shipping/shipping_option_model.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entity/product/product_details_entity.dart';
import '../shipping/money_model.dart';
import 'localized_aspect_model.dart';

class ProductDetailsModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final MoneyModel? initialPrice;
  final MoneyModel? finalPrice;
  final String imageUrl;
  final List<String> additionalImages;
  final List<LocalizedAspectModel> localizedAspects;
  final List<ShippingOptionModel> shippingOptions;

  const ProductDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.initialPrice,
    required this.finalPrice,
    required this.imageUrl,
    required this.additionalImages,
    required this.localizedAspects,
    required this.shippingOptions,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['id'] ?? '',
      name: json['title'] ?? '',
      description: json['description'] ?? '',
      initialPrice: json['original_price'] is Map
          ? MoneyModel.fromJson(json['original_price'])
          : null,
      finalPrice: json['price'] is Map
          ? MoneyModel.fromJson(json['price'])
          : null,
      imageUrl: json['image_url'] ?? '',
      additionalImages:
          (json['additional_images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      localizedAspects:
          (json['localized_aspects'] as List<dynamic>?)
              ?.map((e) => LocalizedAspectModel.fromJson(e))
              .toList() ??
          [],
      shippingOptions:
          (json['shipping_options'] as List<dynamic>?)
              ?.map((e) => ShippingOptionModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  ProductDetailsEntity toEntity() {
    return ProductDetailsEntity(
      id: id,
      name: name,
      description: description,
      initialPrice: initialPrice?.toEntity(),
      finalPrice: finalPrice?.toEntity(),
      imageUrl: imageUrl,
      additionalImages: additionalImages,
      localizedAspects: localizedAspects.map((e) => e.toEntity()).toList(),
      shippingOptions: shippingOptions.map((e) => e.toEntity()).toList(),
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
    additionalImages,
    localizedAspects,
    shippingOptions,
  ];
}
