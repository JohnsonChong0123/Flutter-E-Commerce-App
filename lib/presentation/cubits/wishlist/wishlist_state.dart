part of 'wishlist_cubit.dart';

sealed class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

final class WishlistInitial extends WishlistState {
  const WishlistInitial();
}

final class WishlistLoading extends WishlistState {
  const WishlistLoading();
}

final class WishlistSuccess extends WishlistState {
  const WishlistSuccess();
}

final class WishlistFailure extends WishlistState {
  final String message;

  const WishlistFailure({required this.message});

  @override
  List<Object> get props => [message];
}

final class WishlistLoaded extends WishlistState {
  final List<WishlistEntity> wishlist;

  final Set<String> favoriteIds;

  WishlistLoaded({required this.wishlist})
    : favoriteIds = wishlist.map((e) => e.productId).toSet();

  @override
  List<Object> get props => [wishlist, favoriteIds];
}
