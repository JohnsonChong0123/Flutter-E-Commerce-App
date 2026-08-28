import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/usecase/usecase.dart';
import '../../entity/location_entity.dart';
import '../../repositories/user_repository.dart';

class GetUserLocation implements UseCase<LocationEntity, NoParams> {
  final UserRepository repository;

  GetUserLocation(this.repository);

  @override
  Future<Either<Failure, LocationEntity>> call(NoParams params) {
    return repository.getUserLocation();
  }
}
