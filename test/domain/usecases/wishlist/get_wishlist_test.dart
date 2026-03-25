import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/repositories/wishlist_repository.dart';
import 'package:e_commerce_client/domain/usecases/wishlist/get_wishlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

import '../../../fixtures/failure_fixtures.dart';
import '../../../fixtures/wishlist/wishlist_fixtures.dart';

class MockWishlistRepository extends Mock implements WishlistRepository {}

void main() {
  late WishlistRepository mockRepository;
  late GetWishlist usecase;

  setUp(() {
    mockRepository = MockWishlistRepository();
    usecase = GetWishlist(mockRepository);
  });

  test(
    'should call repository getWishlist and return WishlistEntity on success',
    () async {
      // arrange
      when(
        () => mockRepository.getWishlist(),
      ).thenAnswer((_) async => const Right(tWishlistEntityList));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, equals(const Right(tWishlistEntityList)));
      verify(() => mockRepository.getWishlist()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository returns Failure', () async {
    // arrange
    when(
      () => mockRepository.getWishlist(),
    ).thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Left(tFailure));
    verify(() => mockRepository.getWishlist()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
