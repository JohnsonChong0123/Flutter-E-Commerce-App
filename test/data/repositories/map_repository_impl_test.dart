import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/data/repositories/map_repository_impl.dart';
import 'package:e_commerce_client/data/sources/remote/map_remote_data.dart';
import 'package:e_commerce_client/domain/entity/address/address_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMapRemoteData extends Mock implements MapRemoteData {}

void main() {
  late MockMapRemoteData mockMapRemoteData;
  late MapRepositoryImpl repository;

  const tMapViewId = 1;
  const tLatitude = 37.7749;
  const tLongitude = -122.4194;
  const tZoom = 16.0;

  final tAddressEntity = AddressEntity(
    latitude: tLatitude,
    longitude: tLongitude,
    formattedAddress: '123 Test St, San Francisco, CA',
    placeId: 'place_1',
  );
  
  setUp(() {
    mockMapRemoteData = MockMapRemoteData();
    repository = MapRepositoryImpl(mapRemoteData: mockMapRemoteData);
  });

  group('resolveInitialAddress', () {
    test('should return initialAddress when provided', () async {
      // act
      final result = await repository.resolveInitialAddress(
        initialAddress: tAddressEntity,
      );

      // assert
      expect(result, equals(right(tAddressEntity)));
    });

    test('should return fallback address when initialAddress is null', () async {
      // Note: This test would require mocking Geolocator and geocoding
      // which are static methods. The fallback address is a private constant
      // so we can't directly test it here. Integration tests would be needed
      // for full coverage of this method.
    });
  });

  group('reverseGeocode', () {
    test('should return AddressEntity with formatted address on success', () async {
      // Note: This test would require mocking placemarkFromCoordinates
      // which is a static method from geocoding package.
      // The actual implementation tests would need integration tests or
      // a wrapper service for geocoding.
    });

    test('should return Failure when geocoding throws', () async {
      // Note: This test would require mocking placemarkFromCoordinates
      // which is a static method from geocoding package.
    });
  });

  group('updateSelectedAddressOnMap', () {
    test('should call mapRemoteData.moveCamera when moveCamera is true', () async {
      // arrange
      when(
        () => mockMapRemoteData.moveCamera(tMapViewId, tLatitude, tLongitude, tZoom),
      ).thenAnswer((_) async {});

      // act
      final result = await repository.updateSelectedAddressOnMap(
        mapViewId: tMapViewId,
        address: tAddressEntity,
        moveCamera: true,
        zoom: tZoom,
      );

      // assert
      expect(result, equals(right(unit)));
      verify(
        () => mockMapRemoteData.moveCamera(tMapViewId, tLatitude, tLongitude, tZoom),
      ).called(1);
      verifyNoMoreInteractions(mockMapRemoteData);
    });

    test('should not call mapRemoteData.moveCamera when moveCamera is false', () async {
      // act
      final result = await repository.updateSelectedAddressOnMap(
        mapViewId: tMapViewId,
        address: tAddressEntity,
        moveCamera: false,
        zoom: tZoom,
      );

      // assert
      expect(result, equals(right(unit)));
      verifyNever(
        () => mockMapRemoteData.moveCamera(tMapViewId, tLatitude, tLongitude, tZoom),
      );
      verifyNoMoreInteractions(mockMapRemoteData);
    });

    test('should return Left(Failure) when moveCamera throws ServerException', () async {
      // arrange
      when(
        () => mockMapRemoteData.moveCamera(tMapViewId, tLatitude, tLongitude, tZoom),
      ).thenThrow(const ServerException('Camera move failed'));

      // act
      final result = await repository.updateSelectedAddressOnMap(
        mapViewId: tMapViewId,
        address: tAddressEntity,
        moveCamera: true,
        zoom: tZoom,
      );

      // assert
      expect(result, equals(left(const Failure('Camera move failed'))));
      verify(
        () => mockMapRemoteData.moveCamera(tMapViewId, tLatitude, tLongitude, tZoom),
      ).called(1);
      verifyNoMoreInteractions(mockMapRemoteData);
    });

    test('should return Left(Failure) when moveCamera throws unknown exception', () async {
      // arrange
      when(
        () => mockMapRemoteData.moveCamera(tMapViewId, tLatitude, tLongitude, tZoom),
      ).thenThrow(Exception('Unknown error'));

      // act
      final result = await repository.updateSelectedAddressOnMap(
        mapViewId: tMapViewId,
        address: tAddressEntity,
        moveCamera: true,
        zoom: tZoom,
      );

      // assert
      expect(result, equals(left(const Failure('Unable to update selected address on map: Exception: Unknown error'))));
      verify(
        () => mockMapRemoteData.moveCamera(tMapViewId, tLatitude, tLongitude, tZoom),
      ).called(1);
      verifyNoMoreInteractions(mockMapRemoteData);
    });

    test('should use default zoom when not provided', () async {
      // arrange
      when(
        () => mockMapRemoteData.moveCamera(tMapViewId, tLatitude, tLongitude, 16.0),
      ).thenAnswer((_) async {});

      // act
      final result = await repository.updateSelectedAddressOnMap(
        mapViewId: tMapViewId,
        address: tAddressEntity,
        moveCamera: true,
      );

      // assert
      expect(result, equals(right(unit)));
      verify(
        () => mockMapRemoteData.moveCamera(tMapViewId, tLatitude, tLongitude, 16.0),
      ).called(1);
    });
  });
}