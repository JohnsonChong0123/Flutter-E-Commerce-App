import 'dart:convert';

import 'package:e_commerce_client/data/models/product/product_details_model.dart';
import 'package:e_commerce_client/data/models/product/product_summary_model.dart';

class ProductCacheMapper {
  static Map<String, Object?> summaryToRow(
    ProductSummaryModel model, {
    required int cachedAt,
  }) {
    return {
      'id': model.id,
      'title': model.name,
      'initial_prices': model.initialPrice != null
          ? jsonEncode(model.initialPrice!.toJson())
          : null,
      'final_prices': model.finalPrice != null
          ? jsonEncode(model.finalPrice!.toJson())
          : null,
      'image_url': model.imageUrl,
      'cached_at': cachedAt,
    };
  }

  static Map<String, Object?> detailsToRow(
    ProductDetailsModel model, {
    required int cachedAt,
  }) {
    return {
      'id': model.id,
      'title': model.name,
      'description': model.description,
      'initial_prices': model.initialPrice != null
          ? jsonEncode(model.initialPrice!.toJson())
          : null,
      'final_prices': model.finalPrice != null
          ? jsonEncode(model.finalPrice!.toJson())
          : null,
      'image_url': model.imageUrl,
      'additional_images': jsonEncode(model.additionalImages),
      'localized_aspects': jsonEncode(
        model.localizedAspects.map((e) => e.toJson()).toList(),
      ),
      'shipping_options': jsonEncode(
        model.shippingOptions.map((e) => e.toJson()).toList(),
      ),
      'cached_at': cachedAt,
    };
  }
}
