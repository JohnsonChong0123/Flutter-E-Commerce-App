import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

abstract interface class GeocodingRemoteData {
  Future<Position> getCurrentPosition();
  Future<List<Placemark>> getPlacemarksFromCoordinates(
    double latitude,
    double longitude,
  );
  Future<LocationPermission> checkAndRequestPermission();
}

class GeocodingRemoteDataImpl implements GeocodingRemoteData {
  @override
  Future<Position> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } on LocationServiceDisabledException catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Placemark>> getPlacemarksFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    return await placemarkFromCoordinates(latitude, longitude);
  }

  @override
  Future<LocationPermission> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return permission;
    }
    
    return permission;
  }
}
