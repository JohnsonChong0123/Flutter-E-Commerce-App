import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/repositories/wishlist_repository.dart';
import 'package:e_commerce_client/domain/usecases/wishlist/add_wishlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

import '../../../fixtures/product/product_fixtures.dart';

class MockWishlistRepository extends Mock implements WishlistRepository {}

void main() {
  late WishlistRepository mockRepository;
  late AddWishlist usecase;

  const tParams = AddWishlistParam(tProductId);

  setUp(() {
    mockRepository = MockWishlistRepository();
    usecase = AddWishlist(mockRepository);
  });

  test(
    'should call repository addWishlist and return Unit on success',
    () async {
      // arrange
      when(
        () => mockRepository.addWishlist(tParams.productId),
      ).thenAnswer((_) async => const Right(unit));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, equals(const Right(unit)));
      verify(
        () => mockRepository.addWishlist(tParams.productId),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository returns Failure', () async {
    // arrange
    const failure = Failure('Cache or Server error');

    when(
      () => mockRepository.addWishlist(tParams.productId),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Left(failure));
    verify(
      () => mockRepository.addWishlist(tParams.productId),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
