import 'package:fpdart/fpdart.dart';

import '../../core/errors/failure.dart';
import '../entity/location_entity.dart';

abstract interface class UserRepository {
  Future<Either<Failure, Unit>> updateUserAddress({
    required String address,
    required double latitude,
    required double longitude,
  });

  Future<Either<Failure, LocationEntity>> getUserLocation();
}