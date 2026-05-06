import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/repositories/cart_repository.dart';
import 'package:e_commerce_client/domain/usecases/cart/update_cart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

import '../../../fixtures/product/product_fixtures.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late CartRepository mockRepository;
  late UpdateCart usecase;

  const tQuantity = 1;
  const tParams = UpdateCartParams(productId: tProductId, quantity: tQuantity);

  setUp(() {
    mockRepository = MockCartRepository();
    usecase = UpdateCart(mockRepository);
  });

  test('should call repository updateCart and return Unit on success', () async {
    // arrange
    when(
      () => mockRepository.updateCart(
        productId: tParams.productId,
        quantity: tParams.quantity,
      ),
    ).thenAnswer((_) async => const Right(unit));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, equals(const Right(unit)));
    verify(
      () => mockRepository.updateCart(
        productId: tParams.productId,
        quantity: tParams.quantity,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository returns Failure', () async {
    // arrange
    const failure = Failure('Cache or Server error');

    when(
      () => mockRepository.updateCart(
        productId: tParams.productId,
        quantity: tParams.quantity,
      ),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Left(failure));
    verify(
      () => mockRepository.updateCart(
        productId: tParams.productId,
        quantity: tParams.quantity,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
