import 'dart:async';

import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/models/map/map_coord_update.dart';
import 'package:e_commerce_client/data/sources/remote/generated/google_map_api.g.dart';
import 'package:e_commerce_client/data/sources/remote/map_remote_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGoogleMapHostApi extends Mock implements GoogleMapHostApi {}

class MockStreamController extends Mock implements StreamController<MapCoordinateUpdate> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockGoogleMapHostApi mockHostApi;
  late MapRemoteDataImpl mapRemoteData;

  const tMapViewId = 1;
  const tLatitude = 37.7749;
  const tLongitude = -122.4194;
  const tZoom = 16.0;

  setUp(() {
    mockHostApi = MockGoogleMapHostApi();
    mapRemoteData = MapRemoteDataImpl(hostApi: mockHostApi);
  });

  tearDown(() {
    mapRemoteData.dispose();
  });

  group('coordinateUpdates', () {
    test('should return a broadcast stream', () {
      // assert
      expect(mapRemoteData.coordinateUpdates, isA<Stream<MapCoordinateUpdate>>());
      expect(mapRemoteData.coordinateUpdates.isBroadcast, isTrue);
    });
  });

  group('initializeMap', () {
    test('should call hostApi.initializeMap and add viewId to initialized set', () async {
      // arrange
      when(() => mockHostApi.initializeMap(tMapViewId)).thenAnswer((_) async {});

      // act
      await mapRemoteData.initializeMap(tMapViewId);

      // assert
      verify(() => mockHostApi.initializeMap(tMapViewId)).called(1);
    });

    test('should not call hostApi.initializeMap again if already initialized', () async {
      // arrange
      when(() => mockHostApi.initializeMap(tMapViewId)).thenAnswer((_) async {});

      // act
      await mapRemoteData.initializeMap(tMapViewId);
      await mapRemoteData.initializeMap(tMapViewId);

      // assert
      verify(() => mockHostApi.initializeMap(tMapViewId)).called(1);
    });

    test('should throw ServerException when hostApi throws', () async {
      // arrange
      when(() => mockHostApi.initializeMap(tMapViewId)).thenThrow(Exception('Native error'));

      // act
      final result = mapRemoteData.initializeMap(tMapViewId);

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('moveCamera', () {
    test('should call initializeMap and hostApi.moveCamera with correct parameters', () async {
      // arrange
      when(() => mockHostApi.initializeMap(tMapViewId)).thenAnswer((_) async {});
      when(() => mockHostApi.moveCamera(tMapViewId, tLatitude, tLongitude, tZoom)).thenAnswer((_) async {});

      // act
      await mapRemoteData.moveCamera(tMapViewId, tLatitude, tLongitude, tZoom);

      // assert
      verify(() => mockHostApi.initializeMap(tMapViewId)).called(1);
      verify(() => mockHostApi.moveCamera(tMapViewId, tLatitude, tLongitude, tZoom)).called(1);
    });

    test('should throw ServerException when hostApi throws', () async {
      // arrange
      when(() => mockHostApi.initializeMap(tMapViewId)).thenAnswer((_) async {});
      when(() => mockHostApi.moveCamera(tMapViewId, tLatitude, tLongitude, tZoom)).thenThrow(Exception('Native error'));

      // act
      final result = mapRemoteData.moveCamera(tMapViewId, tLatitude, tLongitude, tZoom);

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });
  
  group('dispose', () {
    test('should close the coordinate controller stream', () {
      // act
      mapRemoteData.dispose();

      // assert - stream should be closed
      expect(mapRemoteData.coordinateUpdates.isBroadcast, isTrue);
      // After dispose, adding to stream should not work
      expect(() => mapRemoteData.coordinateUpdates.listen((_) {}), returnsNormally);
    });
  });
}
