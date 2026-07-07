import 'package:equatable/equatable.dart';

import 'localized_aspect_entity.dart';
import '../shipping/shipping_option_entity.dart';

class ProductDetailsEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double finalPrice;
  final String currency;
  final String imageUrl;
  final List<String> additionalImages;
  final List<LocalizedAspectEntity> localizedAspects;
  final List<ShippingOptionEntity> shippingOptions;

  const ProductDetailsEntity({
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

  ProductDetailsEntity copyWith({
    String? id,
    String? name,
    String? description,
    double? finalPrice,
    String? currency,
    String? imageUrl,
    List<String>? additionalImages,
    List<LocalizedAspectEntity>? localizedAspects,
    List<ShippingOptionEntity>? shippingOptions,
  }) {
    return ProductDetailsEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      finalPrice: finalPrice ?? this.finalPrice,
      currency: currency ?? this.currency,
      imageUrl: imageUrl ?? this.imageUrl,
      additionalImages: additionalImages ?? this.additionalImages,
      localizedAspects: localizedAspects ?? this.localizedAspects,
      shippingOptions: shippingOptions ?? this.shippingOptions,
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
    localizedAspects,
    shippingOptions,
  ];
}
