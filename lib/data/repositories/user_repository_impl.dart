import 'package:fpdart/fpdart.dart';

import '../../core/errors/exception.dart';
import '../../core/errors/failure.dart';
import '../../domain/entity/location_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../sources/remote/user_remote_data.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteData userRemoteData;
  UserRepositoryImpl({required this.userRemoteData});
  @override
  Future<Either<Failure, Unit>> updateUserAddress({
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await userRemoteData.updateUserAddress(
        address: address,
        latitude: latitude,
        longitude: longitude,
      );
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, LocationEntity>> getUserLocation() async {
    try {
      final location = await userRemoteData.getUserLocation();
      return right(location.toEntity());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}