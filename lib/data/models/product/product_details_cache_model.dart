import 'dart:convert';

import 'package:e_commerce_client/data/models/product/product_details_model.dart';
import 'package:e_commerce_client/domain/entity/product/product_details_entity.dart';
import 'package:equatable/equatable.dart';

import '../shipping/money_model.dart';
import '../shipping/shipping_option_model.dart';
import 'localized_aspect_model.dart';

class ProductDetailsCacheModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final MoneyModel? initialPrices;
  final MoneyModel finalPrices;
  final String imageUrl;
  final List<String> additionalImages;
  final List<LocalizedAspectModel> localizedAspects;
  final List<ShippingOptionModel> shippingOptions;
  final int cachedAt;

  const ProductDetailsCacheModel({
    required this.id,
    required this.title,
    required this.description,
    this.initialPrices,
    required this.finalPrices,
    required this.imageUrl,
    required this.additionalImages,
    required this.localizedAspects,
    required this.shippingOptions,
    required this.cachedAt,
  });

  factory ProductDetailsCacheModel.fromDetailsModel(
    ProductDetailsModel model, {
    required int cachedAt,
  }) {
    return ProductDetailsCacheModel(
      id: model.id,
      title: model.name,
      description: model.description,
      initialPrices: model.initialPrice,
      finalPrices: model.finalPrice!,
      imageUrl: model.imageUrl,
      additionalImages: model.additionalImages,
      localizedAspects: model.localizedAspects,
      shippingOptions: model.shippingOptions,
      cachedAt: cachedAt,
    );
  }

  factory ProductDetailsCacheModel.fromRow(Map<String, Object?> row) {
    MoneyModel? initialMoney;
    final initialStr = row['initial_prices'] as String?;
    if (initialStr != null && initialStr.isNotEmpty) {
      initialMoney = MoneyModel.fromJson(
        jsonDecode(initialStr) as Map<String, dynamic>,
      );
    }

    final finalStr = row['final_prices'] as String;
    final finalMoney = MoneyModel.fromJson(
      jsonDecode(finalStr) as Map<String, dynamic>,
    );

    return ProductDetailsCacheModel(
      id: row['id'] as String,
      title: row['title'] as String,
      description: row['description'] as String,
      initialPrices: initialMoney,
      finalPrices: finalMoney,
      imageUrl: row['image_url'] as String,
      additionalImages: List<String>.from(
        jsonDecode(row['additional_images'] as String? ?? '[]'),
      ),
      localizedAspects:
          (jsonDecode(row['localized_aspects'] as String? ?? '[]') as List)
              .map(
                (e) => LocalizedAspectModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      shippingOptions:
          (jsonDecode(row['shipping_options'] as String? ?? '[]') as List)
              .map(
                (e) => ShippingOptionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      cachedAt: row['cached_at'] as int? ?? 0,
    );
  }

  Map<String, Object?> toRow() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'initial_prices': initialPrices,
      'final_prices': finalPrices,
      'image_url': imageUrl,
      'additional_images': jsonEncode(additionalImages),
      'localized_aspects': jsonEncode(
        localizedAspects.map((e) => e.toJson()).toList(),
      ),
      'shipping_options': jsonEncode(
        shippingOptions.map((e) => e.toJson()).toList(),
      ),
      'cached_at': cachedAt,
    };
  }

  ProductDetailsEntity toEntity() {
    return ProductDetailsEntity(
      id: id,
      name: title,
      description: description,
      initialPrice: initialPrices?.toEntity(),
      finalPrice: finalPrices.toEntity(),
      imageUrl: imageUrl,
      additionalImages: additionalImages,
      localizedAspects: localizedAspects.map((e) => e.toEntity()).toList(),
      shippingOptions: shippingOptions.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    initialPrices,
    finalPrices,
    imageUrl,
    additionalImages,
    localizedAspects,
    shippingOptions,
    cachedAt,
  ];
}
