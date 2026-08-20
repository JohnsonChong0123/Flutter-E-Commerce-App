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
       super(const AddressState()) {
    on<MapViewCreated>(_onMapViewCreated);
    on<MapCoordinateUpdated>(_onMapCoordinateUpdated);
    on<RetryMapLoad>(_onRetryMapLoad);
  }

  Future<void> _onMapViewCreated(
    MapViewCreated event,
    Emitter<AddressState> emit,
  ) async {
    emit(
      state.copyWith(
        status: MapStatus.loading,
        mapViewId: event.mapViewId,
        isResolvingAddress: true,
        clearError: true,
        clearSelectedAddress: true,
      ),
    );

    final initialAddressResult = await _mapRepository.resolveInitialAddress(
      initialAddress: event.initialAddress,
    );

    await initialAddressResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: MapStatus.error,
            isResolvingAddress: false,
            errorMessage: failure.message,
          ),
        );
      },
      (address) async {
        final mapUpdateResult = await _mapRepository.updateSelectedAddressOnMap(
          mapViewId: event.mapViewId,
          address: address,
          moveCamera: true,
        );

        mapUpdateResult.fold(
          (failure) => emit(
            state.copyWith(
              status: MapStatus.error,
              isResolvingAddress: false,
              errorMessage: failure.message,
            ),
          ),
          (_) => emit(
            state.copyWith(
              status: MapStatus.loaded,
              selectedAddress: address,
              isResolvingAddress: false,
              clearError: true,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onMapCoordinateUpdated(
    MapCoordinateUpdated event,
    Emitter<AddressState> emit,
  ) async {
    final mapViewId = state.mapViewId;
    if (mapViewId == null) return;

    final currentPlaceId = state.selectedAddress?.placeId ?? 'selected_coordinate';

    emit(
      state.copyWith(
        status: MapStatus.loaded,
        selectedAddress: AddressEntity(
          latitude: event.latitude,
          longitude: event.longitude,
          formattedAddress:
              state.selectedAddress?.formattedAddress ?? 'Resolving address...',
          placeId: currentPlaceId,
        ),
        isResolvingAddress: true,
        clearError: true,
      ),
    );

    final reverseGeocodeResult = await _reverseGeocodeUseCase(
      ReverseGeocodeParams(
        latitude: event.latitude,
        longitude: event.longitude,
        fallbackPlaceId: currentPlaceId,
      ),
    );

    await reverseGeocodeResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: MapStatus.error,
            isResolvingAddress: false,
            errorMessage: failure.message,
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
          state.copyWith(
            status: MapStatus.loaded,
            selectedAddress: resolvedAddress,
            isResolvingAddress: false,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onRetryMapLoad(
    RetryMapLoad event,
    Emitter<AddressState> emit,
  ) async {
    final mapViewId = state.mapViewId;
    if (mapViewId == null) return;
    add(
      MapViewCreated(
        mapViewId: mapViewId,
        initialAddress: state.selectedAddress,
      ),
    );
  }
}