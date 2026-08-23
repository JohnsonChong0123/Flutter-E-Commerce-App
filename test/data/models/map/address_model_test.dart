import 'package:e_commerce_client/data/models/map/address_model.dart';
import 'package:e_commerce_client/domain/entity/address/address_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  group('AddressModel', () {
    const tPlaceId = 'place_123';
    const tFormattedAddress = '123 Main St, Kuala Lumpur, Malaysia';
    const tLatitude = 3.1390;
    const tLongitude = 101.6869;

    late AddressModel tAddressModel;

    setUp(() {
      tAddressModel = AddressModel(
        placeId: tPlaceId,
        formattedAddress: tFormattedAddress,
        latitude: tLatitude,
        longitude: tLongitude,
      );
    });

    test('should be a subclass of Equatable', () {
      expect(tAddressModel, isA<Equatable>());
    });

    test('props should return correct values', () {
      expect(tAddressModel.props, [tPlaceId, tFormattedAddress, tLatitude, tLongitude]);
    });

    group('fromPlacemarks', () {
      test('should create AddressModel from valid placemarks', () {
        // arrange
        final placemarks = [
          Placemark(
            name: 'Petronas Towers',
            subLocality: 'KLCC',
            thoroughfare: 'Jalan Ampang',
            locality: 'Kuala Lumpur',
            administrativeArea: 'Wilayah Persekutuan',
            country: 'Malaysia',
          ),
        ];

        // act
        final result = AddressModel.fromPlacemarks(
          latitude: tLatitude,
          longitude: tLongitude,
          placemarks: placemarks,
          fallbackPlaceId: tPlaceId,
        );

        // assert
        expect(result.latitude, tLatitude);
        expect(result.longitude, tLongitude);
        expect(result.placeId, tPlaceId);
        expect(result.formattedAddress, contains('Petronas Towers'));
        expect(result.formattedAddress, contains('KLCC'));
        expect(result.formattedAddress, contains('Jalan Ampang'));
        expect(result.formattedAddress, contains('Kuala Lumpur'));
        expect(result.formattedAddress, contains('Wilayah Persekutuan'));
        expect(result.formattedAddress, contains('Malaysia'));
      });

      test('should handle empty placemarks list', () {
        // arrange
        final placemarks = <Placemark>[];

        // act
        final result = AddressModel.fromPlacemarks(
          latitude: tLatitude,
          longitude: tLongitude,
          placemarks: placemarks,
          fallbackPlaceId: tPlaceId,
        );

        // assert
        expect(result.latitude, tLatitude);
        expect(result.longitude, tLongitude);
        expect(result.placeId, tPlaceId);
        expect(result.formattedAddress, 'Lat: 3.139000, Lng: 101.686900');
      });

      test('should handle placemarks with null/empty fields', () {
        // arrange
        final placemarks = [
          Placemark(
            name: '',
            subLocality: null,
            thoroughfare: 'Jalan Ampang',
            locality: 'Kuala Lumpur',
            administrativeArea: '',
            country: 'Malaysia',
          ),
        ];

        // act
        final result = AddressModel.fromPlacemarks(
          latitude: tLatitude,
          longitude: tLongitude,
          placemarks: placemarks,
          fallbackPlaceId: tPlaceId,
        );

        // assert
        expect(result.latitude, tLatitude);
        expect(result.longitude, tLongitude);
        expect(result.placeId, tPlaceId);
        expect(result.formattedAddress, contains('Jalan Ampang'));
        expect(result.formattedAddress, contains('Kuala Lumpur'));
        expect(result.formattedAddress, contains('Malaysia'));
        expect(result.formattedAddress, isNot(contains('Petronas Towers')));
      });

      test('should use fallbackPlaceId when provided', () {
        // arrange
        const customPlaceId = 'custom_place_456';
        final placemarks = [
          Placemark(
            name: 'Test Location',
            subLocality: 'Area',
            thoroughfare: 'Street',
            locality: 'City',
            administrativeArea: 'State',
            country: 'Country',
          ),
        ];

        // act
        final result = AddressModel.fromPlacemarks(
          latitude: tLatitude,
          longitude: tLongitude,
          placemarks: placemarks,
          fallbackPlaceId: customPlaceId,
        );

        // assert
        expect(result.placeId, customPlaceId);
      });

      test('should use default fallbackPlaceId when not provided', () {
        // arrange
        final placemarks = [
          Placemark(
            name: 'Test Location',
            subLocality: 'Area',
            thoroughfare: 'Street',
            locality: 'City',
            administrativeArea: 'State',
            country: 'Country',
          ),
        ];

        // act
        final result = AddressModel.fromPlacemarks(
          latitude: tLatitude,
          longitude: tLongitude,
          placemarks: placemarks,
        );

        // assert
        expect(result.placeId, 'unknown_place');
      });
    });

    group('toEntity', () {
      test('should convert AddressModel to AddressEntity correctly', () {
        // act
        final result = tAddressModel.toEntity();

        // assert
        expect(result, isA<AddressEntity>());
        expect(result.placeId, tPlaceId);
        expect(result.formattedAddress, tFormattedAddress);
        expect(result.latitude, tLatitude);
        expect(result.longitude, tLongitude);
      });
    });

    group('fromEntity', () {
      test('should create AddressModel from AddressEntity correctly', () {
        // arrange
        final entity = AddressEntity(
          placeId: tPlaceId,
          formattedAddress: tFormattedAddress,
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // act
        final result = AddressModel.fromEntity(entity);

        // assert
        expect(result.placeId, tPlaceId);
        expect(result.formattedAddress, tFormattedAddress);
        expect(result.latitude, tLatitude);
        expect(result.longitude, tLongitude);
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        // arrange
        final address1 = AddressModel(
          placeId: tPlaceId,
          formattedAddress: tFormattedAddress,
          latitude: tLatitude,
          longitude: tLongitude,
        );
        final address2 = AddressModel(
          placeId: tPlaceId,
          formattedAddress: tFormattedAddress,
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(address1, equals(address2));
      });

      test('should not be equal when placeId differs', () {
        // arrange
        final address1 = AddressModel(
          placeId: 'place_1',
          formattedAddress: tFormattedAddress,
          latitude: tLatitude,
          longitude: tLongitude,
        );
        final address2 = AddressModel(
          placeId: 'place_2',
          formattedAddress: tFormattedAddress,
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(address1, isNot(equals(address2)));
      });

      test('should not be equal when formattedAddress differs', () {
        // arrange
        final address1 = AddressModel(
          placeId: tPlaceId,
          formattedAddress: 'Address 1',
          latitude: tLatitude,
          longitude: tLongitude,
        );
        final address2 = AddressModel(
          placeId: tPlaceId,
          formattedAddress: 'Address 2',
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(address1, isNot(equals(address2)));
      });

      test('should not be equal when latitude differs', () {
        // arrange
        final address1 = AddressModel(
          placeId: tPlaceId,
          formattedAddress: tFormattedAddress,
          latitude: 1.0,
          longitude: tLongitude,
        );
        final address2 = AddressModel(
          placeId: tPlaceId,
          formattedAddress: tFormattedAddress,
          latitude: 2.0,
          longitude: tLongitude,
        );

        // assert
        expect(address1, isNot(equals(address2)));
      });

      test('should not be equal when longitude differs', () {
        // arrange
        final address1 = AddressModel(
          placeId: tPlaceId,
          formattedAddress: tFormattedAddress,
          latitude: tLatitude,
          longitude: 1.0,
        );
        final address2 = AddressModel(
          placeId: tPlaceId,
          formattedAddress: tFormattedAddress,
          latitude: tLatitude,
          longitude: 2.0,
        );

        // assert
        expect(address1, isNot(equals(address2)));
      });
    });
  });
}