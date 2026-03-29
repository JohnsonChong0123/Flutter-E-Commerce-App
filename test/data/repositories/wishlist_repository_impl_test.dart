import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/data/repositories/wishlist_repository_impl.dart';
import 'package:e_commerce_client/data/sources/remote/wishlist_remote_data.dart';
import 'package:e_commerce_client/domain/entity/wishlist/wishlist_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/product/product_fixtures.dart';
import '../../fixtures/wishlist/wishlist_fixtures.dart';

class MockWishlistRemoteData extends Mock implements WishlistRemoteData {}

void main() {
  late MockWishlistRemoteData mockWishlistRemoteData;
  late WishlistRepositoryImpl repository;

  setUp(() {
    mockWishlistRemoteData = MockWishlistRemoteData();
    repository = WishlistRepositoryImpl(
      wishlistRemoteData: mockWishlistRemoteData,
    );
  });

  group('addWishlist', () {
    test(
      'should return Right(Unit) when adding wishlist is successful',
      () async {
        // arrange
        when(
          () => mockWishlistRemoteData.addWishlist(tProductId),
        ).thenAnswer((_) async => {});

        // act
        final result = await repository.addWishlist(tProductId);

        // assert
        expect(result, equals(right(unit)));
        verify(() => mockWishlistRemoteData.addWishlist(tProductId)).called(1);
        verifyNoMoreInteractions(mockWishlistRemoteData);
      },
    );

    test('should return Left(Failure) when adding wishlist fails', () async {
      // arrange
      when(
        () => mockWishlistRemoteData.addWishlist(tProductId),
      ).thenThrow(ServerException('Failed to add wishlist'));

      // act
      final result = await repository.addWishlist(tProductId);

      // assert
      expect(result, equals(left(const Failure('Failed to add wishlist'))));
      verify(() => mockWishlistRemoteData.addWishlist(tProductId)).called(1);
      verifyNoMoreInteractions(mockWishlistRemoteData);
    });
  });

  group('getWishlist', () {
    test(
      'should return Right(List<WishlistEntity>) when get wishlists succeeds',
      () async {
        // arrange
        when(
          () => mockWishlistRemoteData.getWishlist(),
        ).thenAnswer((_) async => tWishlistModelList);

        // act
        final result = await repository.getWishlist();

        // assert
        final either = result as Right<Failure, List<WishlistEntity>>;
        final wishlist = either.value;

        expect(wishlist.length, tWishlistEntityList.length);
        for (var i = 0; i < wishlist.length; i++) {
          expect(wishlist[i].productId, tWishlistEntityList[i].productId);
          expect(wishlist[i].name, tWishlistEntityList[i].name);

          expect(wishlist[i].finalPrice, tWishlistEntityList[i].finalPrice);
          expect(wishlist[i].imageUrl, tWishlistEntityList[i].imageUrl);
        }
        verify(() => mockWishlistRemoteData.getWishlist()).called(1);
        verifyNoMoreInteractions(mockWishlistRemoteData);
      },
    );

    test(
      'should return Left(Failure) when get wishlists throws ServerException',
      () async {
        // arrange
        when(
          () => mockWishlistRemoteData.getWishlist(),
        ).thenThrow(const ServerException('Failed to get products'));

        // act
        final result = await repository.getWishlist();

        // assert
        expect(result, equals(left(const Failure('Failed to get products'))));
        verify(() => mockWishlistRemoteData.getWishlist()).called(1);
      },
    );
  });

  group('removeWishlist', () {
    test(
      'should return Right(Unit) when removing wishlist is successful',
      () async {
        // arrange
        when(
          () => mockWishlistRemoteData.removeWishlist(tProductId),
        ).thenAnswer((_) async => {});

        // act
        final result = await repository.removeWishlist(tProductId);

        // assert
        expect(result, equals(right(unit)));
        verify(
          () => mockWishlistRemoteData.removeWishlist(tProductId),
        ).called(1);
        verifyNoMoreInteractions(mockWishlistRemoteData);
      },
    );

    test('should return Left(Failure) when removing wishlist fails', () async {
      // arrange
      when(
        () => mockWishlistRemoteData.removeWishlist(tProductId),
      ).thenThrow(ServerException('Failed to remove wishlist'));

      // act
      final result = await repository.removeWishlist(tProductId);

      // assert
      expect(result, equals(left(const Failure('Failed to remove wishlist'))));
      verify(() => mockWishlistRemoteData.removeWishlist(tProductId)).called(1);
      verifyNoMoreInteractions(mockWishlistRemoteData);
    });
  });

  group('clearWishlist', () {
    test(
      'should return Right(Unit) when clearing wishlist is successful',
      () async {
        // arrange
        when(
          () => mockWishlistRemoteData.clearWishlist(),
        ).thenAnswer((_) async => {});

        // act
        final result = await repository.clearWishlist();

        // assert
        expect(result, equals(right(unit)));
        verify(() => mockWishlistRemoteData.clearWishlist()).called(1);
        verifyNoMoreInteractions(mockWishlistRemoteData);
      },
    );

    test('should return Left(Failure) when clearing wishlist fails', () async {
      // arrange
      when(
        () => mockWishlistRemoteData.clearWishlist(),
      ).thenThrow(ServerException('Failed to clear wishlist'));

      // act
      final result = await repository.clearWishlist();

      // assert
      expect(result, equals(left(const Failure('Failed to clear wishlist'))));
      verify(() => mockWishlistRemoteData.clearWishlist()).called(1);
      verifyNoMoreInteractions(mockWishlistRemoteData);
    });
  });
}
