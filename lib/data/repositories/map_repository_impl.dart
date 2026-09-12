import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import '../../../domain/entity/address/address_entity.dart';
import '../../../domain/repositories/map_repository.dart';
import '../../core/errors/exception.dart';
import '../../core/errors/failure.dart';
import '../models/map/address_model.dart';
import '../sources/remote/geocoding_remote_data.dart';
import '../sources/remote/map_remote_data.dart';
import '../sources/remote/user_remote_data.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteData mapRemoteData;
  final GeocodingRemoteData geocodingRemoteData;
  final UserRemoteData userRemoteData;

  static const AddressEntity _fallbackAddress = AddressEntity(
    latitude: 3.1579,
    longitude: 101.7115,
    formattedAddress: 'Kuala Lumpur City Centre, Malaysia',
    placeId: 'fallback_klcc',
  );

  MapRepositoryImpl({
    required this.mapRemoteData,
    required this.geocodingRemoteData,
    required this.userRemoteData,
  });

  @override
  Future<Either<Failure, AddressEntity>> resolveInitialAddress() async {
    try {
      final permission = await geocodingRemoteData.checkAndRequestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Permission denied - try to get saved location from server as fallback
        final fallbackSavedLocation = await _getSavedUserLocation();
        if (fallbackSavedLocation.isRight()) {
          return fallbackSavedLocation;
        }
        // If saved location also fails, use hardcoded fallback
        return right(_fallbackAddress);
      }

      final position = await geocodingRemoteData.getCurrentPosition();
      final placemarks = await geocodingRemoteData.getPlacemarksFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final addressModel = AddressModel.fromPlacemarks(
        latitude: position.latitude,
        longitude: position.longitude,
        placemarks: placemarks,
        fallbackPlaceId: 'current_location',
      );

      return right(addressModel.toEntity());
    } catch (_) {
      // If geolocation fails, try to get saved location from server as fallback
      final fallbackSavedLocation = await _getSavedUserLocation();
      if (fallbackSavedLocation.isRight()) {
        return fallbackSavedLocation;
      }
      // If saved location also fails, use hardcoded fallback
      return right(_fallbackAddress);
    }
  }

  /// Fetches the user's saved location from the server and converts it to AddressEntity
  Future<Either<Failure, AddressEntity>> _getSavedUserLocation() async {
    try {
      final locationModel = await userRemoteData.getUserLocation();

      if (!locationModel.hasValidCoordinates) {
        return left(Failure('No saved location found'));
      }

      return right(locationModel.toAddressEntity());
    } catch (e) {
      return left(Failure('Failed to fetch saved location: $e'));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> reverseGeocode({
    required double latitude,
    required double longitude,
    String fallbackPlaceId = 'unknown_place',
  }) async {
    try {
      final placemarks = await geocodingRemoteData.getPlacemarksFromCoordinates(
        latitude,
        longitude,
      );

      final addressModel = AddressModel.fromPlacemarks(
        latitude: latitude,
        longitude: longitude,
        placemarks: placemarks,
        fallbackPlaceId: fallbackPlaceId,
      );

      return right(addressModel.toEntity());
    } catch (e) {
      return left(Failure('Failed to reverse geocode coordinates: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateSelectedAddressOnMap({
    required int mapViewId,
    required AddressEntity address,
    bool moveCamera = true,
    double zoom = 16,
  }) async {
    try {
      if (moveCamera) {
        await mapRemoteData.moveCamera(
          mapViewId,
          address.latitude,
          address.longitude,
          zoom,
        );
      }
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('Unable to update selected address on map: $e'));
    }
  }
}
