import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/mappers/product_cache_mapper.dart';
import 'package:e_commerce_client/data/models/product/product_details_cache_model.dart';
import 'package:e_commerce_client/data/models/product/product_details_model.dart';
import 'package:e_commerce_client/data/models/product/product_summary_cache_model.dart';
import 'package:e_commerce_client/data/models/product/product_summary_model.dart';
import 'package:sqflite/sqflite.dart';

abstract interface class ProductLocalData {
  Future<void> cacheProducts(List<ProductSummaryModel> products);
  Future<List<ProductSummaryCacheModel>> getCachedProducts({
    int? limit,
    int? page,
  });

  Future<void> cacheProductDetails(ProductDetailsModel product);
  Future<ProductDetailsCacheModel?> getCachedProductDetails(String productId);

  Future<void> clearCachedProducts();
  Future<void> clearCachedProductDetails();
}

class ProductLocalDataImpl implements ProductLocalData {
  final Database database;

  ProductLocalDataImpl({required this.database});
  @override
  Future<void> cacheProducts(List<ProductSummaryModel> products) async {
    try {
      final batch = database.batch();
      final cachedAt = DateTime.now().millisecondsSinceEpoch;

      for (final product in products) {
        batch.insert(
          'product_summary',
          ProductCacheMapper.summaryToRow(product, cachedAt: cachedAt),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<ProductSummaryCacheModel>> getCachedProducts({
    int? limit,
    int? page,
  }) async {
    try {
      final rows = await database.query(
        'product_summary',
        orderBy: 'cached_at DESC',
        limit: limit,
        offset: page != null && limit != null ? (page - 1) * limit : null,
      );

      return rows.map((row) => ProductSummaryCacheModel.fromRow(row)).toList();
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> cacheProductDetails(ProductDetailsModel product) async {
    try {
      final cachedAt = DateTime.now().millisecondsSinceEpoch;

      await database.insert(
        'product_details',
        ProductCacheMapper.detailsToRow(product, cachedAt: cachedAt),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<ProductDetailsCacheModel?> getCachedProductDetails(
    String productId,
  ) async {
    try {
      final rows = await database.query(
        'product_details',
        where: 'id = ?',
        whereArgs: [productId],
        limit: 1,
      );

      if (rows.isEmpty) return null;
      return ProductDetailsCacheModel.fromRow(rows.first);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> clearCachedProducts() async {
    try {
      await database.delete('product_summary');
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> clearCachedProductDetails() async {
    try {
      await database.delete('product_details');
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
