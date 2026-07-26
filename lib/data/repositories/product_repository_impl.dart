import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/usecases/product/get_products.dart';
import '../sources/local/product_local_data.dart';
import '/domain/entity/product/product_details_entity.dart';
import '../../core/errors/exception.dart';
import '../../domain/entity/product/product_summary_entity.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/repositories/product_repository.dart';
import '../sources/remote/product_remote_data.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteData productRemoteData;
  final ProductLocalData productLocalData;

  ProductRepositoryImpl({
    required this.productRemoteData,
    required this.productLocalData,
  });

  @override
  Future<Either<Failure, List<ProductSummaryEntity>>> getProducts(
    GetProductsParams params,
  ) async {
    try {      
      final product = await productRemoteData.getProducts(params);

      await productLocalData.cacheProducts(product);

      return right(product.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      try {
        final cachedProducts = await productLocalData.getCachedProducts(
          limit: params.limit,
          page: params.page,
        );

        if (cachedProducts.isNotEmpty) {
          return right(
            cachedProducts.map((model) => model.toEntity()).toList(),
          );
        }

        return left(Failure(e.message));
      } on CacheException catch (cacheError) {
        return left(Failure(cacheError.message));
      }
    } on CacheException catch (cacheError) {
      return left(Failure('Local cache error: ${cacheError.message}'));
    } catch (unknownError) {
      return left(Failure('Unknown error occurred: ${unknownError.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ProductDetailsEntity>> getProductById(
    String productId,
  ) async {
    try {
      final product = await productRemoteData.getProductById(productId);

      await productLocalData.cacheProductDetails(product);
      
      return right(product.toEntity());
    } on ServerException catch (e) {
      try {
        final cachedProduct = await productLocalData.getCachedProductDetails(
          productId,
        );

        if (cachedProduct != null) {
          return right(cachedProduct.toEntity());
        }

        return left(Failure(e.message));
      } on CacheException catch (cacheError) {
        return left(Failure(cacheError.message));
      }
    } on CacheException catch (cacheError) {
      return left(Failure('Local cache error: ${cacheError.message}'));
    } catch (unknownError) {
      return left(Failure('Unknown error occurred: ${unknownError.toString()}'));
    }
  }
}
