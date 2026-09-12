import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/data/models/location_model.dart';
import 'package:e_commerce_client/data/repositories/map_repository_impl.dart';
import 'package:e_commerce_client/data/sources/remote/geocoding_remote_data.dart';
import 'package:e_commerce_client/data/sources/remote/map_remote_data.dart';
import 'package:e_commerce_client/data/sources/remote/user_remote_data.dart';
import 'package:e_commerce_client/domain/entity/address/address_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';

class MockMapRemoteData extends Mock implements MapRemoteData {}

class MockGeocodingRemoteData extends Mock implements GeocodingRemoteData {}

class MockUserRemoteData extends Mock implements UserRemoteData {}

void main() {
  late MockMapRemoteData mockMapRemoteData;
  late MockGeocodingRemoteData mockGeocodingRemoteData;
  late MockUserRemoteData mockUserRemoteData;
  late MapRepositoryImpl repository;

  const tMapViewId = 1;
  const tLatitude = 37.7749;
  const tLongitude = -122.4194;
  const tZoom = 16.0;

  final tPosition = Position(
    latitude: tLatitude,
    longitude: tLongitude,
    timestamp: DateTime(2024, 1, 1),
    accuracy: 10.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    altitudeAccuracy: 0.0,
    headingAccuracy: 0.0,
  );

  final tPlacemarks = [
    const Placemark(
      name: '123 Test St',
      street: '123 Test St',
      subLocality: 'Test Neighborhood',
      locality: 'San Francisco',
      administrativeArea: 'CA',
      country: 'USA',
      postalCode: '94102',
      isoCountryCode: 'US',
    ),
  ];

  final tAddressEntity = AddressEntity(
    latitude: tLatitude,
    longitude: tLongitude,
    formattedAddress: '123 Test St, San Francisco, CA',
    placeId: 'place_1',
  );

  final tSavedLocationModel = const LocationModel(
    latitude: 3.1390,
    longitude: 101.6869,
    address: 'Kuala Lumpur, Malaysia',
  );

  final tSavedLocationEntity = AddressEntity(
    latitude: 3.1390,
    longitude: 101.6869,
    formattedAddress: 'Kuala Lumpur, Malaysia',
    placeId: 'saved_location',
  );

  setUp(() {
    mockMapRemoteData = MockMapRemoteData();
    mockGeocodingRemoteData = MockGeocodingRemoteData();
    mockUserRemoteData = MockUserRemoteData();
    repository = MapRepositoryImpl(
      mapRemoteData: mockMapRemoteData,
      geocodingRemoteData: mockGeocodingRemoteData,
      userRemoteData: mockUserRemoteData,
    );
  });

  // ---------------------------------------------------------------------------
  // resolveInitialAddress
  // ---------------------------------------------------------------------------
  group('resolveInitialAddress', () {
    test(
      'should return AddressEntity from current position when permission is granted',
      () async {
        // arrange
        when(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);
        when(() => mockGeocodingRemoteData.getCurrentPosition())
            .thenAnswer((_) async => tPosition);
        when(
          () => mockGeocodingRemoteData.getPlacemarksFromCoordinates(
            tLatitude,
            tLongitude,
          ),
        ).thenAnswer((_) async => tPlacemarks);

        // act
        final result = await repository.resolveInitialAddress();

        // assert
        expect(result, isA<Right<Failure, AddressEntity>>());
        final address = (result as Right<Failure, AddressEntity>).value;
        expect(address.latitude, tLatitude);
        expect(address.longitude, tLongitude);
        expect(address.formattedAddress, contains('123 Test St'));
        expect(address.placeId, 'current_location');
        verify(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .called(1);
        verify(() => mockGeocodingRemoteData.getCurrentPosition()).called(1);
        verify(
          () => mockGeocodingRemoteData.getPlacemarksFromCoordinates(
            tLatitude,
            tLongitude,
          ),
        ).called(1);
        verifyNever(() => mockUserRemoteData.getUserLocation());
      },
    );

    test(
      'should return AddressEntity when permission is whileInUse',
      () async {
        // arrange
        when(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);
        when(() => mockGeocodingRemoteData.getCurrentPosition())
            .thenAnswer((_) async => tPosition);
        when(
          () => mockGeocodingRemoteData.getPlacemarksFromCoordinates(
            tLatitude,
            tLongitude,
          ),
        ).thenAnswer((_) async => tPlacemarks);

        // act
        final result = await repository.resolveInitialAddress();

        // assert
        expect(result, isA<Right<Failure, AddressEntity>>());
        verify(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .called(1);
        verify(() => mockGeocodingRemoteData.getCurrentPosition()).called(1);
      },
    );

    test(
      'should return saved location when permission is denied and saved location has valid coordinates',
      () async {
        // arrange
        when(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .thenAnswer((_) async => LocationPermission.denied);
        when(() => mockUserRemoteData.getUserLocation())
            .thenAnswer((_) async => tSavedLocationModel);

        // act
        final result = await repository.resolveInitialAddress();

        // assert
        expect(result, equals(right(tSavedLocationEntity)));
        verify(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .called(1);
        verify(() => mockUserRemoteData.getUserLocation()).called(1);
        verifyNever(() => mockGeocodingRemoteData.getCurrentPosition());
      },
    );

    test(
      'should return fallback address when permission is denied and saved location fails',
      () async {
        // arrange
        when(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .thenAnswer((_) async => LocationPermission.denied);
        when(() => mockUserRemoteData.getUserLocation())
            .thenThrow(Exception('Network error'));

        // act
        final result = await repository.resolveInitialAddress();

        // assert
        expect(result, isA<Right<Failure, AddressEntity>>());
        final address = (result as Right<Failure, AddressEntity>).value;
        expect(address.latitude, 3.1579);
        expect(address.longitude, 101.7115);
        expect(
          address.formattedAddress,
          'Kuala Lumpur City Centre, Malaysia',
        );
        expect(address.placeId, 'fallback_klcc');
        verify(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .called(1);
        verify(() => mockUserRemoteData.getUserLocation()).called(1);
      },
    );

    test(
      'should return fallback address when permission is denied and saved location has invalid coordinates',
      () async {
        // arrange
        final invalidLocation = const LocationModel(
          latitude: 0.0,
          longitude: 0.0,
          address: '',
        );
        when(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .thenAnswer((_) async => LocationPermission.denied);
        when(() => mockUserRemoteData.getUserLocation())
            .thenAnswer((_) async => invalidLocation);

        // act
        final result = await repository.resolveInitialAddress();

        // assert
        expect(result, isA<Right<Failure, AddressEntity>>());
        final address = (result as Right<Failure, AddressEntity>).value;
        expect(address.latitude, 3.1579);
        expect(address.longitude, 101.7115);
        expect(
          address.formattedAddress,
          'Kuala Lumpur City Centre, Malaysia',
        );
        expect(address.placeId, 'fallback_klcc');
        verify(() => mockUserRemoteData.getUserLocation()).called(1);
      },
    );

    test(
      'should return saved location when permission is deniedForever and saved location has valid coordinates',
      () async {
        // arrange
        when(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .thenAnswer((_) async => LocationPermission.deniedForever);
        when(() => mockUserRemoteData.getUserLocation())
            .thenAnswer((_) async => tSavedLocationModel);

        // act
        final result = await repository.resolveInitialAddress();

        // assert
        expect(result, equals(right(tSavedLocationEntity)));
        verify(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .called(1);
        verify(() => mockUserRemoteData.getUserLocation()).called(1);
      },
    );

    test(
      'should return fallback address when permission is deniedForever and saved location fails',
      () async {
        // arrange
        when(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .thenAnswer((_) async => LocationPermission.deniedForever);
        when(() => mockUserRemoteData.getUserLocation())
            .thenThrow(Exception('Network error'));

        // act
        final result = await repository.resolveInitialAddress();

        // assert
        expect(result, isA<Right<Failure, AddressEntity>>());
        final address = (result as Right<Failure, AddressEntity>).value;
        expect(address.placeId, 'fallback_klcc');
      },
    );

    test(
      'should return saved location when geolocation throws and saved location has valid coordinates',
      () async {
        // arrange
        when(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);
        when(() => mockGeocodingRemoteData.getCurrentPosition())
            .thenThrow(Exception('GPS unavailable'));
        when(() => mockUserRemoteData.getUserLocation())
            .thenAnswer((_) async => tSavedLocationModel);

        // act
        final result = await repository.resolveInitialAddress();

        // assert
        expect(result, equals(right(tSavedLocationEntity)));
        verify(() => mockGeocodingRemoteData.getCurrentPosition()).called(1);
        verify(() => mockUserRemoteData.getUserLocation()).called(1);
      },
    );

    test(
      'should return fallback address when geolocation throws and saved location fails',
      () async {
        // arrange
        when(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);
        when(() => mockGeocodingRemoteData.getCurrentPosition())
            .thenThrow(Exception('GPS unavailable'));
        when(() => mockUserRemoteData.getUserLocation())
            .thenThrow(Exception('Network error'));

        // act
        final result = await repository.resolveInitialAddress();

        // assert
        expect(result, isA<Right<Failure, AddressEntity>>());
        final address = (result as Right<Failure, AddressEntity>).value;
        expect(address.placeId, 'fallback_klcc');
        expect(
          address.formattedAddress,
          'Kuala Lumpur City Centre, Malaysia',
        );
      },
    );

    test(
      'should return fallback address when geolocation throws and saved location has invalid coordinates',
      () async {
        // arrange
        final invalidLocation = const LocationModel(
          latitude: 0.0,
          longitude: 0.0,
          address: '',
        );
        when(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);
        when(() => mockGeocodingRemoteData.getCurrentPosition())
            .thenThrow(Exception('GPS unavailable'));
        when(() => mockUserRemoteData.getUserLocation())
            .thenAnswer((_) async => invalidLocation);

        // act
        final result = await repository.resolveInitialAddress();

        // assert
        expect(result, isA<Right<Failure, AddressEntity>>());
        final address = (result as Right<Failure, AddressEntity>).value;
        expect(address.placeId, 'fallback_klcc');
      },
    );

    test(
      'should return AddressEntity with empty placemarks fallback address',
      () async {
        // arrange
        when(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);
        when(() => mockGeocodingRemoteData.getCurrentPosition())
            .thenAnswer((_) async => tPosition);
        when(
          () => mockGeocodingRemoteData.getPlacemarksFromCoordinates(
            tLatitude,
            tLongitude,
          ),
        ).thenAnswer((_) async => <Placemark>[]);

        // act
        final result = await repository.resolveInitialAddress();

        // assert
        expect(result, isA<Right<Failure, AddressEntity>>());
        final address = (result as Right<Failure, AddressEntity>).value;
        expect(address.latitude, tLatitude);
        expect(address.longitude, tLongitude);
        expect(
          address.formattedAddress,
          'Lat: ${tLatitude.toStringAsFixed(6)}, Lng: ${tLongitude.toStringAsFixed(6)}',
        );
        expect(address.placeId, 'current_location');
      },
    );
  });

  // ---------------------------------------------------------------------------
  // reverseGeocode
  // ---------------------------------------------------------------------------
  group('reverseGeocode', () {
    test(
      'should return AddressEntity with formatted address on success',
      () async {
        // arrange
        when(
          () => mockGeocodingRemoteData.getPlacemarksFromCoordinates(
            tLatitude,
            tLongitude,
          ),
        ).thenAnswer((_) async => tPlacemarks);

        // act
        final result = await repository.reverseGeocode(
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(result, isA<Right<Failure, AddressEntity>>());
        final address = (result as Right<Failure, AddressEntity>).value;
        expect(address.latitude, tLatitude);
        expect(address.longitude, tLongitude);
        expect(address.formattedAddress, contains('123 Test St'));
        expect(address.formattedAddress, contains('San Francisco'));
        expect(address.formattedAddress, contains('CA'));
        expect(address.formattedAddress, contains('USA'));
        expect(address.placeId, 'unknown_place');
        verify(
          () => mockGeocodingRemoteData.getPlacemarksFromCoordinates(
            tLatitude,
            tLongitude,
          ),
        ).called(1);
      },
    );

    test(
      'should use custom fallbackPlaceId when provided',
      () async {
        // arrange
        when(
          () => mockGeocodingRemoteData.getPlacemarksFromCoordinates(
            tLatitude,
            tLongitude,
          ),
        ).thenAnswer((_) async => tPlacemarks);

        // act
        final result = await repository.reverseGeocode(
          latitude: tLatitude,
          longitude: tLongitude,
          fallbackPlaceId: 'custom_place',
        );

        // assert
        expect(result, isA<Right<Failure, AddressEntity>>());
        final address = (result as Right<Failure, AddressEntity>).value;
        expect(address.placeId, 'custom_place');
      },
    );

    test(
      'should return Left(Failure) when geocoding throws an exception',
      () async {
        // arrange
        when(
          () => mockGeocodingRemoteData.getPlacemarksFromCoordinates(
            tLatitude,
            tLongitude,
          ),
        ).thenThrow(Exception('Geocoding service unavailable'));

        // act
        final result = await repository.reverseGeocode(
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(result, isA<Left<Failure, AddressEntity>>());
        expect(
          result,
          equals(
            left(
              Failure(
                'Failed to reverse geocode coordinates: Exception: Geocoding service unavailable',
              ),
            ),
          ),
        );
        verify(
          () => mockGeocodingRemoteData.getPlacemarksFromCoordinates(
            tLatitude,
            tLongitude,
          ),
        ).called(1);
      },
    );

    test(
      'should return Right with lat/lng fallback when geocoding returns empty placemarks',
      () async {
        // arrange
        when(
          () => mockGeocodingRemoteData.getPlacemarksFromCoordinates(
            tLatitude,
            tLongitude,
          ),
        ).thenAnswer((_) async => <Placemark>[]);

        // act
        final result = await repository.reverseGeocode(
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(result, isA<Right<Failure, AddressEntity>>());
        final address = (result as Right<Failure, AddressEntity>).value;
        expect(
          address.formattedAddress,
          'Lat: ${tLatitude.toStringAsFixed(6)}, Lng: ${tLongitude.toStringAsFixed(6)}',
        );
      },
    );

    test(
      'should return Left(Failure) when geocoding throws ServerException',
      () async {
        // arrange
        when(
          () => mockGeocodingRemoteData.getPlacemarksFromCoordinates(
            tLatitude,
            tLongitude,
          ),
        ).thenThrow(const ServerException('API quota exceeded'));

        // act
        final result = await repository.reverseGeocode(
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(result, isA<Left<Failure, AddressEntity>>());
        expect(
          result,
          equals(
            left(
              Failure(
                'Failed to reverse geocode coordinates: ServerException: API quota exceeded',
              ),
            ),
          ),
        );
      },
    );
  });

  // ---------------------------------------------------------------------------
  // updateSelectedAddressOnMap
  // ---------------------------------------------------------------------------
  group('updateSelectedAddressOnMap', () {
    test(
      'should call mapRemoteData.moveCamera when moveCamera is true',
      () async {
        // arrange
        when(
          () => mockMapRemoteData.moveCamera(
            tMapViewId,
            tLatitude,
            tLongitude,
            tZoom,
          ),
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
          () => mockMapRemoteData.moveCamera(
            tMapViewId,
            tLatitude,
            tLongitude,
            tZoom,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockMapRemoteData);
      },
    );

    test(
      'should not call mapRemoteData.moveCamera when moveCamera is false',
      () async {
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
          () => mockMapRemoteData.moveCamera(
            tMapViewId,
            tLatitude,
            tLongitude,
            tZoom,
          ),
        );
        verifyNoMoreInteractions(mockMapRemoteData);
      },
    );

    test(
      'should return Left(Failure) when moveCamera throws ServerException',
      () async {
        // arrange
        when(
          () => mockMapRemoteData.moveCamera(
            tMapViewId,
            tLatitude,
            tLongitude,
            tZoom,
          ),
        ).thenThrow(const ServerException('Camera move failed'));

        // act
        final result = await repository.updateSelectedAddressOnMap(
          mapViewId: tMapViewId,
          address: tAddressEntity,
          moveCamera: true,
          zoom: tZoom,
        );

        // assert
        expect(
          result,
          equals(left(const Failure('Camera move failed'))),
        );
        verify(
          () => mockMapRemoteData.moveCamera(
            tMapViewId,
            tLatitude,
            tLongitude,
            tZoom,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockMapRemoteData);
      },
    );

    test(
      'should return Left(Failure) when moveCamera throws unknown exception',
      () async {
        // arrange
        when(
          () => mockMapRemoteData.moveCamera(
            tMapViewId,
            tLatitude,
            tLongitude,
            tZoom,
          ),
        ).thenThrow(Exception('Unknown error'));

        // act
        final result = await repository.updateSelectedAddressOnMap(
          mapViewId: tMapViewId,
          address: tAddressEntity,
          moveCamera: true,
          zoom: tZoom,
        );

        // assert
        expect(
          result,
          equals(
            left(
              const Failure(
                'Unable to update selected address on map: Exception: Unknown error',
              ),
            ),
          ),
        );
        verify(
          () => mockMapRemoteData.moveCamera(
            tMapViewId,
            tLatitude,
            tLongitude,
            tZoom,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockMapRemoteData);
      },
    );

    test(
      'should use default zoom when not provided',
      () async {
        // arrange
        when(
          () => mockMapRemoteData.moveCamera(
            tMapViewId,
            tLatitude,
            tLongitude,
            16.0,
          ),
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
          () => mockMapRemoteData.moveCamera(
            tMapViewId,
            tLatitude,
            tLongitude,
            16.0,
          ),
        ).called(1);
      },
    );
  });
}
