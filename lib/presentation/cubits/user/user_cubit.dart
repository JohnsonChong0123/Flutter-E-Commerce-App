import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/usecase/usecase.dart';
import '../../../domain/entity/location_entity.dart';
import '../../../domain/usecases/user/get_user_location.dart';
import '../../../domain/usecases/user/update_address.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UpdateAddress _updateUserAddress;
  final GetUserLocation _getUserLocation;

  UserCubit({
    required UpdateAddress updateUserAddress,
    required GetUserLocation getUserLocation,
  })
    : _updateUserAddress = updateUserAddress,
      _getUserLocation = getUserLocation,
      super(UserInitial());

  Future<void> updateUserAddress(
    String address,
    double latitude,
    double longitude,
  ) async {
    emit(UserLoading());
    final result = await _updateUserAddress(
      UpdateAddressParams(
        address: address,
        latitude: latitude,
        longitude: longitude,
      ),
    );
    result.fold(
      (failure) => emit(UserFailure(message: failure.message)),
      (_) => emit(UserSuccess()),
    );
  }

  Future<void> getUserLocation() async {
    emit(UserLoading());
    final result = await _getUserLocation(NoParams());
    result.fold(
      (failure) => emit(UserFailure(message: failure.message)),
      (location) => emit(UserLocationSuccess(location: location)),
    );
  }
}
