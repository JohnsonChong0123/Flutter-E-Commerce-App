import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/repositories/product_repository.dart';
import 'package:e_commerce_client/domain/usecases/product/get_product_by_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

import '../../../fixtures/product/product_fixtures.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductRepository mockRepository;
  late GetProductById usecase;

  final tParams = GetProductByIdParams(productId: tProductId);

  setUp(() {
    mockRepository = MockProductRepository();
    usecase = GetProductById(mockRepository);
  });

  test(
    'should call repository getProductById and return ProductDetailsEntity on success',
    () async {
      // arrange
      when(
        () => mockRepository.getProductById(tProductId),
      ).thenAnswer((_) async => Right(tProductDetailsEntity));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, equals(Right(tProductDetailsEntity)));
      verify(() => mockRepository.getProductById(tProductId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository returns Failure', () async {
    // arrange
    const failure = Failure('Server error');

    when(
      () => mockRepository.getProductById(tProductId),
    ).thenAnswer((_) async => Left(failure));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result,Left(failure));
    verify(() => mockRepository.getProductById(tProductId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
