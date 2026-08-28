import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/entity/location_entity.dart';
import 'package:e_commerce_client/domain/repositories/user_repository.dart';
import 'package:e_commerce_client/domain/usecases/user/get_user_location.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockRepository;
  late GetUserLocation usecase;

  const tLatitude = 3.14;
  const tLongitude = 101.69;
  const tAddress = 'KL';

  const tLocationEntity = LocationEntity(
    address: tAddress,
    latitude: tLatitude,
    longitude: tLongitude,
  );

  setUp(() {
    mockRepository = MockUserRepository();
    usecase = GetUserLocation(mockRepository);
  });

  test(
    'should call repository getUserLocation and return LocationEntity on success',
    () async {
      // arrange
      when(() => mockRepository.getUserLocation())
          .thenAnswer((_) async => const Right(tLocationEntity));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Right(tLocationEntity));
      verify(() => mockRepository.getUserLocation()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository returns Failure', () async {
    // arrange
    const failure = Failure('Location fetch failed');

    when(() => mockRepository.getUserLocation())
        .thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Left(failure));
    verify(() => mockRepository.getUserLocation()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
