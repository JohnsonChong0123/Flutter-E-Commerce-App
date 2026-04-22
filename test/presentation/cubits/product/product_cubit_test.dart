import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
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

  const tParams = GetProductsParams(
    category: 'electronics',
    limit: 10,
    page: 1,
  );

  const category = 'electronics';
  const limit = 10;
  const page = 1;

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
          () => mockGetProducts(tParams),
        ).thenAnswer((_) async => Right(tProductSummaryEntityList));

        return productCubit;
      },
      act: (cubit) =>
          cubit.loadProducts(category: category, limit: limit, page: page),
      expect: () => [
        ProductLoading(),
        ProductLoaded(
          products: tProductSummaryEntityList,
          filteredProducts: tProductSummaryEntityList,
        ),
      ],
      verify: (_) {
        verify(() => mockGetProducts(tParams)).called(1);
      },
    );

    blocTest<ProductCubit, ProductState>(
      'should emit [ProductLoading, ProductFailure] when get products fails',
      build: () {
        when(() => mockGetProducts(tParams)).thenAnswer(
          (_) async => const Left(Failure('Failed to load products')),
        );

        return productCubit;
      },
      act: (cubit) =>
          cubit.loadProducts(category: category, limit: limit, page: page),
      expect: () => [
        ProductLoading(),
        const ProductFailure(message: 'Failed to load products'),
      ],
      verify: (_) {
        verify(() => mockGetProducts(tParams)).called(1);
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
        verify(
          () => mockGetProductId(GetProductByIdParams(productId: tProductId)),
        ).called(1);
      },
    );

    blocTest<ProductCubit, ProductState>(
      'should emit [ProductLoading, ProductFailure] when get product by id fails',
      build: () {
        when(
          () => mockGetProductId(GetProductByIdParams(productId: tProductId)),
        ).thenAnswer(
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
        verify(
          () => mockGetProductId(GetProductByIdParams(productId: tProductId)),
        ).called(1);
      },
    );
  });

  group('filterProducts', () {
    blocTest<ProductCubit, ProductState>(
      'Should filter the products based on the query when input is not empty',
      build: () => productCubit,
      seed: () =>
          ProductLoaded(products: tProductSummaryEntityList, filteredProducts: tProductSummaryEntityList),
      act: (cubit) => cubit.filterProducts('apple'),
      expect: () => [
        ProductLoaded(
          products: tProductSummaryEntityList,
          filteredProducts: [tProductSummaryEntityList[1]],
          searchQuery: 'apple',
        ),
      ],
    );

    blocTest<ProductCubit, ProductState>(
      'Should reset the filtered products when input is an empty string',
      build: () => productCubit,
      seed: () => ProductLoaded(
        products: tProductSummaryEntityList,
        filteredProducts: [tProductSummaryEntityList[0], tProductSummaryEntityList[1]],
        searchQuery: 'apple',
      ),
      act: (cubit) => cubit.filterProducts(''),
      expect: () => [
        ProductLoaded(
          products: tProductSummaryEntityList,
          filteredProducts: tProductSummaryEntityList,
          searchQuery: '',
        ),
      ],
    );
  });

    group('applyFilters', () {
    blocTest<ProductCubit, ProductState>(
      'Should filter products that are on sale when onSale is true',
      build: () => productCubit,
      seed: () => ProductLoaded(products: tProductSummaryEntityList, filteredProducts: tProductSummaryEntityList),
      act: (cubit) => cubit.applyFilters(onSale: true),
      expect: () => [
        ProductLoaded(
          products: tProductSummaryEntityList,
          filteredProducts: [tProductSummaryEntityList[0]],
        ),
      ],
    );

    blocTest<ProductCubit, ProductState>(
      'Should filter products based on the price range (minPrice, maxPrice)',
      build: () => productCubit,
      seed: () => ProductLoaded(products: tProductSummaryEntityList, filteredProducts: tProductSummaryEntityList),
      act: (cubit) => cubit.applyFilters(minPrice: 100, maxPrice: 300),
      expect: () => [
        ProductLoaded(
          products: tProductSummaryEntityList,
          filteredProducts: [tProductSummaryEntityList[1]],
        ),
      ],
    );

    blocTest<ProductCubit, ProductState>(
      'Should apply filters while having a search query, and meet both search and filter conditions',
      build: () => productCubit,
      seed: () => ProductLoaded(
        products: tProductSummaryEntityList,
        filteredProducts: tProductSummaryEntityList,
        searchQuery: 'Apple'
      ),
      act: (cubit) => cubit.applyFilters(maxPrice: 300),
      expect: () => [
        ProductLoaded(
          products: tProductSummaryEntityList,
          filteredProducts: [tProductSummaryEntityList[1]],
          searchQuery: 'Apple',
        ),
      ],
    );
  });
}