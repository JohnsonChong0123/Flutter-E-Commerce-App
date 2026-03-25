import 'package:e_commerce_client/data/models/wishlist/wishlist_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../fixtures/fixture_reader.dart';
import 'dart:convert';

import '../../../fixtures/wishlist/wishlist_fixtures.dart';

void main() {
  late Map<String, dynamic> tJsonMap;

  setUp(() {
    tJsonMap = jsonDecode(fixture('wishlist/wishlist.json'));
  });

  test('fromJson should return valid WishlistModel', () {
    // act
    final result = WishlistModel.fromJson(tJsonMap);

    // assert
    expect(result, equals(tWishlistModel));
  });

  test('WishlistModel.toEntity should convert correctly', () {
    // act
    final tWishlistModelToEntity = tWishlistModel.toEntity();

    // assert
    expect(tWishlistModelToEntity, equals(tWishlistEntity));
  });
}
