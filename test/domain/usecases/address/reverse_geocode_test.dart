import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/entity/address/address_entity.dart';
import 'package:e_commerce_client/domain/repositories/map_repository.dart';
import 'package:e_commerce_client/domain/usecases/address/reverse_geocode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

class MockMapRepository extends Mock implements MapRepository {}

void main() {
  late MockMapRepository mockRepository;
  late ReverseGeocodeUseCase usecase;

  const tParams = ReverseGeocodeParams(
    latitude: 37.7749,
    longitude: -122.4194,
    fallbackPlaceId: 'test_place_id',
  );

  const tAddressEntity = AddressEntity(
    latitude: 37.7749,
    longitude: -122.4194,
    formattedAddress: 'San Francisco, CA, USA',
    placeId: 'test_place_id',
  );

  setUp(() {
    mockRepository = MockMapRepository();
    usecase = ReverseGeocodeUseCase(mockRepository);
  });

  test(
    'should call repository reverseGeocode and return AddressEntity on success',
    () async {
      // arrange
      when(
        () => mockRepository.reverseGeocode(
          latitude: tParams.latitude,
          longitude: tParams.longitude,
          fallbackPlaceId: tParams.fallbackPlaceId,
        ),
      ).thenAnswer((_) async => const Right(tAddressEntity));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, const Right(tAddressEntity));
      verify(
        () => mockRepository.reverseGeocode(
          latitude: tParams.latitude,
          longitude: tParams.longitude,
          fallbackPlaceId: tParams.fallbackPlaceId,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository returns Failure', () async {
    // arrange
    const failure = Failure('Server error');

    when(
      () => mockRepository.reverseGeocode(
        latitude: tParams.latitude,
        longitude: tParams.longitude,
        fallbackPlaceId: tParams.fallbackPlaceId,
      ),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Left(failure));
    verify(
      () => mockRepository.reverseGeocode(
        latitude: tParams.latitude,
        longitude: tParams.longitude,
        fallbackPlaceId: tParams.fallbackPlaceId,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test(
    'should use default fallbackPlaceId when not provided',
    () async {
      // arrange
      const paramsWithoutFallback = ReverseGeocodeParams(
        latitude: 37.7749,
        longitude: -122.4194,
      );

      when(
        () => mockRepository.reverseGeocode(
          latitude: paramsWithoutFallback.latitude,
          longitude: paramsWithoutFallback.longitude,
          fallbackPlaceId: 'unknown_place',
        ),
      ).thenAnswer((_) async => const Right(tAddressEntity));

      // act
      final result = await usecase(paramsWithoutFallback);

      // assert
      expect(result, const Right(tAddressEntity));
      verify(
        () => mockRepository.reverseGeocode(
          latitude: paramsWithoutFallback.latitude,
          longitude: paramsWithoutFallback.longitude,
          fallbackPlaceId: 'unknown_place',
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}