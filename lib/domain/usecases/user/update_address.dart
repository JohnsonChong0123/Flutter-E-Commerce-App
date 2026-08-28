import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failure.dart';
import '../../../core/usecase/usecase.dart';
import '../../repositories/user_repository.dart';

class UpdateAddress implements UseCase<Unit, UpdateAddressParams> {
  final UserRepository repository;
  UpdateAddress(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateAddressParams params) async {
    return await repository.updateUserAddress(
      address: params.address,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

class UpdateAddressParams extends Equatable {
  final String address;
  final double latitude;
  final double longitude;

  const UpdateAddressParams({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [address, latitude, longitude];
}
