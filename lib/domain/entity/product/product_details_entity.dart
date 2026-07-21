import 'package:equatable/equatable.dart';

import '../shipping/money_entity.dart';
import 'localized_aspect_entity.dart';
import '../shipping/shipping_option_entity.dart';

class ProductDetailsEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final MoneyEntity? initialPrice;
  final MoneyEntity? finalPrice;
  final String imageUrl;
  final List<String> additionalImages;
  final List<LocalizedAspectEntity> localizedAspects;
  final List<ShippingOptionEntity> shippingOptions;

  const ProductDetailsEntity({
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

  ProductDetailsEntity copyWith({
    String? id,
    String? name,
    String? description,
    MoneyEntity? initialPrice,
    MoneyEntity? finalPrice,
    String? imageUrl,
    List<String>? additionalImages,
    List<LocalizedAspectEntity>? localizedAspects,
    List<ShippingOptionEntity>? shippingOptions,
  }) {
    return ProductDetailsEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      initialPrice: initialPrice ?? this.initialPrice,
      finalPrice: finalPrice ?? this.finalPrice,
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
    initialPrice,
    finalPrice,
    imageUrl,
    additionalImages,
    localizedAspects,
    shippingOptions,
  ];
}
