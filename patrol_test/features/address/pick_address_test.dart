import 'dart:async';

import 'package:e_commerce_client/data/models/map/map_coord_update.dart';
import 'package:e_commerce_client/data/models/location_model.dart';
import 'package:e_commerce_client/data/repositories/map_repository_impl.dart';
import 'package:e_commerce_client/data/sources/remote/geocoding_remote_data.dart';
import 'package:e_commerce_client/data/sources/remote/map_remote_data.dart';
import 'package:e_commerce_client/data/sources/remote/user_remote_data.dart';
import 'package:e_commerce_client/domain/entity/address/address_entity.dart';
import 'package:e_commerce_client/domain/entity/location_entity.dart';
import 'package:e_commerce_client/domain/repositories/map_repository.dart';
import 'package:e_commerce_client/domain/repositories/user_repository.dart';
import 'package:e_commerce_client/domain/usecases/address/reverse_geocode.dart';
import 'package:e_commerce_client/domain/usecases/user/get_user_location.dart';
import 'package:e_commerce_client/domain/usecases/user/update_address.dart';
import 'package:e_commerce_client/core/errors/failure.dart' as errors;
import 'package:e_commerce_client/presentation/blocs/address/address_bloc.dart';
import 'package:e_commerce_client/presentation/cubits/user/user_cubit.dart';
import 'package:e_commerce_client/presentation/screens/address/pick_address_screen.dart';
import 'package:e_commerce_client/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest('Location permission denied → Use saved address fallback', (
    $,
  ) async {
    final mapRemoteData = _FakeMapRemoteData();
    final userRemoteData = _FakeUserRemoteData();
    final mapRepository = MapRepositoryImpl(
      mapRemoteData: mapRemoteData,
      geocodingRemoteData: GeocodingRemoteDataImpl(),
      userRemoteData: userRemoteData,
    );
    final addressBloc = AddressPickerBloc(
      mapRepository: mapRepository,
      reverseGeocodeUseCase: ReverseGeocodeUseCase(mapRepository),
    );
    final userCubit = UserCubit(
      updateUserAddress: UpdateAddress(_FakeUserRepository()),
      getUserLocation: GetUserLocation(_FakeUserRepository()),
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
    await $.platform.mobile.denyPermission();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($('Saved test address'), findsOneWidget);
    expect($('Lat: 3.150000, Lng: 101.700000'), findsOneWidget);
  });

  patrolTest('Pick address → Resolve location → Confirm address', ($) async {
    final mapRemoteData = _FakeMapRemoteData();
    final mapRepository = _FakeMapRepository();
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

    final router = GoRouter(
      initialLocation: '/pick-address',
      routes: [
        GoRoute(
          name: 'pick-address',
          path: '/pick-address',
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: addressBloc),
              BlocProvider.value(value: userCubit),
            ],
            child: const AddressPickerScreen(),
          ),
        ),
        GoRoute(
          name: 'checkout',
          path: '/checkout',
          builder: (context, state) => const Scaffold(body: Text('Checkout')),
        ),
      ],
    );

    await $.pumpWidget(MaterialApp.router(routerConfig: router));
    await $.pumpAndSettle();

    expect($(AddressPickerScreen), findsOneWidget);
    expect($('Select Address'), findsOneWidget);
    expect($('Move the map to select a location'), findsOneWidget);
    expect($(ElevatedButton), findsOneWidget);

    addressBloc.add(const MapViewCreated(mapViewId: 7));
    await $.pumpAndSettle();

    expect($('Kuala Lumpur City Centre, Malaysia'), findsOneWidget);
    expect($('Lat: 3.157900, Lng: 101.711500'), findsOneWidget);
    expect($('Confirm Address'), findsOneWidget);

    addressBloc.add(
      const MapCoordinateUpdated(latitude: 3.140000, longitude: 101.690000),
    );
    await $.pumpAndSettle();
    expect($('Bukit Bintang, Malaysia'), findsOneWidget);

    await $('Confirm Address').tap();
    await $.pumpAndSettle();

    expect(
      userRepository.updatedAddress,
      const AddressEntity(
        latitude: 3.140000,
        longitude: 101.690000,
        formattedAddress: 'Bukit Bintang, Malaysia',
        placeId: 'resolved_place',
      ),
    );
    expect($('Checkout'), findsOneWidget);
  });
}

class _FakeMapRemoteData implements MapRemoteData {
  final StreamController<MapCoordinateUpdate> _updates =
      StreamController<MapCoordinateUpdate>.broadcast();

  @override
  Stream<MapCoordinateUpdate> get coordinateUpdates => _updates.stream;

  void emitCoordinateUpdate(MapCoordinateUpdate update) {
    _updates.add(update);
  }

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

class _FakeMapRepository implements MapRepository {
  static const _initialAddress = AddressEntity(
    latitude: 3.1579,
    longitude: 101.7115,
    formattedAddress: 'Kuala Lumpur City Centre, Malaysia',
    placeId: 'initial_place',
  );

  static const _resolvedAddress = AddressEntity(
    latitude: 3.1400,
    longitude: 101.6900,
    formattedAddress: 'Bukit Bintang, Malaysia',
    placeId: 'resolved_place',
  );

  @override
  Future<Either<errors.Failure, AddressEntity>> resolveInitialAddress() async =>
      right(_initialAddress);

  @override
  Future<Either<errors.Failure, AddressEntity>> reverseGeocode({
    required double latitude,
    required double longitude,
    String fallbackPlaceId = 'unknown_place',
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return right(_resolvedAddress);
  }

  @override
  Future<Either<errors.Failure, Unit>> updateSelectedAddressOnMap({
    required int mapViewId,
    required AddressEntity address,
    bool moveCamera = true,
    double zoom = 16,
  }) async => right(unit);
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
  AddressEntity? updatedAddress;

  @override
  Future<Either<errors.Failure, Unit>> updateUserAddress({
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    updatedAddress = AddressEntity(
      latitude: latitude,
      longitude: longitude,
      formattedAddress: address,
      placeId: 'resolved_place',
    );
    return right(unit);
  }

  @override
  Future<Either<errors.Failure, LocationEntity>> getUserLocation() async =>
      right(
        const LocationEntity(
          latitude: 3.1579,
          longitude: 101.7115,
          address: 'Kuala Lumpur City Centre, Malaysia',
        ),
      );
}
