import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/usecase/usecase.dart';
import '../../repositories/wishlist_repository.dart';

class RemoveWishlist implements UseCase<Unit, RemoveWishlistParams> {
  final WishlistRepository repository;

  RemoveWishlist(this.repository);

  @override
  Future<Either<Failure, Unit>> call(RemoveWishlistParams params) {
    return repository.removeWishlist(params.productId);
  }
}

class RemoveWishlistParams extends Equatable {
  final String productId;

  const RemoveWishlistParams(this.productId);

  @override
  List<Object?> get props => [productId];
}
