import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entity/address/address_entity.dart';
import '../../domain/repositories/map_repository.dart';
import '../sources/remote/map_remote_data.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteData mapRemoteData;

  MapRepositoryImpl({required this.mapRemoteData});

  static const AddressEntity _fallbackAddress = AddressEntity(
    latitude: 3.1579,
    longitude: 101.7115,
    formattedAddress: 'Kuala Lumpur City Centre, Malaysia',
    placeId: 'fallback_klcc',
  );

  @override
  Future<Either<Failure, AddressEntity>> resolveInitialAddress({
    AddressEntity? initialAddress,
  }) async {
    if (initialAddress != null) {
      return right(initialAddress);
    }

    try {
      final permission = await _resolvePermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return right(_fallbackAddress);
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final geocoded = await reverseGeocode(
        latitude: position.latitude,
        longitude: position.longitude,
        fallbackPlaceId: 'current_location',
      );

      return geocoded.fold(
        (_) => right(_fallbackAddress),
        (address) => right(address),
      );
    } catch (_) {
      return right(_fallbackAddress);
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> reverseGeocode({
    required double latitude,
    required double longitude,
    String fallbackPlaceId = 'unknown_place',
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      final place = placemarks.isNotEmpty ? placemarks.first : null;
      final line1 = [
        place?.name,
        place?.subLocality,
        place?.thoroughfare,
      ].where((value) => value != null && value.trim().isNotEmpty).join(', ');
      final line2 = [
        place?.locality,
        place?.administrativeArea,
        place?.country,
      ].where((value) => value != null && value.trim().isNotEmpty).join(', ');
      final formatted = [
        line1,
        line2,
      ].where((value) => value.trim().isNotEmpty).join('\n');

      return right(
        AddressEntity(
          latitude: latitude,
          longitude: longitude,
          formattedAddress: formatted.isEmpty
              ? 'Lat: ${latitude.toStringAsFixed(6)}, Lng: ${longitude.toStringAsFixed(6)}'
              : formatted,
          placeId: fallbackPlaceId,
        ),
      );
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
      await mapRemoteData.updateSelectedAddressMarker(
        mapViewId,
        address,
      );
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

  Future<LocationPermission> _resolvePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermission.denied;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }
}
