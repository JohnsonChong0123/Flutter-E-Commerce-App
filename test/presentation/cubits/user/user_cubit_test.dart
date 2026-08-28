import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/entity/location_entity.dart';
import 'package:e_commerce_client/domain/usecases/user/get_user_location.dart';
import 'package:e_commerce_client/domain/usecases/user/update_address.dart';
import 'package:e_commerce_client/presentation/cubits/user/user_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockUpdateAddress extends Mock implements UpdateAddress {}

class MockGetUserLocation extends Mock implements GetUserLocation {}

void main() {
  late MockUpdateAddress mockUpdateAddress;
  late MockGetUserLocation mockGetUserLocation;
  late UserCubit cubit;

  const tAddress = 'KL';
  const tLatitude = 3.14;
  const tLongitude = 101.69;

  const tUpdateAddressParams = UpdateAddressParams(
    address: tAddress,
    latitude: tLatitude,
    longitude: tLongitude,
  );

  const tLocationEntity = LocationEntity(
    address: tAddress,
    latitude: tLatitude,
    longitude: tLongitude,
  );

  setUp(() {
    mockUpdateAddress = MockUpdateAddress();
    mockGetUserLocation = MockGetUserLocation();
    cubit = UserCubit(
      updateUserAddress: mockUpdateAddress,
      getUserLocation: mockGetUserLocation,
    );
  });

  const tFailure = Failure('Failed to update address');

  group('UserCubit updateUserAddress', () {
    blocTest<UserCubit, UserState>(
      'should emit [UserLoading, UserSuccess] when update address succeeds',
      build: () {
        when(
          () => mockUpdateAddress(tUpdateAddressParams),
        ).thenAnswer((_) async => const Right(unit));
        return cubit;
      },
      act: (cubit) =>
          cubit.updateUserAddress(tAddress, tLatitude, tLongitude),
      expect: () => [UserLoading(), const UserSuccess()],
      verify: (_) {
        verify(
          () => mockUpdateAddress(
            const UpdateAddressParams(
              address: tAddress,
              latitude: tLatitude,
              longitude: tLongitude,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<UserCubit, UserState>(
      'should emit [UserLoading, UserFailure] when update address fails',
      build: () {
        when(
          () => mockUpdateAddress(tUpdateAddressParams),
        ).thenAnswer((_) async => const Left(tFailure));
        return cubit;
      },
      act: (cubit) =>
          cubit.updateUserAddress(tAddress, tLatitude, tLongitude),
      expect: () => [
        UserLoading(),
        const UserFailure(message: 'Failed to update address'),
      ],
      verify: (_) {
        verify(() => mockUpdateAddress(tUpdateAddressParams)).called(1);
      },
    );
  });

  group('UserCubit getUserLocation', () {
    blocTest<UserCubit, UserState>(
      'should emit [UserLoading, UserLocationSuccess] when get location succeeds',
      build: () {
        when(
          () => mockGetUserLocation(NoParams()),
        ).thenAnswer((_) async => const Right(tLocationEntity));
        return cubit;
      },
      act: (cubit) => cubit.getUserLocation(),
      expect: () => [
        UserLoading(),
        const UserLocationSuccess(location: tLocationEntity),
      ],
      verify: (_) {
        verify(() => mockGetUserLocation(NoParams())).called(1);
      },
    );

    blocTest<UserCubit, UserState>(
      'should emit [UserLoading, UserFailure] when get location fails',
      build: () {
        when(
          () => mockGetUserLocation(NoParams()),
        ).thenAnswer(
          (_) async => const Left(Failure('Failed to get location')),
        );
        return cubit;
      },
      act: (cubit) => cubit.getUserLocation(),
      expect: () => [
        UserLoading(),
        const UserFailure(message: 'Failed to get location'),
      ],
      verify: (_) {
        verify(() => mockGetUserLocation(NoParams())).called(1);
      },
    );
  });

  test('initial state should be UserInitial', () {
    expect(cubit.state, const UserInitial());
  });
}
