import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/data/repositories/cart_repository_impl.dart';
import 'package:e_commerce_client/data/sources/remote/cart_remote_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import '../../fixtures/cart/cart_fixtures.dart';
import '../../fixtures/product/product_fixtures.dart';

class MockCartRemoteData extends Mock implements CartRemoteData {}

void main() {
  late MockCartRemoteData mockCartRemoteData;
  late CartRepositoryImpl cartRepository;

  const tQuantity = 2;
  
  setUp(() {
    mockCartRemoteData = MockCartRemoteData();
    cartRepository = CartRepositoryImpl(cartRemoteData: mockCartRemoteData);
  });

  group('addToCart', () {
    test(
      'should return Right(Unit) when adding to cart is successful',
      () async {
        // arrange
        when(
          () => mockCartRemoteData.addToCart(
            productId: tProductId,
            quantity: tQuantity,
          ),
        ).thenAnswer((_) async => {});

        // act
        final result = await cartRepository.addToCart(
          productId: tProductId,
          quantity: tQuantity,
        );

        // assert
        expect(result, equals(right(unit)));
        verify(
          () => mockCartRemoteData.addToCart(
            productId: tProductId,
            quantity: tQuantity,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockCartRemoteData);
      },
    );

    test('should return Left(Failure) when adding to cart fails', () async {
      // arrange
      when(
        () => mockCartRemoteData.addToCart(
          productId: tProductId,
          quantity: tQuantity,
        ),
      ).thenThrow(ServerException('Failed to add to cart'));

      // act
      final result = await cartRepository.addToCart(
        productId: tProductId,
        quantity: tQuantity,
      );

      // assert
      expect(result, equals(left(const Failure('Failed to add to cart'))));
      verify(
        () => mockCartRemoteData.addToCart(
          productId: tProductId,
          quantity: tQuantity,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockCartRemoteData);
    });
  });

  group('getCart', () {
    test(
      'should return Right(List<CartEntity>) when getting cart is successful',
      () async {
        // arrange
        when(
          () => mockCartRemoteData.getCart(),
        ).thenAnswer((_) async => tCartModel);

        // act
        final result = await cartRepository.getCart();

        // assert
        expect(result, equals(right(tCartEntity)));
        verify(() => mockCartRemoteData.getCart()).called(1);
        verifyNoMoreInteractions(mockCartRemoteData);
      },
    );

    test('should return Left(Failure) when getting cart fails', () async {
      // arrange
      when(
        () => mockCartRemoteData.getCart(),
      ).thenThrow(ServerException('Failed to get cart'));

      // act
      final result = await cartRepository.getCart();

      // assert
      expect(result, equals(left(const Failure('Failed to get cart'))));
      verify(() => mockCartRemoteData.getCart()).called(1);
      verifyNoMoreInteractions(mockCartRemoteData);
    });
  });

  group('removeCartItem', () {
    test(
      'should return Right(Unit) when removing item is successful',
      () async {
        // arrange
        when(
          () => mockCartRemoteData.removeCartItem(tProductId),
        ).thenAnswer((_) async => {});

        // act
        final result = await cartRepository.removeCartItem(tProductId);

        // assert
        expect(result, equals(right(unit)));
        verify(() => mockCartRemoteData.removeCartItem(tProductId)).called(1);
        verifyNoMoreInteractions(mockCartRemoteData);
      },
    );

    test('should return Left(Failure) when removing item fails', () async {
      // arrange
      when(
        () => mockCartRemoteData.removeCartItem(tProductId),
      ).thenThrow(ServerException('Failed to remove item'));

      // act
      final result = await cartRepository.removeCartItem(tProductId);

      // assert
      expect(result, equals(left(const Failure('Failed to remove item'))));
      verify(() => mockCartRemoteData.removeCartItem(tProductId)).called(1);
      verifyNoMoreInteractions(mockCartRemoteData);
    });
  });

  group('clearCart', () {
    test(
      'should return Right(Unit) when clearing cart is successful',
      () async {
        // arrange
        when(() => mockCartRemoteData.clearCart()).thenAnswer((_) async => {});

        // act
        final result = await cartRepository.clearCart();

        // assert
        expect(result, equals(right(unit)));
        verify(() => mockCartRemoteData.clearCart()).called(1);
        verifyNoMoreInteractions(mockCartRemoteData);
      },
    );

    test('should return Left(Failure) when clearing cart fails', () async {
      // arrange
      when(
        () => mockCartRemoteData.clearCart(),
      ).thenThrow(ServerException('Failed to clear cart'));

      // act
      final result = await cartRepository.clearCart();

      // assert
      expect(result, equals(left(const Failure('Failed to clear cart'))));
      verify(() => mockCartRemoteData.clearCart()).called(1);
      verifyNoMoreInteractions(mockCartRemoteData);
    });
  });
}
