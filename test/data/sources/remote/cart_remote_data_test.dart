import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/models/cart/cart_model.dart';
import 'package:e_commerce_client/data/sources/remote/cart_remote_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../fixtures/product/product_fixtures.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late CartRemoteDataImpl cartRemoteData;
  late Map<String, dynamic> tJsonMap;
  late CartModel tCartModel;
  
  const tQuantity = 2;

  setUp(() {
    mockDio = MockDio();
    cartRemoteData = CartRemoteDataImpl(dio: mockDio);

    tJsonMap = jsonDecode(fixture('cart/cart.json'));
    tCartModel = CartModel.fromJson(tJsonMap);
  });

  group('addToCart', () {
    test('should complete when response code is 200', () async {
      // arrange
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/cart/add'),
          statusCode: 200,
          data: {},
        ),
      );

      // act
      final result = cartRemoteData.addToCart(
        productId: tProductId,
        quantity: tQuantity,
      );

      // assert
      expect(result, completes);

      verify(
        () => mockDio.post(
          '/cart/add',
          data: {'product_id': tProductId, 'quantity': tQuantity},
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('should throw ServerException on DioException', () async {
      // arrange
      when(
        () => mockDio.post(
          '/carts/add',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          message: 'Timeout',
        ),
      );

      // act
      final result = cartRemoteData.addToCart(
        productId: tProductId,
        quantity: tQuantity,
      );

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.post(
          '/carts/add',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = cartRemoteData.addToCart(
        productId: tProductId,
        quantity: tQuantity,
      );

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('getCart', () {
    test('should return CartModel when get cart success', () async {
      // arrange
      when(
        () => mockDio.get(
          '/cart',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: tJsonMap,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/cart'),
        ),
      );

      // act
      final result = await cartRemoteData.getCart();

      // assert
      expect(result, equals(tCartModel));
      verify(
        () => mockDio.get('/cart', options: any(named: 'options')),
      ).called(1);
    });

    test('should throw ServerException on DioException', () async {
      // arrange
      when(
        () => mockDio.get(
          '/carts',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          message: 'Timeout',
        ),
      );

      // act
      final result = cartRemoteData.getCart();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.get(
          '/carts',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = cartRemoteData.getCart();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('removeCartItem', () {
    test('should complete when remove cart item success', () async {
      // arrange
      when(
        () => mockDio.delete(
          '/cart/remove/$tProductId',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/cart/remove/$tProductId'),
          statusCode: 200,
          data: {},
        ),
      );

      // act
      final result = cartRemoteData.removeCartItem(tProductId);

      // assert
      expect(result, completes);

      verify(
        () => mockDio.delete(
          '/cart/remove/$tProductId',
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('should throw ServerException on DioException', () async {
      // arrange
      when(
        () => mockDio.delete(
          '/carts/remove/$tProductId',
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          message: 'Timeout',
        ),
      );

      // act
      final result = cartRemoteData.removeCartItem(tProductId);

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.delete(
          '/carts/remove/$tProductId',
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = cartRemoteData.removeCartItem(tProductId);

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('clearCart', () {
    test('should complete when clear cart success', () async {
      // arrange
      when(
        () => mockDio.delete(
          '/cart/clear',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/cart/clear'),
          statusCode: 200,
          data: {},
        ),
      );

      // act
      final result = cartRemoteData.clearCart();

      // assert
      expect(result, completes);

      verify(
        () => mockDio.delete(
          '/cart/clear',
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('should throw ServerException on DioException', () async {
      // arrange
      when(
        () => mockDio.delete(
          '/carts/clear',
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          message: 'Timeout',
        ),
      );

      // act
      final result = cartRemoteData.clearCart();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.delete(
          '/carts/clear',
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = cartRemoteData.clearCart();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });
}
