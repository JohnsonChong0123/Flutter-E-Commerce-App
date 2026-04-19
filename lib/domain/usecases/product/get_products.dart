import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/entity/product/product_summary_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/usecase/usecase.dart';
import '../../repositories/product_repository.dart';

class GetProducts implements UseCase<List<ProductSummaryEntity>, GetProductsParams> {
  final ProductRepository repository;

  GetProducts(this.repository);

  @override
  Future<Either<Failure, List<ProductSummaryEntity>>> call(GetProductsParams params) async {
    return await repository.getProducts(params);
  }
}

class GetProductsParams extends Equatable {
  final String? category;
  final int? limit;
  final int? page;

  const GetProductsParams({
    this.category,
    this.limit,
    this.page,
  });

  @override
  List<Object?> get props => [category, limit, page];
}
