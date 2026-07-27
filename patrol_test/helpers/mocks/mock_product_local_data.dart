import 'package:e_commerce_client/data/models/product/product_details_cache_model.dart';
import 'package:e_commerce_client/data/models/product/product_details_model.dart';
import 'package:e_commerce_client/data/models/product/product_summary_cache_model.dart';
import 'package:e_commerce_client/data/models/product/product_summary_model.dart';
import 'package:e_commerce_client/data/sources/local/product_local_data.dart';

class MockProductLocalData implements ProductLocalData {
  final List<ProductSummaryCacheModel> _cachedProducts = [];
  final List<ProductDetailsCacheModel> _cachedProductDetails = [];
  int _cachedAtSeed;

  MockProductLocalData({
    List<ProductSummaryCacheModel> cachedProducts = const [],
    List<ProductDetailsCacheModel> cachedProductDetails = const [],
    int cachedAtSeed = 0,
  }) : _cachedAtSeed = cachedAtSeed {
    _cachedProducts.addAll(cachedProducts);
    _cachedProductDetails.addAll(cachedProductDetails);
  }

  @override
  Future<void> cacheProductDetails(ProductDetailsModel product) async {
    final cachedProduct = ProductDetailsCacheModel.fromDetailsModel(
      product,
      cachedAt: ++_cachedAtSeed,
    );

    _cachedProductDetails.removeWhere((item) => item.id == cachedProduct.id);
    _cachedProductDetails.add(cachedProduct);
  }

  @override
  Future<void> cacheProducts(List<ProductSummaryModel> products) async {
    for (final product in products) {
      final cachedProduct = ProductSummaryCacheModel.fromSummaryModel(
        product,
        cachedAt: ++_cachedAtSeed,
      );

      _cachedProducts.removeWhere((item) => item.id == cachedProduct.id);
      _cachedProducts.add(cachedProduct);
    }
  }

  @override
  Future<void> clearCachedProductDetails() async {
    _cachedProductDetails.clear();
  }

  @override
  Future<void> clearCachedProducts() async {
    _cachedProducts.clear();
  }

  @override
  Future<ProductDetailsCacheModel?> getCachedProductDetails(
    String productId,
  ) async {
    final matchingProducts = _cachedProductDetails
        .where((item) => item.id == productId)
        .toList();

    if (matchingProducts.isEmpty) return null;

    matchingProducts.sort(
      (left, right) => right.cachedAt.compareTo(left.cachedAt),
    );
    return matchingProducts.first;
  }

  @override
  Future<List<ProductSummaryCacheModel>> getCachedProducts({
    int? limit,
    int? page,
  }) async {
    final sortedProducts = [..._cachedProducts]
      ..sort((left, right) => right.cachedAt.compareTo(left.cachedAt));

    final normalizedPage = page ?? 1;
    final startIndex = limit != null ? (normalizedPage - 1) * limit : 0;
    final endIndex = limit != null
        ? (startIndex + limit).clamp(0, sortedProducts.length)
        : sortedProducts.length;

    if (startIndex >= sortedProducts.length) return const [];
    return sortedProducts.sublist(startIndex, endIndex);
  }
}
