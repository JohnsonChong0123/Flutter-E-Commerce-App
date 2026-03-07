import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/entity/product/product_details_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/usecase/usecase.dart';
import '../../repositories/product_repository.dart';

class GetProductById
    implements UseCase<ProductDetailsEntity, GetProductByIdParams> {
  final ProductRepository repository;

  GetProductById(this.repository);

  @override
  Future<Either<Failure, ProductDetailsEntity>> call(
    GetProductByIdParams params,
  ) async {
    return await repository.getProductById(params.productId);
  }
}

class GetProductByIdParams extends Equatable {
  final String productId;

  const GetProductByIdParams({required this.productId});

  @override
  List<Object> get props => [productId];
}
