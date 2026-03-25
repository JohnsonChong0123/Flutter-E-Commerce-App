import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/sources/remote/wishlist_remote_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../fixtures/product/product_fixtures.dart';
import '../../../fixtures/wishlist/wishlist_fixtures.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late WishlistRemoteDataImpl remoteData;
  late List tWishlistJsonMap;

  setUp(() {
    mockDio = MockDio();
    remoteData = WishlistRemoteDataImpl(dio: mockDio);
    tWishlistJsonMap = jsonDecode(fixture('wishlist/wishlist_list.json')) as List;
  });

  group('addWishlist', () {
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
          requestOptions: RequestOptions(path: '/wishlist/add'),
          statusCode: 200,
          data: {'product_id': tProductId},
        ),
      );

      // act
      final result = remoteData.addWishlist(tProductId);

      // assert
      expect(result, completes);

      verify(
        () => mockDio.post(
          '/wishlist/add',
          options: any(named: 'options'),
          data: {'product_id': tProductId},
        ),
      ).called(1);
    });

    test('should throw ServerException on DioException', () async {
      // arrange
      when(
        () => mockDio.post(
          any(),
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
      final result = remoteData.addWishlist(tProductId);

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = remoteData.addWishlist(tProductId);

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('getWishlist', () {
    test(
      'should return List<WishlistModel> when response code is 200',
      () async {
        // arrange
        when(
          () => mockDio.get(
            '/wishlist',
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/wishlist'),
            statusCode: 200,
            data: tWishlistJsonMap,
          ),
        );

        // act
        final result = await remoteData.getWishlist();

        // assert
        expect(result, equals(tWishlistModelList));
        verify(
          () => mockDio.get(
            '/wishlist',
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).called(1);
      },
    );

    test('should throw ServerException on DioException', () async {
      // arrange
      when(
        () => mockDio.get(
          '/wishlist',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/wishlist'),
          message: 'Timeout',
        ),
      );

      // act
      final result = remoteData.getWishlist();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.get(
          '/wishlist',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = remoteData.getWishlist();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('removeWishlist', () {
    test('should complete when response code is 200', () async {
      // arrange
      when(
        () => mockDio.delete(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/wishlist/remove/$tProductId'),
          statusCode: 200,
        ),
      );

      // act
      final result = remoteData.removeWishlist(tProductId);

      // assert
      expect(result, completes);

      verify(
        () => mockDio.delete(
          '/wishlist/remove/$tProductId',
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('should throw ServerException on DioException', () async {
      // arrange
      when(
        () => mockDio.post(
          any(),
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
      final result = remoteData.removeWishlist(tProductId);

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = remoteData.removeWishlist(tProductId);

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('clearWishlist', () {
    test('should complete when response code is 200', () async {
      // arrange
      when(
        () => mockDio.delete(
          '/wishlist/clear',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/wishlist/clear'),
          statusCode: 200,
        ),
      );

      // act
      final result = remoteData.clearWishlist();

      // assert
      expect(result, completes);

      verify(
        () => mockDio.delete(
          '/wishlist/clear',
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('should throw ServerException on DioException', () async {
      // arrange
      when(
        () => mockDio.delete(
          '/wishlist/clear',
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/wishlist/clear'),
          message: 'Timeout',
        ),
      );

      // act
      final result = remoteData.clearWishlist();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.delete(
          '/wishlist/clear',
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = remoteData.clearWishlist();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });
}
