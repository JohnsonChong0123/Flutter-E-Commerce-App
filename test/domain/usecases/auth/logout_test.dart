import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/repositories/auth_repository.dart';
import 'package:e_commerce_client/domain/usecases/auth/logout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late Logout useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = Logout(repository);
  });

  test('should return unit when repository logout succeeds', () async {
    when(() => repository.logout()).thenAnswer((_) async => const Right(unit));

    final result = await useCase(NoParams());

    expect(result, const Right(unit));
    verify(() => repository.logout()).called(1);
  });

  test('should return failure when repository logout fails', () async {
    const failure = Failure('Logout failed');
    when(
      () => repository.logout(),
    ).thenAnswer((_) async => const Left(failure));

    final result = await useCase(NoParams());

    expect(result, const Left(failure));
    verify(() => repository.logout()).called(1);
  });
}
