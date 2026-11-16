import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecase/usecase.dart';
import '../../../domain/entity/wishlist/wishlist_entity.dart';
import '../../../domain/usecases/wishlist/add_wishlist.dart';
import '../../../domain/usecases/wishlist/clear_wishlist.dart';
import '../../../domain/usecases/wishlist/get_wishlist.dart';
import '../../../domain/usecases/wishlist/remove_wishlist.dart';

part 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final AddWishlist _addWishlist;
  final GetWishlist _getWishlist;
  final RemoveWishlist _removeWishlist;
  final ClearWishlist _clearWishlist;

  WishlistCubit({
    required AddWishlist addWishlist,
    required GetWishlist getWishlist,
    required RemoveWishlist removeWishlist,
    required ClearWishlist clearWishlist,
  }) : _addWishlist = addWishlist,
       _getWishlist = getWishlist,
       _removeWishlist = removeWishlist,
       _clearWishlist = clearWishlist,
       super(WishlistInitial());

  Future<bool> addWishlist(String productId) async {
    final previousState = state;
    emit(WishlistLoading());
    final result = await _addWishlist(AddWishlistParam(productId));
    return result.fold(
      (failure) {
        emit(WishlistFailure(message: failure.message));
        return false;
      },
      (_) async {
        final wishlistResult = await _getWishlist(NoParams());
        return wishlistResult.fold(
          (failure) {
            if (previousState is WishlistLoaded) {
              emit(
                WishlistLoaded(
                  wishlist: previousState.wishlist,
                  favoriteIds: {...previousState.favoriteIds, productId},
                ),
              );
            }
            return true;
          },
          (wishlist) {
            emit(
              WishlistLoaded(wishlist: wishlist, message: 'Added to wishlist'),
            );
            return true;
          },
        );
      },
    );
  }

  Future<void> getWishlist() async {
    emit(WishlistLoading());
    final result = await _getWishlist(NoParams());
    result.fold(
      (failure) => emit(WishlistFailure(message: failure.message)),
      (wishlist) => emit(WishlistLoaded(wishlist: wishlist)),
    );
  }

  Future<bool> removeWishlist(String productId) async {
    final previousState = state;
    emit(WishlistLoading());
    final result = await _removeWishlist(RemoveWishlistParams(productId));
    return result.fold(
      (failure) {
        emit(WishlistFailure(message: failure.message));
        return false;
      },
      (_) async {
        final wishlistResult = await _getWishlist(NoParams());
        return wishlistResult.fold(
          (failure) {
            if (previousState is WishlistLoaded) {
              emit(
                WishlistLoaded(
                  wishlist: previousState.wishlist,
                  favoriteIds: {...previousState.favoriteIds}
                    ..remove(productId),
                ),
              );
            }
            return true;
          },
          (wishlist) {
            emit(
              WishlistLoaded(
                wishlist: wishlist,
                message: 'Removed from wishlist',
              ),
            );
            return true;
          },
        );
      },
    );
  }

  Future<void> clearWishlist() async {
    emit(WishlistLoading());
    final result = await _clearWishlist(NoParams());
    result.fold((failure) => emit(WishlistFailure(message: failure.message)), (
      _,
    ) async {
      final wishlistResult = await _getWishlist(NoParams());
      wishlistResult.fold(
        (failure) => emit(WishlistFailure(message: failure.message)),
        (wishlist) => emit(WishlistLoaded(wishlist: wishlist)),
      );
    });
  }
}
