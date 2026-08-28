import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/repositories/user_repository.dart';
import 'package:e_commerce_client/domain/usecases/user/update_address.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockRepository;
  late UpdateAddress usecase;

  const tAddress = 'KL';
  const tLatitude = 3.14;
  const tLongitude = 101.69;

  const tParams = UpdateAddressParams(
    address: tAddress,
    latitude: tLatitude,
    longitude: tLongitude,
  );

  setUp(() {
    mockRepository = MockUserRepository();
    usecase = UpdateAddress(mockRepository);
  });

  test(
    'should call repository updateUserAddress and return unit on success',
    () async {
      // arrange
      when(
        () => mockRepository.updateUserAddress(
          address: tParams.address,
          latitude: tParams.latitude,
          longitude: tParams.longitude,
        ),
      ).thenAnswer((_) async => Right(unit));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, equals(Right(unit)));
      verify(
        () => mockRepository.updateUserAddress(
          address: tParams.address,
          latitude: tParams.latitude,
          longitude: tParams.longitude,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository returns Failure', () async {
    // arrange
    const failure = Failure('Update failed');

    when(
      () => mockRepository.updateUserAddress(
        address: tParams.address,
        latitude: tParams.latitude,
        longitude: tParams.longitude,
      ),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Left(failure));
    verify(
      () => mockRepository.updateUserAddress(
        address: tParams.address,
        latitude: tParams.latitude,
        longitude: tParams.longitude,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
