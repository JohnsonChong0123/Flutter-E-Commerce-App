import 'package:e_commerce_client/data/models/wishlist/wishlist_model.dart';
import 'package:e_commerce_client/data/sources/remote/wishlist_remote_data.dart';

import '../../../test/fixtures/wishlist/wishlist_fixtures.dart';

class MockWishlistRemoteData implements WishlistRemoteData {
  @override
  Future<void> addWishlist(String productId) async {}

  @override
  Future<void> clearWishlist() async {}

  @override
  Future<List<WishlistModel>> getWishlist() async => tWishlistModelList;

  @override
  Future<void> removeWishlist(String productId) async {}
}
