import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/entity/product/product_summary_entity.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/usecase/usecase.dart';
import '../../repositories/product_repository.dart';

class GetProducts implements UseCase<List<ProductSummaryEntity>, NoParams> {
  final ProductRepository repository;

  GetProducts(this.repository);

  @override
  Future<Either<Failure, List<ProductSummaryEntity>>> call(NoParams params) async {
    return await repository.getProducts();
  }
}
