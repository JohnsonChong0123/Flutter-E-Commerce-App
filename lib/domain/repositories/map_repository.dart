import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entity/address/address_entity.dart';

abstract interface class MapRepository {
  Future<Either<Failure, AddressEntity>> resolveInitialAddress({
    AddressEntity? initialAddress,
  });

  Future<Either<Failure, AddressEntity>> reverseGeocode({
    required double latitude,
    required double longitude,
    String fallbackPlaceId = 'unknown_place',
  });

  Future<Either<Failure, Unit>> updateSelectedAddressOnMap({
    required int mapViewId,
    required AddressEntity address,
    bool moveCamera = true,
    double zoom = 16,
  });
}