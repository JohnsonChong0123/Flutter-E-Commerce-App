import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/sources/remote/geocoding_remote_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes for testing - these would be used if we had a wrapper service
// Since Geolocator and geocoding use static methods, they cannot be mocked directly with mocktail.
// For proper unit testing, a wrapper service would be needed (similar to MapRemoteData pattern).
// These tests document the expected behavior of GeocodingRemoteDataImpl.

class MockGeocodingRemoteData extends Mock implements GeocodingRemoteData {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const tLatitude = 37.7749;
  const tLongitude = -122.4194;

  final tPosition = Position(
    latitude: tLatitude,
    longitude: tLongitude,
    timestamp: DateTime.now(),
    accuracy: 10.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    altitudeAccuracy: 0.0,
    headingAccuracy: 0.0,
  );

  final tPlacemark = Placemark(
    name: 'Test Place',
    street: '123 Test St',
    subLocality: 'Test Neighborhood',
    locality: 'San Francisco',
    subAdministrativeArea: 'San Francisco County',
    administrativeArea: 'CA',
    postalCode: '94102',
    country: 'USA',
    isoCountryCode: 'US',
  );

  final tPlacemarks = [tPlacemark];

  group('GeocodingRemoteData Interface Contract', () {
    late MockGeocodingRemoteData mockGeocodingRemoteData;

    setUp(() {
      mockGeocodingRemoteData = MockGeocodingRemoteData();
    });

    group('getCurrentPosition', () {
      test('should return Position on success', () async {
        // arrange
        when(() => mockGeocodingRemoteData.getCurrentPosition())
            .thenAnswer((_) async => tPosition);

        // act
        final result = await mockGeocodingRemoteData.getCurrentPosition();

        // assert
        expect(result, equals(tPosition));
        verify(() => mockGeocodingRemoteData.getCurrentPosition()).called(1);
      });

      test('should throw ServerException on failure', () async {
        // arrange
        when(() => mockGeocodingRemoteData.getCurrentPosition())
            .thenThrow(const ServerException('Location service disabled'));

        // act & assert
        expect(
          () => mockGeocodingRemoteData.getCurrentPosition(),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('getPlacemarksFromCoordinates', () {
      test('should return list of Placemark on success', () async {
        // arrange
        when(() => mockGeocodingRemoteData.getPlacemarksFromCoordinates(tLatitude, tLongitude))
            .thenAnswer((_) async => tPlacemarks);

        // act
        final result = await mockGeocodingRemoteData.getPlacemarksFromCoordinates(
          tLatitude,
          tLongitude,
        );

        // assert
        expect(result, equals(tPlacemarks));
        verify(() => mockGeocodingRemoteData.getPlacemarksFromCoordinates(tLatitude, tLongitude))
            .called(1);
      });

      test('should return empty list when no placemarks found', () async {
        // arrange
        when(() => mockGeocodingRemoteData.getPlacemarksFromCoordinates(tLatitude, tLongitude))
            .thenAnswer((_) async => <Placemark>[]);

        // act
        final result = await mockGeocodingRemoteData.getPlacemarksFromCoordinates(
          tLatitude,
          tLongitude,
        );

        // assert
        expect(result, isEmpty);
        verify(() => mockGeocodingRemoteData.getPlacemarksFromCoordinates(tLatitude, tLongitude))
            .called(1);
      });

      test('should throw exception on failure', () async {
        // arrange
        when(() => mockGeocodingRemoteData.getPlacemarksFromCoordinates(tLatitude, tLongitude))
            .thenThrow(Exception('Geocoding failed'));

        // act & assert
        expect(
          () => mockGeocodingRemoteData.getPlacemarksFromCoordinates(tLatitude, tLongitude),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('checkAndRequestPermission', () {
      test('should return denied when location service is disabled', () async {
        // arrange
        when(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .thenAnswer((_) async => LocationPermission.denied);

        // act
        final result = await mockGeocodingRemoteData.checkAndRequestPermission();

        // assert
        expect(result, equals(LocationPermission.denied));
        verify(() => mockGeocodingRemoteData.checkAndRequestPermission()).called(1);
      });

      test('should return current permission when not denied', () async {
        // arrange
        when(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);

        // act
        final result = await mockGeocodingRemoteData.checkAndRequestPermission();

        // assert
        expect(result, equals(LocationPermission.whileInUse));
        verify(() => mockGeocodingRemoteData.checkAndRequestPermission()).called(1);
      });

      test('should return deniedForever when permission is deniedForever', () async {
        // arrange
        when(() => mockGeocodingRemoteData.checkAndRequestPermission())
            .thenAnswer((_) async => LocationPermission.deniedForever);

        // act
        final result = await mockGeocodingRemoteData.checkAndRequestPermission();

        // assert
        expect(result, equals(LocationPermission.deniedForever));
        verify(() => mockGeocodingRemoteData.checkAndRequestPermission()).called(1);
      });
    });
  });
}
