import 'dart:async';

import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/sources/remote/generated/google_map_api.g.dart';

class MapCoordinateUpdate {
  final int viewId;
  final double latitude;
  final double longitude;

  const MapCoordinateUpdate({
    required this.viewId,
    required this.latitude,
    required this.longitude,
  });
}

abstract interface class MapRemoteData {
  Stream<MapCoordinateUpdate> get coordinateUpdates;

  Future<void> initializeMap(int mapViewId);

  Future<void> moveCamera(
    int mapViewId,
    double latitude,
    double longitude,
    double zoom,
  );
}

class MapRemoteDataImpl implements MapRemoteData {
  final GoogleMapHostApi _hostApi;
  final Set<int> _initializedViewIds = <int>{};
  final StreamController<MapCoordinateUpdate> _coordinateController =
      StreamController<MapCoordinateUpdate>.broadcast();
  late final _MapFlutterCallbackHandler _callbackHandler;

  MapRemoteDataImpl({GoogleMapHostApi? hostApi})
    : _hostApi = hostApi ?? GoogleMapHostApi() {
    _callbackHandler = _MapFlutterCallbackHandler(_coordinateController);
    GoogleMapFlutterApi.setUp(_callbackHandler);
  }

  @override
  Stream<MapCoordinateUpdate> get coordinateUpdates =>
      _coordinateController.stream;

  void dispose() {
    _coordinateController.close();
  }

  @override
  Future<void> initializeMap(int mapViewId) async {
    if (_initializedViewIds.contains(mapViewId)) {
      return;
    }

    try {
      await _hostApi.initializeMap(mapViewId);
      _initializedViewIds.add(mapViewId);
    } catch (e) {
      throw ServerException('Failed to initialize native map: $e');
    }
  }

  @override
  Future<void> moveCamera(
    int mapViewId,
    double latitude,
    double longitude,
    double zoom,
  ) async {
    try {
      await initializeMap(mapViewId);
      await _hostApi.moveCamera(mapViewId, latitude, longitude, zoom);
    } catch (e) {
      throw ServerException('Failed to move map camera: $e');
    }
  }
}

class _MapFlutterCallbackHandler extends GoogleMapFlutterApi {
  final StreamController<MapCoordinateUpdate> _coordinateController;

  _MapFlutterCallbackHandler(this._coordinateController);

  @override
  Future<void> onCameraIdle(
    int viewId,
    double latitude,
    double longitude,
  ) async {
    _coordinateController.add(
      MapCoordinateUpdate(
        viewId: viewId,
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  @override
  Future<void> onMarkerDragEnd(
    int viewId,
    double latitude,
    double longitude,
  ) async {
    _coordinateController.add(
      MapCoordinateUpdate(
        viewId: viewId,
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }
}
