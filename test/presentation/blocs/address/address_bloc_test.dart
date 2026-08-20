import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/entity/address/address_entity.dart';
import 'package:e_commerce_client/domain/repositories/map_repository.dart';
import 'package:e_commerce_client/domain/usecases/address/reverse_geocode.dart';
import 'package:e_commerce_client/presentation/blocs/address/address_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockMapRepository extends Mock implements MapRepository {}

class MockReverseGeocodeUseCase extends Mock implements ReverseGeocodeUseCase {}

void main() {
  late MockMapRepository mockMapRepository;
  late MockReverseGeocodeUseCase mockReverseGeocodeUseCase;

  const tMapViewId = 1;
  const tInitialAddress = AddressEntity(
    latitude: 37.7749,
    longitude: -122.4194,
    formattedAddress: 'San Francisco, CA, USA',
    placeId: 'place_id_123',
  );

  const tResolvedAddress = AddressEntity(
    latitude: 37.7749,
    longitude: -122.4194,
    formattedAddress: 'San Francisco, CA, USA',
    placeId: 'place_id_123',
  );

  const tUpdatedAddress = AddressEntity(
    latitude: 40.7128,
    longitude: -74.0060,
    formattedAddress: 'New York, NY, USA',
    placeId: 'place_id_456',
  );

  const tReverseGeocodeParams = ReverseGeocodeParams(
    latitude: 40.7128,
    longitude: -74.0060,
    fallbackPlaceId: 'selected_coordinate',
  );

  setUpAll(() {
    registerFallbackValue(tReverseGeocodeParams);
    registerFallbackValue(
      const ReverseGeocodeParams(latitude: 0, longitude: 0),
    );
    registerFallbackValue(
      const AddressEntity(
        latitude: 0,
        longitude: 0,
        formattedAddress: '',
        placeId: '',
      ),
    );
  });

  group('AddressPickerBloc', () {
    late AddressPickerBloc addressPickerBloc;

    setUp(() {
      mockMapRepository = MockMapRepository();
      mockReverseGeocodeUseCase = MockReverseGeocodeUseCase();
      addressPickerBloc = AddressPickerBloc(
        mapRepository: mockMapRepository,
        reverseGeocodeUseCase: mockReverseGeocodeUseCase,
      );
    });

    tearDown(() {
      addressPickerBloc.close();
    });

    test('initial state should be AddressState with initial values', () {
      expect(
        addressPickerBloc.state,
        const AddressState(
          status: MapStatus.initial,
          selectedAddress: null,
          mapViewId: null,
          isResolvingAddress: false,
          errorMessage: null,
        ),
      );
    });

    group('MapViewCreated', () {
      blocTest<AddressPickerBloc, AddressState>(
        'should emit [loading, loaded] when map view created and initial address resolves successfully',
        build: () {
          when(
            () => mockMapRepository.resolveInitialAddress(
              initialAddress: tInitialAddress,
            ),
          ).thenAnswer((_) async => const Right(tResolvedAddress));

          when(
            () => mockMapRepository.updateSelectedAddressOnMap(
              mapViewId: tMapViewId,
              address: tResolvedAddress,
              moveCamera: true,
              zoom: 16,
            ),
          ).thenAnswer((_) async => const Right(unit));

          return addressPickerBloc;
        },
        act: (bloc) => bloc.add(
          const MapViewCreated(
            mapViewId: tMapViewId,
            initialAddress: tInitialAddress,
          ),
        ),
        expect: () => [
          AddressState(
            status: MapStatus.loading,
            mapViewId: tMapViewId,
            selectedAddress: null,
            isResolvingAddress: true,
            errorMessage: null,
          ),
          AddressState(
            status: MapStatus.loaded,
            selectedAddress: tResolvedAddress,
            mapViewId: tMapViewId,
            isResolvingAddress: false,
            errorMessage: null,
          ),
        ],
        verify: (_) {
          verify(
            () => mockMapRepository.resolveInitialAddress(
              initialAddress: tInitialAddress,
            ),
          ).called(1);
          verify(
            () => mockMapRepository.updateSelectedAddressOnMap(
              mapViewId: tMapViewId,
              address: tResolvedAddress,
              moveCamera: true,
              zoom: 16,
            ),
          ).called(1);
        },
      );

      blocTest<AddressPickerBloc, AddressState>(
        'should emit [loading, error] when resolveInitialAddress fails',
        build: () {
          when(
            () => mockMapRepository.resolveInitialAddress(
              initialAddress: tInitialAddress,
            ),
          ).thenAnswer(
            (_) async => const Left(Failure('Failed to resolve address')),
          );

          return addressPickerBloc;
        },
        act: (bloc) => bloc.add(
          const MapViewCreated(
            mapViewId: tMapViewId,
            initialAddress: tInitialAddress,
          ),
        ),
        expect: () => [
          AddressState(
            status: MapStatus.loading,
            mapViewId: tMapViewId,
            selectedAddress: null,
            isResolvingAddress: true,
            errorMessage: null,
          ),
          AddressState(
            status: MapStatus.error,
            mapViewId: tMapViewId,
            selectedAddress: null,
            isResolvingAddress: false,
            errorMessage: 'Failed to resolve address',
          ),
        ],
        verify: (_) {
          verify(
            () => mockMapRepository.resolveInitialAddress(
              initialAddress: tInitialAddress,
            ),
          ).called(1);
          verifyNever(
            () => mockMapRepository.updateSelectedAddressOnMap(
              mapViewId: any(named: 'mapViewId'),
              address: any(named: 'address'),
              moveCamera: any(named: 'moveCamera'),
              zoom: any(named: 'zoom'),
            ),
          );
        },
      );

      blocTest<AddressPickerBloc, AddressState>(
        'should emit [loading, error] when updateSelectedAddressOnMap fails',
        build: () {
          when(
            () => mockMapRepository.resolveInitialAddress(
              initialAddress: tInitialAddress,
            ),
          ).thenAnswer((_) async => const Right(tResolvedAddress));

          when(
            () => mockMapRepository.updateSelectedAddressOnMap(
              mapViewId: tMapViewId,
              address: tResolvedAddress,
              moveCamera: true,
              zoom: 16,
            ),
          ).thenAnswer(
            (_) async => const Left(Failure('Failed to update map')),
          );

          return addressPickerBloc;
        },
        act: (bloc) => bloc.add(
          const MapViewCreated(
            mapViewId: tMapViewId,
            initialAddress: tInitialAddress,
          ),
        ),
        expect: () => [
          AddressState(
            status: MapStatus.loading,
            mapViewId: tMapViewId,
            selectedAddress: null,
            isResolvingAddress: true,
            errorMessage: null,
          ),
          AddressState(
            status: MapStatus.error,
            mapViewId: tMapViewId,
            selectedAddress: null,
            isResolvingAddress: false,
            errorMessage: 'Failed to update map',
          ),
        ],
        verify: (_) {
          verify(
            () => mockMapRepository.resolveInitialAddress(
              initialAddress: tInitialAddress,
            ),
          ).called(1);
          verify(
            () => mockMapRepository.updateSelectedAddressOnMap(
              mapViewId: tMapViewId,
              address: tResolvedAddress,
              moveCamera: true,
              zoom: 16,
            ),
          ).called(1);
        },
      );

      blocTest<AddressPickerBloc, AddressState>(
        'should work without initial address',
        build: () {
          when(
            () => mockMapRepository.resolveInitialAddress(initialAddress: null),
          ).thenAnswer((_) async => const Right(tResolvedAddress));

          when(
            () => mockMapRepository.updateSelectedAddressOnMap(
              mapViewId: tMapViewId,
              address: tResolvedAddress,
              moveCamera: true,
              zoom: 16,
            ),
          ).thenAnswer((_) async => const Right(unit));

          return addressPickerBloc;
        },
        act: (bloc) => bloc.add(
          const MapViewCreated(mapViewId: tMapViewId, initialAddress: null),
        ),
        expect: () => [
          AddressState(
            status: MapStatus.loading,
            mapViewId: tMapViewId,
            selectedAddress: null,
            isResolvingAddress: true,
            errorMessage: null,
          ),
          AddressState(
            status: MapStatus.loaded,
            selectedAddress: tResolvedAddress,
            mapViewId: tMapViewId,
            isResolvingAddress: false,
            errorMessage: null,
          ),
        ],
        verify: (_) {
          verify(
            () => mockMapRepository.resolveInitialAddress(initialAddress: null),
          ).called(1);
        },
      );
    });

    group('MapCoordinateUpdated', () {
      blocTest<AddressPickerBloc, AddressState>(
        'should emit [loaded with optimistic update, loaded with resolved address] when coordinate updated successfully',
        build: () {
          when(
            () => mockReverseGeocodeUseCase(any()),
          ).thenAnswer((_) async => const Right(tUpdatedAddress));

          when(
            () => mockMapRepository.updateSelectedAddressOnMap(
              mapViewId: tMapViewId,
              address: tUpdatedAddress,
              moveCamera: false,
              zoom: 16,
            ),
          ).thenAnswer((_) async => const Right(unit));

          return AddressPickerBloc(
            mapRepository: mockMapRepository,
            reverseGeocodeUseCase: mockReverseGeocodeUseCase,
          );
        },
        seed: () => AddressState(
          status: MapStatus.loaded,
          selectedAddress: tInitialAddress,
          mapViewId: tMapViewId,
          isResolvingAddress: false,
        ),
        act: (bloc) => bloc.add(
          const MapCoordinateUpdated(latitude: 40.7128, longitude: -74.0060),
        ),
        expect: () => [
          // Optimistic update
          AddressState(
            status: MapStatus.loaded,
            selectedAddress: AddressEntity(
              latitude: 40.7128,
              longitude: -74.0060,
              formattedAddress: 'San Francisco, CA, USA',
              placeId: 'place_id_123',
            ),
            mapViewId: tMapViewId,
            isResolvingAddress: true,
            errorMessage: null,
          ),
          // Resolved address
          AddressState(
            status: MapStatus.loaded,
            selectedAddress: tUpdatedAddress,
            mapViewId: tMapViewId,
            isResolvingAddress: false,
            errorMessage: null,
          ),
        ],
        verify: (_) {
          verify(() => mockReverseGeocodeUseCase(any())).called(1);
          verify(
            () => mockMapRepository.updateSelectedAddressOnMap(
              mapViewId: tMapViewId,
              address: tUpdatedAddress,
              moveCamera: false,
              zoom: 16,
            ),
          ).called(1);
        },
      );

      blocTest<AddressPickerBloc, AddressState>(
        'should emit [loaded with optimistic update, error] when reverse geocode fails',
        build: () {
          when(() => mockReverseGeocodeUseCase(any())).thenAnswer(
            (_) async => const Left(Failure('Failed to reverse geocode')),
          );

          return AddressPickerBloc(
            mapRepository: mockMapRepository,
            reverseGeocodeUseCase: mockReverseGeocodeUseCase,
          );
        },
        seed: () => AddressState(
          status: MapStatus.loaded,
          selectedAddress: tInitialAddress,
          mapViewId: tMapViewId,
          isResolvingAddress: false,
        ),
        act: (bloc) => bloc.add(
          const MapCoordinateUpdated(latitude: 40.7128, longitude: -74.0060),
        ),
        expect: () => [
          // Optimistic update
          AddressState(
            status: MapStatus.loaded,
            selectedAddress: AddressEntity(
              latitude: 40.7128,
              longitude: -74.0060,
              formattedAddress: 'San Francisco, CA, USA',
              placeId: 'place_id_123',
            ),
            mapViewId: tMapViewId,
            isResolvingAddress: true,
            errorMessage: null,
          ),
          // Error
          AddressState(
            status: MapStatus.error,
            selectedAddress: AddressEntity(
              latitude: 40.7128,
              longitude: -74.0060,
              formattedAddress: 'San Francisco, CA, USA',
              placeId: 'place_id_123',
            ),
            mapViewId: tMapViewId,
            isResolvingAddress: false,
            errorMessage: 'Failed to reverse geocode',
          ),
        ],
        verify: (_) {
          verify(() => mockReverseGeocodeUseCase(any())).called(1);
          verifyNever(
            () => mockMapRepository.updateSelectedAddressOnMap(
              mapViewId: any(named: 'mapViewId'),
              address: any(named: 'address'),
              moveCamera: any(named: 'moveCamera'),
              zoom: any(named: 'zoom'),
            ),
          );
        },
      );

      blocTest<AddressPickerBloc, AddressState>(
        'should do nothing when mapViewId is null',
        build: () => AddressPickerBloc(
          mapRepository: mockMapRepository,
          reverseGeocodeUseCase: mockReverseGeocodeUseCase,
        ),
        seed: () => const AddressState(
          status: MapStatus.loaded,
          selectedAddress: tInitialAddress,
          mapViewId: null,
          isResolvingAddress: false,
        ),
        act: (bloc) => bloc.add(
          const MapCoordinateUpdated(latitude: 40.7128, longitude: -74.0060),
        ),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockReverseGeocodeUseCase(any()));
        },
      );
    });

    group('RetryMapLoad', () {
      blocTest<AddressPickerBloc, AddressState>(
        'should add MapViewCreated event when retry is triggered',
        build: () {
          when(
            () => mockMapRepository.resolveInitialAddress(
              initialAddress: tInitialAddress,
            ),
          ).thenAnswer((_) async => const Right(tResolvedAddress));

          when(
            () => mockMapRepository.updateSelectedAddressOnMap(
              mapViewId: tMapViewId,
              address: tResolvedAddress,
              moveCamera: true,
              zoom: 16,
            ),
          ).thenAnswer((_) async => const Right(unit));

          return AddressPickerBloc(
            mapRepository: mockMapRepository,
            reverseGeocodeUseCase: mockReverseGeocodeUseCase,
          );
        },
        seed: () => AddressState(
          status: MapStatus.error,
          selectedAddress: tInitialAddress,
          mapViewId: tMapViewId,
          isResolvingAddress: false,
          errorMessage: 'Previous error',
        ),
        act: (bloc) => bloc.add(const RetryMapLoad()),
        expect: () => [
          AddressState(
            status: MapStatus.loading,
            mapViewId: tMapViewId,
            selectedAddress: null,
            isResolvingAddress: true,
            errorMessage: null,
          ),
          AddressState(
            status: MapStatus.loaded,
            selectedAddress: tResolvedAddress,
            mapViewId: tMapViewId,
            isResolvingAddress: false,
            errorMessage: null,
          ),
        ],
        verify: (_) {
          verify(
            () => mockMapRepository.resolveInitialAddress(
              initialAddress: tInitialAddress,
            ),
          ).called(1);
        },
      );

      blocTest<AddressPickerBloc, AddressState>(
        'should do nothing when mapViewId is null',
        build: () => AddressPickerBloc(
          mapRepository: mockMapRepository,
          reverseGeocodeUseCase: mockReverseGeocodeUseCase,
        ),
        seed: () => const AddressState(
          status: MapStatus.error,
          selectedAddress: tInitialAddress,
          mapViewId: null,
          isResolvingAddress: false,
          errorMessage: 'Previous error',
        ),
        act: (bloc) => bloc.add(const RetryMapLoad()),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => mockMapRepository.resolveInitialAddress(
              initialAddress: any(named: 'initialAddress'),
            ),
          );
        },
      );
    });
  });
}
