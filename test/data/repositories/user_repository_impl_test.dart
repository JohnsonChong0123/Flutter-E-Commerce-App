import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/data/models/location_model.dart';
import 'package:e_commerce_client/data/repositories/user_repository_impl.dart';
import 'package:e_commerce_client/data/sources/remote/user_remote_data.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRemoteData extends Mock implements UserRemoteData {}

void main() {
  late MockUserRemoteData mockUserRemoteData;
  late UserRepositoryImpl repository;

  const tAddress = 'KL';
  const tLatitude = 3.14;
  const tLongitude = 101.69;

  final tLocationModel = const LocationModel(
    latitude: tLatitude,
    longitude: tLongitude,
    address: tAddress,
  );
  final tLocationEntity = tLocationModel.toEntity();

  setUp(() {
    mockUserRemoteData = MockUserRemoteData();
    repository = UserRepositoryImpl(userRemoteData: mockUserRemoteData);
  });

  group('updateUserAddress', () {
    test('should return Right(unit) on success', () async {
      // arrange
      when(
        () => mockUserRemoteData.updateUserAddress(
          address: any(named: 'address'),
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        ),
      ).thenAnswer((_) async {});

      // act
      final result = await repository.updateUserAddress(
        address: tAddress,
        latitude: tLatitude,
        longitude: tLongitude,
      );

      // assert
      expect(result, equals(right(unit)));
      verify(
        () => mockUserRemoteData.updateUserAddress(
          address: tAddress,
          latitude: tLatitude,
          longitude: tLongitude,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockUserRemoteData);
    });

    test('should return Left(Failure) when remote throws ServerException', () async {
      // arrange
      when(
        () => mockUserRemoteData.updateUserAddress(
          address: any(named: 'address'),
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        ),
      ).thenThrow(const ServerException('Update failed'));

      // act
      final result = await repository.updateUserAddress(
        address: tAddress,
        latitude: tLatitude,
        longitude: tLongitude,
      );

      // assert
      expect(result, equals(left(const Failure('Update failed'))));
      verify(
        () => mockUserRemoteData.updateUserAddress(
          address: tAddress,
          latitude: tLatitude,
          longitude: tLongitude,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockUserRemoteData);
    });
  });

  group('getUserLocation', () {
    test('should return Right(LocationEntity) on success', () async {
      // arrange
      when(() => mockUserRemoteData.getUserLocation())
          .thenAnswer((_) async => tLocationModel);

      // act
      final result = await repository.getUserLocation();

      // assert
      expect(result, equals(right(tLocationEntity)));
      verify(() => mockUserRemoteData.getUserLocation()).called(1);
      verifyNoMoreInteractions(mockUserRemoteData);
    });

    test('should return Left(Failure) when remote throws ServerException', () async {
      // arrange
      when(() => mockUserRemoteData.getUserLocation())
          .thenThrow(const ServerException('Location fetch failed'));

      // act
      final result = await repository.getUserLocation();

      // assert
      expect(
        result,
        equals(left(const Failure('Location fetch failed'))),
      );
      verify(() => mockUserRemoteData.getUserLocation()).called(1);
      verifyNoMoreInteractions(mockUserRemoteData);
    });
  });
}
