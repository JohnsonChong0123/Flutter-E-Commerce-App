import 'dart:convert';

import 'package:e_commerce_client/data/models/product/product_summary_model.dart';
import 'package:e_commerce_client/data/models/money/money_model.dart';
import 'package:e_commerce_client/domain/entity/product/product_summary_entity.dart';
import 'package:equatable/equatable.dart';

class ProductSummaryCacheModel extends Equatable {
  final String id;
  final String title;
  final MoneyModel? initialPrices;
  final MoneyModel finalPrices;
  final String imageUrl;
  final int cachedAt;

  const ProductSummaryCacheModel({
    required this.id,
    required this.title,
    this.initialPrices,
    required this.finalPrices,
    required this.imageUrl,
    required this.cachedAt,
  });

  factory ProductSummaryCacheModel.fromSummaryModel(
    ProductSummaryModel model, {
    required int cachedAt,
  }) {
    return ProductSummaryCacheModel(
      id: model.id,
      title: model.name,
      initialPrices: model.initialPrice,
      finalPrices: model.finalPrice!,
      imageUrl: model.imageUrl,
      cachedAt: cachedAt,
    );
  }

  factory ProductSummaryCacheModel.fromRow(Map<String, Object?> row) {
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

    return ProductSummaryCacheModel(
      id: row['id'] as String,
      title: row['title'] as String,
      initialPrices: initialMoney,
      finalPrices: finalMoney,
      imageUrl: row['image_url'] as String,
      cachedAt: row['cached_at'] as int? ?? 0,
    );
  }

  Map<String, Object?> toRow() {
    return {
      'id': id,
      'title': title,

      'initial_prices': initialPrices != null
          ? jsonEncode(initialPrices!.toJson())
          : null,
      'final_prices': jsonEncode(finalPrices.toJson()),
      'image_url': imageUrl,
      'cached_at': cachedAt,
    };
  }

  ProductSummaryEntity toEntity() {
    return ProductSummaryEntity(
      id: id,
      name: title,
      initialPrice: initialPrices?.toEntity(),
      finalPrice: finalPrices.toEntity(),
      imageUrl: imageUrl,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    initialPrices,
    finalPrices,
    imageUrl,
    cachedAt,
  ];
}
