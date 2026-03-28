import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/repositories/cart_repository.dart';
import 'package:e_commerce_client/domain/usecases/cart/get_cart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

import '../../../fixtures/cart/cart_fixtures.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late CartRepository mockRepository;
  late GetCart usecase;
  
  setUp(() {
    mockRepository = MockCartRepository();
    usecase = GetCart(mockRepository);
  });

  test(
    'should call repository getCart and return CartEntity on success',
    () async {
      // arrange
      when(
        () => mockRepository.getCart(),
      ).thenAnswer((_) async => const Right(tCartEntity));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, equals(const Right(tCartEntity)));
      verify(() => mockRepository.getCart()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository returns Failure', () async {
    // arrange
    const failure = Failure('Cache or Server error');

    when(
      () => mockRepository.getCart(),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Left(failure));
    verify(() => mockRepository.getCart()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
