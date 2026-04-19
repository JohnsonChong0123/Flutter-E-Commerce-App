import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/data/repositories/product_repository_impl.dart';
import 'package:e_commerce_client/data/sources/remote/product_remote_data.dart';
import 'package:e_commerce_client/domain/entity/product/product_summary_entity.dart';
import 'package:e_commerce_client/domain/usecases/product/get_products.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import '../../fixtures/product/product_fixtures.dart';

class MockProductRemoteData extends Mock implements ProductRemoteData {}

void main() {
  late MockProductRemoteData mockProductRemoteData;
  late ProductRepositoryImpl repository;

  const tParams = GetProductsParams(
    category: 'electronics',
    limit: 10,
    page: 1,
  );

  setUp(() {
    mockProductRemoteData = MockProductRemoteData();
    repository = ProductRepositoryImpl(
      productRemoteData: mockProductRemoteData,
    );
  });

  group('getProducts', () {
    test(
      'should return Right(List<ProductSummaryEntity>) when get product succeeds',
      () async {
        // arrange
        when(
          () => mockProductRemoteData.getProducts(tParams),
        ).thenAnswer((_) async => tProductSummaryModelList);

        // act
        final result = await repository.getProducts(tParams);

        // assert
        final either = result as Right<Failure, List<ProductSummaryEntity>>;
        final products = either.value;

        expect(products.length, tProductSummaryEntityList.length);
        for (var i = 0; i < products.length; i++) {
          expect(products[i].id, tProductSummaryEntityList[i].id);
          expect(products[i].name, tProductSummaryEntityList[i].name);
          expect(
            products[i].initialPrice,
            tProductSummaryEntityList[i].initialPrice,
          );
          expect(
            products[i].finalPrice,
            tProductSummaryEntityList[i].finalPrice,
          );
          expect(products[i].imageUrl, tProductSummaryEntityList[i].imageUrl);
        }
        verify(() => mockProductRemoteData.getProducts(tParams)).called(1);
        verifyNoMoreInteractions(mockProductRemoteData);
      },
    );

    test(
      'should return Left(Failure) when get products throws ServerException',
      () async {
        // arrange
        when(
          () => mockProductRemoteData.getProducts(tParams),
        ).thenThrow(const ServerException('Failed to get products'));

        // act
        final result = await repository.getProducts(tParams);

        // assert
        expect(result, equals(left(const Failure('Failed to get products'))));
        verify(() => mockProductRemoteData.getProducts(tParams)).called(1);
      },
    );
  });

  group('getProductById', () {
    test(
      'should return Right(ProductDetailsEntity) when get product succeeds',
      () async {
        // arrange
        when(
          () => mockProductRemoteData.getProductById(tProductId),
        ).thenAnswer((_) async => tProductDetailsModel);

        // act
        final result = await repository.getProductById(tProductId);

        // assert
        expect(result, equals(right(tProductDetailsEntity)));
        verify(
          () => mockProductRemoteData.getProductById(tProductId),
        ).called(1);
        verifyNoMoreInteractions(mockProductRemoteData);
      },
    );
    test(
      'should return Left(Failure) when get product throws ServerException',
      () async {
        // arrange
        when(
          () => mockProductRemoteData.getProductById(tProductId),
        ).thenThrow(const ServerException('Failed to get product'));

        // act
        final result = await repository.getProductById(tProductId);

        // assert
        expect(result, equals(left(const Failure('Failed to get product'))));
      },
    );
  });
}
