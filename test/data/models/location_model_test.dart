import 'package:e_commerce_client/data/models/location_model.dart';
import 'package:e_commerce_client/domain/entity/address/address_entity.dart';
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

    group('hasValidCoordinates', () {
      test('should return true when latitude and longitude are non-zero', () {
        // assert
        expect(tLocationModel.hasValidCoordinates, isTrue);
      });

      test('should return false when both latitude and longitude are 0.0', () {
        // arrange
        const model = LocationModel(
          latitude: 0.0,
          longitude: 0.0,
          address: tAddress,
        );

        // assert
        expect(model.hasValidCoordinates, isFalse);
      });

      test('should return true when only latitude is non-zero', () {
        // arrange
        const model = LocationModel(
          latitude: tLatitude,
          longitude: 0.0,
          address: tAddress,
        );

        // assert
        expect(model.hasValidCoordinates, isTrue);
      });

      test('should return true when only longitude is non-zero', () {
        // arrange
        const model = LocationModel(
          latitude: 0.0,
          longitude: tLongitude,
          address: tAddress,
        );

        // assert
        expect(model.hasValidCoordinates, isTrue);
      });

      test('should return false for default fromJson values (no coordinates)', () {
        // arrange
        final jsonMap = <String, dynamic>{};
        final model = LocationModel.fromJson(jsonMap);

        // assert
        expect(model.hasValidCoordinates, isFalse);
      });
    });

    group('toAddressEntity', () {
      test('should return an AddressEntity with the same coordinates', () {
        // act
        final result = tLocationModel.toAddressEntity();

        // assert
        expect(result, isA<AddressEntity>());
        expect(result.latitude, tLatitude);
        expect(result.longitude, tLongitude);
      });

      test('should use the provided address as formattedAddress when non-empty',
          () {
        // act
        final result = tLocationModel.toAddressEntity();

        // assert
        expect(result.formattedAddress, tAddress);
      });

      test('should default formattedAddress to "Saved Location" when address is empty',
          () {
        // arrange
        const model = LocationModel(
          latitude: tLatitude,
          longitude: tLongitude,
          address: '',
        );

        // act
        final result = model.toAddressEntity();

        // assert
        expect(result.formattedAddress, 'Saved Location');
      });

      test('should use default placeId "saved_location" when not provided', () {
        // act
        final result = tLocationModel.toAddressEntity();

        // assert
        expect(result.placeId, 'saved_location');
      });

      test('should use the provided placeId when given', () {
        // act
        final result = tLocationModel.toAddressEntity(placeId: 'custom_place');

        // assert
        expect(result.placeId, 'custom_place');
      });
    });

    group('fromJson edge cases', () {
      test('should handle a completely empty JSON map', () {
        // arrange
        final jsonMap = <String, dynamic>{};

        // act
        final result = LocationModel.fromJson(jsonMap);

        // assert
        expect(result.latitude, 0.0);
        expect(result.longitude, 0.0);
        expect(result.address, '');
      });

      test('should handle non-numeric latitude/longitude gracefully', () {
        // arrange
        final jsonMap = {
          'latitude': 'not_a_number',
          'longitude': true,
          'address': tAddress,
        };

        // act & assert – cast will fail, so this documents the behaviour
        expect(
          () => LocationModel.fromJson(jsonMap),
          throwsA(isA<TypeError>()),
        );
      });

      test('should handle double-typed latitude and longitude', () {
        // arrange
        final jsonMap = {
          'latitude': 3.14159,
          'longitude': 101.69000,
          'address': tAddress,
        };

        // act
        final result = LocationModel.fromJson(jsonMap);

        // assert
        expect(result.latitude, closeTo(3.14159, 0.00001));
        expect(result.longitude, closeTo(101.69, 0.00001));
      });
    });
  });
}
