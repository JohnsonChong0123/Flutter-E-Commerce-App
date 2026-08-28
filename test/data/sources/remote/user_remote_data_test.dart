import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/models/location_model.dart';
import 'package:e_commerce_client/data/sources/remote/user_remote_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late UserRemoteDataImpl userRemoteData;

  const tAddress = 'KL';
  const tLatitude = 3.14;
  const tLongitude = 101.69;

  setUpAll(() {
    dotenv.loadFromString(envString: 'SERVER_URL=https://example.com');
    registerFallbackValue(RequestOptions(path: '/test'));
  });

  setUp(() {
    mockDio = MockDio();
    userRemoteData = UserRemoteDataImpl(dio: mockDio);
  });

  group('updateUserAddress', () {
    test('should complete when response code is 200', () async {
      // arrange
      when(
        () => mockDio.put(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/user/me/address'),
          statusCode: 200,
          data: {},
        ),
      );

      // act
      final result = userRemoteData.updateUserAddress(
        address: tAddress,
        latitude: tLatitude,
        longitude: tLongitude,
      );

      // assert
      expect(result, completes);
      verify(
        () => mockDio.put(
          '/user/me/address',
          data: {
            'user_address': tAddress,
            'user_latitude': tLatitude,
            'user_longitude': tLongitude,
          },
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('should throw ServerException on DioException', () async {
      // arrange
      when(
        () => mockDio.put(
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
      final result = userRemoteData.updateUserAddress(
        address: tAddress,
        latitude: tLatitude,
        longitude: tLongitude,
      );

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.put(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = userRemoteData.updateUserAddress(
        address: tAddress,
        latitude: tLatitude,
        longitude: tLongitude,
      );

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('getUserLocation', () {
    test('should return LocationModel when response code is 200', () async {
      // arrange
      final tLocationJsonMap = jsonDecode(fixture('user/location.json'));
      final tLocationModel = LocationModel.fromJson(tLocationJsonMap);
      when(
        () => mockDio.get(
          any(),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: tLocationJsonMap,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/user/me/location'),
        ),
      );

      // act
      final result = await userRemoteData.getUserLocation();

      // assert
      expect(result, equals(tLocationModel));
      verify(
        () => mockDio.get(
          '/user/me/location',
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('should throw ServerException on DioException', () async {
      // arrange
      when(
        () => mockDio.get(
          any(),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          message: 'Timeout',
        ),
      );

      // act
      final result = userRemoteData.getUserLocation();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.get(
          any(),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = userRemoteData.getUserLocation();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });
}
