import 'package:e_commerce_client/data/models/product/shipping_option_model.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entity/product/product_details_entity.dart';
import 'localized_aspect_model.dart';

class ProductDetailsModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final double finalPrice;
  final String currency;
  final String imageUrl;
  final List<String> additionalImages;
  final List<LocalizedAspectModel> localizedAspects;
  final List<ShippingOptionModel> shippingOptions;

  const ProductDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.finalPrice,
    required this.currency,
    required this.imageUrl,
    required this.additionalImages,
    required this.localizedAspects,
    required this.shippingOptions,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    final price = json['price'] as Map<String, dynamic>?;
    return ProductDetailsModel(
      id: json['id'] ?? '',
      name: json['title'] ?? '',
      description: json['description'] ?? '',
      finalPrice: (price != null && price['value'] != null)
          ? (price['value'] as num).toDouble()
          : 0.0,
      currency: price?['currency'] ?? '',
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
      finalPrice: finalPrice,
      currency: currency,
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
    finalPrice,
    currency,
    imageUrl,
    additionalImages,
  ];
}
