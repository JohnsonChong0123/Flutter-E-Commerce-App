import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/usecase/usecase.dart';
import '../../repositories/wishlist_repository.dart';

class AddWishlist implements UseCase<Unit, AddWishlistParam> {
  final WishlistRepository repository;

  const AddWishlist(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AddWishlistParam params) {
    return repository.addWishlist(
      params.productId,
    );
  }
}

class AddWishlistParam extends Equatable {
  final String productId;
  const AddWishlistParam(this.productId);
  
  @override
  List<Object?> get props => [productId];

}