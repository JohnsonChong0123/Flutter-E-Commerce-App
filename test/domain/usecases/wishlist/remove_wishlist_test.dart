import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/repositories/wishlist_repository.dart';
import 'package:e_commerce_client/domain/usecases/wishlist/remove_wishlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

import '../../../fixtures/product/product_fixtures.dart';

class MockWishlistRepository extends Mock implements WishlistRepository {}

void main() {
  late WishlistRepository mockRepository;
  late RemoveWishlist usecase;

  const tParams = RemoveWishlistParams(tProductId);

  setUp(() {
    mockRepository = MockWishlistRepository();
    usecase = RemoveWishlist(mockRepository);
  });

  test(
    'should call repository removeWishlist and return Unit on success',
    () async {
      // arrange
      when(
        () => mockRepository.removeWishlist(tParams.productId),
      ).thenAnswer((_) async => const Right(unit));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, equals(const Right(unit)));
      verify(
        () => mockRepository.removeWishlist(tParams.productId),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository returns Failure', () async {
    // arrange
    const failure = Failure('Cache or Server error');

    when(
      () => mockRepository.removeWishlist(tParams.productId),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Left(failure));
    verify(
      () => mockRepository.removeWishlist(tParams.productId),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
