import '/domain/entity/product/product_summary_entity.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/errors/failure.dart';
import '../entity/product/product_details_entity.dart';

abstract interface class ProductRepository {
  Future<Either<Failure, List<ProductSummaryEntity>>> getProducts();

  Future<Either<Failure, ProductDetailsEntity>> getProductById(
    String productId,
  );
}
