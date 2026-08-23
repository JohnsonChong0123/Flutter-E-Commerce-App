import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/address/address_entity.dart';
import '../../../domain/repositories/map_repository.dart';
import '../../../domain/usecases/address/reverse_geocode.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressPickerBloc extends Bloc<AddressEvent, AddressState> {
  final MapRepository _mapRepository;
  final ReverseGeocodeUseCase _reverseGeocodeUseCase;

  AddressPickerBloc({
    required MapRepository mapRepository,
    required ReverseGeocodeUseCase reverseGeocodeUseCase,
  }) : _mapRepository = mapRepository,
       _reverseGeocodeUseCase = reverseGeocodeUseCase,
       super(const AddressInitial()) {
    on<MapViewCreated>(_onMapViewCreated);
    on<MapCoordinateUpdated>(_onMapCoordinateUpdated);
    on<RetryMapLoad>(_onRetryMapLoad);
  }

  Future<void> _onMapViewCreated(
    MapViewCreated event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading(mapViewId: event.mapViewId, isResolvingAddress: true));

    final initialAddressResult = await _mapRepository.resolveInitialAddress(
      initialAddress: event.initialAddress,
    );

    await initialAddressResult.fold(
      (failure) async {
        emit(
          AddressError(message: failure.message, mapViewId: event.mapViewId),
        );
      },
      (address) async {
        final mapUpdateResult = await _mapRepository.updateSelectedAddressOnMap(
          mapViewId: event.mapViewId,
          address: address,
          moveCamera: true,
        );

        await mapUpdateResult.fold(
          (failure) {
            emit(
              AddressError(
                message: failure.message,
                mapViewId: event.mapViewId,
                lastKnownAddress: address,
              ),
            );
          },
          (_) {
            emit(
              AddressLoaded(
                selectedAddress: address,
                mapViewId: event.mapViewId,
                isResolvingAddress: false,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onMapCoordinateUpdated(
    MapCoordinateUpdated event,
    Emitter<AddressState> emit,
  ) async {
    final currentState = state;

    int mapViewId;
    AddressEntity? currentAddress;

    if (currentState is AddressLoaded) {
      mapViewId = currentState.mapViewId;
      currentAddress = currentState.selectedAddress;
    } else if (currentState is AddressResolving) {
      mapViewId = currentState.mapViewId;
      currentAddress = currentState.selectedAddress;
    } else {
      return;
    }

    final tempAddress = AddressEntity(
      latitude: event.latitude,
      longitude: event.longitude,
      formattedAddress: currentAddress.formattedAddress,
      placeId: currentAddress.placeId,
    );

    emit(AddressResolving(selectedAddress: tempAddress, mapViewId: mapViewId));

    final reverseGeocodeResult = await _reverseGeocodeUseCase(
      ReverseGeocodeParams(
        latitude: event.latitude,
        longitude: event.longitude,
        fallbackPlaceId: currentAddress.placeId,
      ),
    );

    await reverseGeocodeResult.fold(
      (failure) async {
        emit(
          AddressError(
            message: failure.message,
            mapViewId: mapViewId,
            lastKnownAddress: currentAddress,
          ),
        );
      },
      (resolvedAddress) async {
        await _mapRepository.updateSelectedAddressOnMap(
          mapViewId: mapViewId,
          address: resolvedAddress,
          moveCamera: false,
        );

        emit(
          AddressLoaded(
            selectedAddress: resolvedAddress,
            mapViewId: mapViewId,
            isResolvingAddress: false,
          ),
        );
      },
    );
  }

  Future<void> _onRetryMapLoad(
    RetryMapLoad event,
    Emitter<AddressState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AddressError) return;

    final mapViewId = currentState.mapViewId;
    if (mapViewId == null) return;

    add(
      MapViewCreated(
        mapViewId: mapViewId,
        initialAddress: currentState.lastKnownAddress,
      ),
    );
  }
}
