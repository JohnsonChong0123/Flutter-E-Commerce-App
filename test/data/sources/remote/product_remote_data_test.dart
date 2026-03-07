import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/sources/remote/product_remote_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../fixtures/product/product_fixtures.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late ProductRemoteDataImpl productRemoteData;
  late List tProductSummaryJsonMap;
  late Map<String, dynamic> tProductDetailsJsonMap;
  
  setUpAll(() {
    dotenv.loadFromString(envString: 'SERVER_URL=https://example.com');
    registerFallbackValue(RequestOptions(path: '/test'));
  });

  setUp(() {
    mockDio = MockDio();
    productRemoteData = ProductRemoteDataImpl(dio: mockDio);
    tProductSummaryJsonMap = jsonDecode(fixture('product/product_list.json')) as List;
    tProductDetailsJsonMap = jsonDecode(fixture('product/product_details.json')) as Map<String, dynamic>;
  });

  group('getProducts', () {
    test(
      'should return List<ProductSummaryModel> when response code is 200',
      () async {
        // arrange
        when(
          () => mockDio.get(
            '/products',
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/products'),
            statusCode: 200,
            data: tProductSummaryJsonMap,
          ),
        );

        // act
        final result = await productRemoteData.getProducts();

        // assert
        expect(result, equals(tProductSummaryModelList));
        verify(
          () => mockDio.get(
            '/products',
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
          '/products',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/products'),
          message: 'Timeout',
        ),
      );

      // act
      final result = productRemoteData.getProducts();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.get(
          '/products',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = productRemoteData.getProducts();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('getProductById', () {
    test(
      'should return ProductDetailsModel when response code is 200',
      () async {
        // arrange
        when(
          () => mockDio.get(
            '/products/$tProductId',
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/products/$tProductId'),
            statusCode: 200,
            data: tProductDetailsJsonMap,
          ),
        );

        // act
        final result = await productRemoteData.getProductById(tProductId);

        // assert
        expect(result, equals(tProductDetailsModel));
        verify(
          () => mockDio.get(
            '/products/$tProductId',
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
          '/products/$tProductId',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/products/$tProductId'),
          message: 'Timeout',
        ),
      );

      // act
      final result = productRemoteData.getProductById(tProductId);

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.get(
          '/products/$tProductId',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = productRemoteData.getProductById(tProductId);

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });
}
