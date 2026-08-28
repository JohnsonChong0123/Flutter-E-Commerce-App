import 'package:e_commerce_client/data/models/location_model.dart';
import 'package:e_commerce_client/domain/entity/location_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/fixture_reader.dart';
import 'dart:convert';

void main() {
  group('LocationModel', () {
    const tLatitude = 3.14;
    const tLongitude = 101.69;
    const tAddress = 'KL';

    late LocationModel tLocationModel;

    setUp(() {
      tLocationModel = const LocationModel(
        latitude: tLatitude,
        longitude: tLongitude,
        address: tAddress,
      );
    });

    group('fromJson', () {
      test('should return a valid LocationModel from the fixture', () {
        // arrange
        final jsonMap = jsonDecode(fixture('user/location.json'))
            as Map<String, dynamic>;

        // act
        final result = LocationModel.fromJson(jsonMap);

        // assert
        expect(result, equals(tLocationModel));
      });

      test('should correctly deserialize all fields', () {
        // arrange
        final jsonMap = {
          'latitude': tLatitude,
          'longitude': tLongitude,
          'address': tAddress,
        };

        // act
        final result = LocationModel.fromJson(jsonMap);

        // assert
        expect(result.latitude, tLatitude);
        expect(result.longitude, tLongitude);
        expect(result.address, tAddress);
      });

      test('should default latitude/longitude to 0.0 when keys are missing',
          () {
        // arrange
        final jsonMap = {'address': tAddress};

        // act
        final result = LocationModel.fromJson(jsonMap);

        // assert
        expect(result.latitude, 0.0);
        expect(result.longitude, 0.0);
        expect(result.address, tAddress);
      });

      test('should default latitude/longitude to 0.0 when values are null', () {
        // arrange
        final jsonMap = {
          'latitude': null,
          'longitude': null,
          'address': tAddress,
        };

        // act
        final result = LocationModel.fromJson(jsonMap);

        // assert
        expect(result.latitude, 0.0);
        expect(result.longitude, 0.0);
        expect(result.address, tAddress);
      });

      test('should default address to empty string when key is missing', () {
        // arrange
        final jsonMap = {
          'latitude': tLatitude,
          'longitude': tLongitude,
        };

        // act
        final result = LocationModel.fromJson(jsonMap);

        // assert
        expect(result.address, '');
      });

      test('should default address to empty string when value is null', () {
        // arrange
        final jsonMap = {
          'latitude': tLatitude,
          'longitude': tLongitude,
          'address': null,
        };

        // act
        final result = LocationModel.fromJson(jsonMap);

        // assert
        expect(result.address, '');
      });

      test('should convert integer numeric values to double', () {
        // arrange
        final jsonMap = {
          'latitude': 3,
          'longitude': 101,
          'address': tAddress,
        };

        // act
        final result = LocationModel.fromJson(jsonMap);

        // assert
        expect(result.latitude, 3.0);
        expect(result.longitude, 101.0);
        expect(result.address, tAddress);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () {
        // act
        final result = tLocationModel.toJson();

        // assert
        final expectedMap = {
          'latitude': tLatitude,
          'longitude': tLongitude,
          'address': tAddress,
        };
        expect(result, equals(expectedMap));
      });

      test('should produce JSON that can be parsed back by fromJson', () {
        // act
        final jsonMap = tLocationModel.toJson();
        final result = LocationModel.fromJson(jsonMap);

        // assert
        expect(result, equals(tLocationModel));
      });
    });

    group('toEntity', () {
      test('should convert to a LocationEntity with the same values', () {
        // act
        final result = tLocationModel.toEntity();

        // assert
        expect(result, isA<LocationEntity>());
        expect(result.latitude, tLatitude);
        expect(result.longitude, tLongitude);
        expect(result.address, tAddress);
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        // arrange
        final other = const LocationModel(
          latitude: tLatitude,
          longitude: tLongitude,
          address: tAddress,
        );

        // assert
        expect(tLocationModel, equals(other));
      });

      test('should not be equal when latitude differs', () {
        // arrange
        final other = const LocationModel(
          latitude: 0.0,
          longitude: tLongitude,
          address: tAddress,
        );

        // assert
        expect(tLocationModel, isNot(equals(other)));
      });

      test('should not be equal when longitude differs', () {
        // arrange
        final other = const LocationModel(
          latitude: tLatitude,
          longitude: 0.0,
          address: tAddress,
        );

        // assert
        expect(tLocationModel, isNot(equals(other)));
      });

      test('should not be equal when address differs', () {
        // arrange
        final other = const LocationModel(
          latitude: tLatitude,
          longitude: tLongitude,
          address: 'Different',
        );

        // assert
        expect(tLocationModel, isNot(equals(other)));
      });
    });
  });
}
