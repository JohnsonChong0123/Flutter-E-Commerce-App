import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/usecases/product/get_product_by_id.dart';
import 'package:e_commerce_client/domain/usecases/product/get_products.dart';
import 'package:e_commerce_client/presentation/cubits/product/product_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/product/product_fixtures.dart';

class MockGetProducts extends Mock implements GetProducts {}

class MockGetProductId extends Mock implements GetProductById {}

void main() {
  late MockGetProducts mockGetProducts;
  late MockGetProductId mockGetProductId;
  late ProductCubit productCubit;
  
  setUp(() {
    mockGetProducts = MockGetProducts();
    mockGetProductId = MockGetProductId();
    productCubit = ProductCubit(
      getProducts: mockGetProducts,
      getProductById: mockGetProductId,
    );
  });

  group('loadProducts', () {
    blocTest<ProductCubit, ProductState>(
      'should emit [ProductLoading, ProductLoaded] when get products succeeds',
      build: () {
        when(
          () => mockGetProducts(NoParams()),
        ).thenAnswer((_) async => Right(tProductSummaryEntityList));

        return productCubit;
      },
      act: (cubit) => cubit.loadProducts(),
      expect: () => [
        ProductLoading(),
        ProductLoaded(products: tProductSummaryEntityList),
      ],
      verify: (_) {
        verify(() => mockGetProducts(NoParams())).called(1);
      },
    );

    blocTest<ProductCubit, ProductState>(
      'should emit [ProductLoading, ProductFailure] when get products fails',
      build: () {
        when(() => mockGetProducts(NoParams())).thenAnswer(
          (_) async => const Left(Failure('Failed to load products')),
        );

        return productCubit;
      },
      act: (cubit) => cubit.loadProducts(),
      expect: () => [
        ProductLoading(),
        const ProductFailure(message: 'Failed to load products'),
      ],
      verify: (_) {
        verify(() => mockGetProducts(NoParams())).called(1);
      },
    );
  });

  group('loadProductById', () {
    blocTest<ProductCubit, ProductState>(
      'should emit [ProductLoading, ProductDetailsLoaded] when get product by id succeeds',
      build: () {
        when(
          () => mockGetProductId(GetProductByIdParams(productId: tProductId)),

        ).thenAnswer((_) async => Right(tProductDetailsEntity));

        return productCubit;
      },
      act: (cubit) => cubit.loadProductById(tProductId),
      expect: () => [
        ProductLoading(),
        ProductDetailsLoaded(product: tProductDetailsEntity),
      ],
      verify: (_) {
        verify(() => mockGetProductId(GetProductByIdParams(productId: tProductId))).called(1);
      },
    );

    blocTest<ProductCubit, ProductState>(
      'should emit [ProductLoading, ProductFailure] when get product by id fails',
      build: () {
        when(() => mockGetProductId(GetProductByIdParams(productId: tProductId))).thenAnswer(
          (_) async => const Left(Failure('Failed to load product details')),
        );

        return productCubit;
      },
      act: (cubit) => cubit.loadProductById(tProductId),
      expect: () => [
        ProductLoading(),
        const ProductFailure(message: 'Failed to load product details'),
      ],
      verify: (_) {
        verify(() => mockGetProductId(GetProductByIdParams(productId: tProductId))).called(1);
      },
    );
  });
}
