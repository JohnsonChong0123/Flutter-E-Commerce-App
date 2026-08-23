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
    fallbackPlaceId: 'place_id_123',
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

    test('initial state should be AddressInitial', () {
      expect(addressPickerBloc.state, const AddressInitial());
    });

    group('MapViewCreated', () {
      blocTest<AddressPickerBloc, AddressState>(
        'should emit [AddressLoading, AddressLoaded] when map view created and initial address resolves successfully',
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
          AddressLoading(
            mapViewId: tMapViewId,
            isResolvingAddress: true,
          ),
          AddressLoaded(
            selectedAddress: tResolvedAddress,
            mapViewId: tMapViewId,
            isResolvingAddress: false,
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
        'should emit [AddressLoading, AddressError] when resolveInitialAddress fails',
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
          AddressLoading(
            mapViewId: tMapViewId,
            isResolvingAddress: true,
          ),
          AddressError(
            message: 'Failed to resolve address',
            mapViewId: tMapViewId,
            lastKnownAddress: null,
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
        'should emit [AddressLoading, AddressError] when updateSelectedAddressOnMap fails',
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
          AddressLoading(
            mapViewId: tMapViewId,
            isResolvingAddress: true,
          ),
          AddressError(
            message: 'Failed to update map',
            mapViewId: tMapViewId,
            lastKnownAddress: tResolvedAddress,
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
          AddressLoading(
            mapViewId: tMapViewId,
            isResolvingAddress: true,
          ),
          AddressLoaded(
            selectedAddress: tResolvedAddress,
            mapViewId: tMapViewId,
            isResolvingAddress: false,
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
        'should emit [AddressResolving, AddressLoaded] when coordinate updated successfully',
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
        seed: () => AddressLoaded(
          selectedAddress: tInitialAddress,
          mapViewId: tMapViewId,
          isResolvingAddress: false,
        ),
        act: (bloc) => bloc.add(
          const MapCoordinateUpdated(latitude: 40.7128, longitude: -74.0060),
        ),
        expect: () => [
          // Optimistic update - AddressResolving
          AddressResolving(
            selectedAddress: AddressEntity(
              latitude: 40.7128,
              longitude: -74.0060,
              formattedAddress: 'San Francisco, CA, USA',
              placeId: 'place_id_123',
            ),
            mapViewId: tMapViewId,
          ),
          // Resolved address - AddressLoaded
          AddressLoaded(
            selectedAddress: tUpdatedAddress,
            mapViewId: tMapViewId,
            isResolvingAddress: false,
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
        'should emit [AddressResolving, AddressError] when reverse geocode fails',
        build: () {
          when(() => mockReverseGeocodeUseCase(any())).thenAnswer(
            (_) async => const Left(Failure('Failed to reverse geocode')),
          );

          return AddressPickerBloc(
            mapRepository: mockMapRepository,
            reverseGeocodeUseCase: mockReverseGeocodeUseCase,
          );
        },
        seed: () => AddressLoaded(
          selectedAddress: tInitialAddress,
          mapViewId: tMapViewId,
          isResolvingAddress: false,
        ),
        act: (bloc) => bloc.add(
          const MapCoordinateUpdated(latitude: 40.7128, longitude: -74.0060),
        ),
        expect: () => [
          // Optimistic update - AddressResolving
          AddressResolving(
            selectedAddress: AddressEntity(
              latitude: 40.7128,
              longitude: -74.0060,
              formattedAddress: 'San Francisco, CA, USA',
              placeId: 'place_id_123',
            ),
            mapViewId: tMapViewId,
          ),
          // Error - AddressError (lastKnownAddress is the original address from state)
          AddressError(
            message: 'Failed to reverse geocode',
            mapViewId: tMapViewId,
            lastKnownAddress: tInitialAddress,
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
        'should do nothing when state is not AddressLoaded or AddressResolving',
        build: () => AddressPickerBloc(
          mapRepository: mockMapRepository,
          reverseGeocodeUseCase: mockReverseGeocodeUseCase,
        ),
        seed: () => const AddressInitial(),
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
        seed: () => AddressError(
          message: 'Previous error',
          mapViewId: tMapViewId,
          lastKnownAddress: tInitialAddress,
        ),
        act: (bloc) => bloc.add(const RetryMapLoad()),
        expect: () => [
          AddressLoading(
            mapViewId: tMapViewId,
            isResolvingAddress: true,
          ),
          AddressLoaded(
            selectedAddress: tResolvedAddress,
            mapViewId: tMapViewId,
            isResolvingAddress: false,
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
        seed: () => AddressError(
          message: 'Previous error',
          mapViewId: null,
          lastKnownAddress: tInitialAddress,
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