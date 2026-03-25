import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/repositories/wishlist_repository.dart';
import 'package:e_commerce_client/domain/usecases/wishlist/clear_wishlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

class MockWishlistRepository extends Mock implements WishlistRepository {}

void main() {
  late WishlistRepository mockRepository;
  late ClearWishlist usecase;

  setUp(() {
    mockRepository = MockWishlistRepository();
    usecase = ClearWishlist(mockRepository);
  });

  test('should call repository clearWishlist and return Unit on success', () async {
    // arrange
    when(
      () => mockRepository.clearWishlist(),
    ).thenAnswer((_) async => const Right(unit));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, equals(const Right(unit)));
    verify(() => mockRepository.clearWishlist()).called(1);
  });

  test('should return Failure when repository returns Failure', () async {
    // arrange
    const failure = Failure('Cache or Server error');

    when(
      () => mockRepository.clearWishlist(),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Left(failure));
    verify(() => mockRepository.clearWishlist()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
