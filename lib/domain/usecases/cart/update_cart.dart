import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/repositories/cart_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/usecase/usecase.dart';

class UpdateCart implements UseCase<Unit, UpdateCartParams> {
  final CartRepository repository;

  UpdateCart(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateCartParams params) {
    return repository.updateCart(
      productId: params.productId,
      quantity: params.quantity,
    );
  }
}

class UpdateCartParams extends Equatable {
  final String productId;
  final int quantity;

  const UpdateCartParams({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}
