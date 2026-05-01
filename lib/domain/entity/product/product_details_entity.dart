import 'package:equatable/equatable.dart';

import 'localized_aspect_entity.dart';

class ProductDetailsEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double finalPrice;
  final String currency;
  final String imageUrl;
  final List<String> additionalImages;
  final List<LocalizedAspectEntity> localizedAspects;

  const ProductDetailsEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.finalPrice,
    required this.currency,
    required this.imageUrl,
    required this.additionalImages,
    required this.localizedAspects,
  });

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
  ];
}
