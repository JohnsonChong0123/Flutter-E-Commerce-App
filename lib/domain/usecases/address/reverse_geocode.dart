import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../entity/address/address_entity.dart';
import '../../repositories/map_repository.dart';

class ReverseGeocodeUseCase
    implements UseCase<AddressEntity, ReverseGeocodeParams> {
  final MapRepository repository;

  ReverseGeocodeUseCase(this.repository);

  @override
  Future<Either<Failure, AddressEntity>> call(
    ReverseGeocodeParams params,
  ) async {
    return repository.reverseGeocode(
      latitude: params.latitude,
      longitude: params.longitude,
      fallbackPlaceId: params.fallbackPlaceId,
    );
  }
}

class ReverseGeocodeParams extends Equatable {
  final double latitude;
  final double longitude;
  final String fallbackPlaceId;

  const ReverseGeocodeParams({
    required this.latitude,
    required this.longitude,
    this.fallbackPlaceId = 'unknown_place',
  });

  @override
  List<Object?> get props => [latitude, longitude, fallbackPlaceId];
}
