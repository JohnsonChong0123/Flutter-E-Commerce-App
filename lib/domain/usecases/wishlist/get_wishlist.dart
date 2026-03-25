import '/core/errors/failure.dart';
import '/domain/repositories/wishlist_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/usecase/usecase.dart';
import '../../entity/wishlist/wishlist_entity.dart';

class GetWishlist implements UseCase<List<WishlistEntity>, NoParams> {
  final WishlistRepository repository;

  GetWishlist(this.repository);

  @override
  Future<Either<Failure, List<WishlistEntity>>> call(NoParams params) {
    return repository.getWishlist();
  }
}
