import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/usecase/usecase.dart';
import '../../repositories/wishlist_repository.dart';

class ClearWishlist implements UseCase<Unit, NoParams> {
  final WishlistRepository repository;

  ClearWishlist(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.clearWishlist();
  }
}
