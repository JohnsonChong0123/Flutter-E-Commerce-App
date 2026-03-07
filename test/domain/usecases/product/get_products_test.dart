import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/repositories/product_repository.dart';
import 'package:e_commerce_client/domain/usecases/product/get_products.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

import '../../../fixtures/product/product_fixtures.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductRepository mockRepository;
  late GetProducts usecase;
  
  setUp(() {
    mockRepository = MockProductRepository();
    usecase = GetProducts(mockRepository);
  });

  test(
    'should call repository getProducts and return List<ProductSummaryEntity> on success',
    () async {
      // arrange
      when(
        () => mockRepository.getProducts(),
      ).thenAnswer((_) async => Right(tProductSummaryEntityList));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, Right(tProductSummaryEntityList));
      verify(() => mockRepository.getProducts()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository returns Failure', () async {
    // arrange
    const failure = Failure('Server error');

    when(
      () => mockRepository.getProducts(),
    ).thenAnswer((_) async => Left(failure));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, Left(failure));
    verify(() => mockRepository.getProducts()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
