import 'dart:async';

import 'package:e_commerce_client/core/errors/failure.dart' as errors;
import 'package:e_commerce_client/data/models/location_model.dart';
import 'package:e_commerce_client/data/models/map/map_coord_update.dart';
import 'package:e_commerce_client/data/repositories/map_repository_impl.dart';
import 'package:e_commerce_client/data/sources/remote/geocoding_remote_data.dart';
import 'package:e_commerce_client/data/sources/remote/map_remote_data.dart';
import 'package:e_commerce_client/data/sources/remote/user_remote_data.dart';
import 'package:e_commerce_client/domain/entity/location_entity.dart';
import 'package:e_commerce_client/domain/repositories/user_repository.dart';
import 'package:e_commerce_client/domain/usecases/address/reverse_geocode.dart';
import 'package:e_commerce_client/domain/usecases/user/get_user_location.dart';
import 'package:e_commerce_client/domain/usecases/user/update_address.dart';
import 'package:e_commerce_client/presentation/blocs/address/address_bloc.dart';
import 'package:e_commerce_client/presentation/cubits/user/user_cubit.dart';
import 'package:e_commerce_client/presentation/screens/address/pick_address_screen.dart';
import 'package:e_commerce_client/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest('Location permission allowed → Resolve current address', (
    $,
  ) async {
    final mapRemoteData = _FakeMapRemoteData();
    final mapRepository = MapRepositoryImpl(
      mapRemoteData: mapRemoteData,
      geocodingRemoteData: GeocodingRemoteDataImpl(),
      userRemoteData: _FakeUserRemoteData(),
    );
    final userRepository = _FakeUserRepository();
    final addressBloc = AddressPickerBloc(
      mapRepository: mapRepository,
      reverseGeocodeUseCase: ReverseGeocodeUseCase(mapRepository),
    );
    final userCubit = UserCubit(
      updateUserAddress: UpdateAddress(userRepository),
      getUserLocation: GetUserLocation(userRepository),
    );

    sl.allowReassignment = true;
    await sl.reset();
    sl.registerSingleton<MapRemoteData>(mapRemoteData);
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() {
      debugDefaultTargetPlatformOverride = null;
      addressBloc.close();
      userCubit.close();
      mapRemoteData.dispose();
      sl.reset();
    });

    await $.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: addressBloc),
            BlocProvider.value(value: userCubit),
          ],
          child: const AddressPickerScreen(),
        ),
      ),
    );
    await $.pumpAndSettle();

    addressBloc.add(const MapViewCreated(mapViewId: 7));
    await $.pump();
    await Future<void>.delayed(const Duration(seconds: 1));

    expect(await $.platform.mobile.isPermissionDialogVisible(), isTrue);
    await $.platform.mobile.grantPermissionWhenInUse();
    await $.pump(const Duration(seconds: 3));

    expect(await $.platform.mobile.isPermissionDialogVisible(), isFalse);
    expect($(AddressPickerScreen), findsOneWidget);
  });
}

class _FakeMapRemoteData implements MapRemoteData {
  final StreamController<MapCoordinateUpdate> _updates =
      StreamController<MapCoordinateUpdate>.broadcast();

  @override
  Stream<MapCoordinateUpdate> get coordinateUpdates => _updates.stream;

  @override
  Future<void> initializeMap(int mapViewId) async {}

  @override
  Future<void> moveCamera(
    int mapViewId,
    double latitude,
    double longitude,
    double zoom,
  ) async {}

  void dispose() {
    _updates.close();
  }
}

class _FakeUserRemoteData implements UserRemoteData {
  @override
  Future<void> updateUserAddress({
    required String address,
    required double latitude,
    required double longitude,
  }) async {}

  @override
  Future<LocationModel> getUserLocation() async => const LocationModel(
    latitude: 3.15,
    longitude: 101.70,
    address: 'Saved test address',
  );
}

class _FakeUserRepository implements UserRepository {
  @override
  Future<Either<errors.Failure, Unit>> updateUserAddress({
    required String address,
    required double latitude,
    required double longitude,
  }) async => right(unit);

  @override
  Future<Either<errors.Failure, LocationEntity>> getUserLocation() async =>
      right(
        const LocationEntity(
          latitude: 3.15,
          longitude: 101.70,
          address: 'Saved test address',
        ),
      );
}
