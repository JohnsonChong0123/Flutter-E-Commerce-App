import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/data/models/product/product_details_cache_model.dart';
import 'package:e_commerce_client/data/models/product/product_summary_cache_model.dart';
import 'package:e_commerce_client/data/models/money/money_model.dart';
import 'package:e_commerce_client/data/repositories/product_repository_impl.dart';
import 'package:e_commerce_client/data/sources/local/product_local_data.dart';
import 'package:e_commerce_client/data/sources/remote/product_remote_data.dart';
import 'package:e_commerce_client/domain/usecases/product/get_products.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import '../../fixtures/product/product_fixtures.dart';
import '../../fixtures/shipping/shipping_fixtures.dart';

class MockProductRemoteData extends Mock implements ProductRemoteData {}

class MockProductLocalData extends Mock implements ProductLocalData {}

void main() {
  late MockProductRemoteData mockProductRemoteData;
  late MockProductLocalData mockProductLocalData;
  late ProductRepositoryImpl repository;

  const tParams = GetProductsParams(
    category: 'electronics',
    limit: 10,
    page: 1,
  );

  const tProductSummaryCacheModelList = [
    ProductSummaryCacheModel(
      id: 'v1|377049276589|645539111213',
      title:
          'NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked',
      initialPrices: MoneyModel(value: 614.99, currency: 'USD'),
      finalPrices: MoneyModel(value: 481.99, currency: 'USD'),
      imageUrl: 'https://i.ebayimg.com/images/g/ZAIAAOSws5Nna86X/s-l225.jpg',
      cachedAt: 1697040000,
    ),
    ProductSummaryCacheModel(
      id: 'v1|386936766515|654209735321',
      title:
          'Apple iPhone 12 64/128GB - Fully Unlocked AT&T T-Mobile Verizon - All colors',
      initialPrices: null,
      finalPrices: MoneyModel(value: 219.0, currency: 'USD'),
      imageUrl: 'https://i.ebayimg.com/images/g/fe4AAOSwVkRmIHzv/s-l225.jpg',
      cachedAt: 1697040000,
    ),
  ];

  const tProductDetailsCacheModel = ProductDetailsCacheModel(
    id: "v1|377049276589|645539111213",
    title:
        "NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked",
    description:
        "🔥 NEW SEALED SAMSUNG GALAXY S23 ULTRA 5G FACTORY UNLOCKED GSM CDMA ALL MEMORY🔥 🎁【US IN STOCK🚚 Fast Delivery】 ✅Factory Unlocked 👍 ALL COLOR & MEMORY & CARRIER 🚚Free & Fast Shipping: 3-5 DAYS 💯Brand-New in Sealed Box 🤩Free Exchange in 60 days 🤝 2 Years Warranty.",
    initialPrices: MoneyModel(value: 614.99, currency: "USD"),
    finalPrices: MoneyModel(value: 481.99, currency: "USD"),
    imageUrl: "https://i.ebayimg.com/images/g/i20AAOSwvxpna86j/s-l1600.jpg",
    additionalImages: [
      "https://i.ebayimg.com/images/g/7CwAAOSwu2Zna86k/s-l1600.jpg",
      "https://i.ebayimg.com/images/g/caIAAOSwRX5na86k/s-l1600.jpg",
    ],
    localizedAspects: tLocalizedAspectsModel,
    shippingOptions: tShippingOptionModelList,
    cachedAt: 1697040000,
  );

  setUp(() {
    mockProductRemoteData = MockProductRemoteData();
    mockProductLocalData = MockProductLocalData();
    repository = ProductRepositoryImpl(
      productRemoteData: mockProductRemoteData,
      productLocalData: mockProductLocalData,
    );
  });

  group('getProducts', () {
    test(
      'should return Right(List<ProductSummaryEntity>) and cache data when remote call succeeds',
      () async {
        // arrange
        when(
          () => mockProductRemoteData.getProducts(tParams),
        ).thenAnswer((_) async => tProductSummaryModelList);

        when(
          () => mockProductLocalData.cacheProducts(tProductSummaryModelList),
        ).thenAnswer((_) async => Future.value());

        // act
        final result = await repository.getProducts(tParams);

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected Right, got Left($failure)'),
          (products) => expect(products, equals(tProductSummaryEntityList)),
        );

        verify(() => mockProductRemoteData.getProducts(tParams)).called(1);
        verify(
          () => mockProductLocalData.cacheProducts(tProductSummaryModelList),
        ).called(1);
        verifyNoMoreInteractions(mockProductRemoteData);
        verifyNoMoreInteractions(mockProductLocalData);
      },
    );

    test(
      'should return Left(Failure) when remote throws ServerException and local cache is empty',
      () async {
        // arrange
        when(
          () => mockProductRemoteData.getProducts(tParams),
        ).thenThrow(const ServerException('Failed to get products'));

        when(
          () => mockProductLocalData.getCachedProducts(
            limit: tParams.limit,
            page: tParams.page,
          ),
        ).thenAnswer((_) async => []);

        // act
        final result = await repository.getProducts(tParams);

        // assert
        expect(result, equals(left(const Failure('Failed to get products'))));

        verify(() => mockProductRemoteData.getProducts(tParams)).called(1);
        verify(
          () => mockProductLocalData.getCachedProducts(
            limit: tParams.limit,
            page: tParams.page,
          ),
        ).called(1);
      },
    );

    test(
      'should return Right(cachedProducts) when remote throws ServerException but local cache has data',
      () async {
        // arrange
        when(
          () => mockProductRemoteData.getProducts(tParams),
        ).thenThrow(const ServerException('Failed to get products'));

        when(
          () => mockProductLocalData.getCachedProducts(
            limit: tParams.limit,
            page: tParams.page,
          ),
        ).thenAnswer((_) async => tProductSummaryCacheModelList);

        // act
        final result = await repository.getProducts(tParams);

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected Right, got Left($failure)'),
          (products) => expect(products, equals(tProductSummaryEntityList)),
        );

        verify(() => mockProductRemoteData.getProducts(tParams)).called(1);
        verify(
          () => mockProductLocalData.getCachedProducts(
            limit: tParams.limit,
            page: tParams.page,
          ),
        ).called(1);
      },
    );

    test(
      'should return Left(Failure) when remote throws ServerException and local cache fetch throws CacheException',
      () async {
        // arrange
        when(
          () => mockProductRemoteData.getProducts(tParams),
        ).thenThrow(const ServerException('Server error'));

        when(
          () => mockProductLocalData.getCachedProducts(
            limit: tParams.limit,
            page: tParams.page,
          ),
        ).thenThrow(const CacheException('Failed to read cache'));

        // act
        final result = await repository.getProducts(tParams);

        // assert
        expect(result, equals(left(const Failure('Failed to read cache'))));

        verify(() => mockProductRemoteData.getProducts(tParams)).called(1);
        verify(
          () => mockProductLocalData.getCachedProducts(
            limit: tParams.limit,
            page: tParams.page,
          ),
        ).called(1);
      },
    );

    test(
      'should return Left(Failure) when caching products throws CacheException',
      () async {
        // arrange
        when(
          () => mockProductRemoteData.getProducts(tParams),
        ).thenAnswer((_) async => tProductSummaryModelList);

        when(
          () => mockProductLocalData.cacheProducts(tProductSummaryModelList),
        ).thenThrow(const CacheException('Disk full'));

        // act
        final result = await repository.getProducts(tParams);

        // assert
        expect(
          result,
          equals(left(const Failure('Local cache error: Disk full'))),
        );

        verify(() => mockProductRemoteData.getProducts(tParams)).called(1);
        verify(
          () => mockProductLocalData.cacheProducts(tProductSummaryModelList),
        ).called(1);
      },
    );

    test(
      'should return Left(Failure) when an unhandled standard exception occurs',
      () async {
        // arrange
        const unknownException = FormatException('Invalid JSON response');

        when(
          () => mockProductRemoteData.getProducts(tParams),
        ).thenThrow(unknownException);

        // act
        final result = await repository.getProducts(tParams);

        // assert
        expect(
          result,
          equals(
            left(
              const Failure(
                'Unknown error occurred: FormatException: Invalid JSON response',
              ),
            ),
          ),
        );

        verify(() => mockProductRemoteData.getProducts(tParams)).called(1);
      },
    );
  });

  group('getProductById', () {
    test(
      'should return Right(ProductDetailsEntity) and cache data when get product succeeds',
      () async {
        // arrange
        when(
          () => mockProductRemoteData.getProductById(tProductId),
        ).thenAnswer((_) async => tProductDetailsModel);

        when(
          () => mockProductLocalData.cacheProductDetails(tProductDetailsModel),
        ).thenAnswer((_) async => Future.value());

        // act
        final result = await repository.getProductById(tProductId);

        // assert
        expect(result, equals(right(tProductDetailsEntity)));
        verify(
          () => mockProductRemoteData.getProductById(tProductId),
        ).called(1);
        verify(
          () => mockProductLocalData.cacheProductDetails(tProductDetailsModel),
        ).called(1);
        verifyNoMoreInteractions(mockProductRemoteData);
      },
    );

    test(
      'should return Left(Failure) when remote throws ServerException and local cache is null',
      () async {
        // arrange
        when(
          () => mockProductRemoteData.getProductById(tProductId),
        ).thenThrow(const ServerException('Failed to get product'));
        when(
          () => mockProductLocalData.getCachedProductDetails(tProductId),
        ).thenAnswer((_) async => null);

        // act
        final result = await repository.getProductById(tProductId);

        // assert
        expect(result, equals(left(const Failure('Failed to get product'))));
        verify(
          () => mockProductRemoteData.getProductById(tProductId),
        ).called(1);
        verify(
          () => mockProductLocalData.getCachedProductDetails(tProductId),
        ).called(1);
      },
    );

    test(
      'should return Right(ProductDetailsEntity) when remote throws ServerException but local cache has data',
      () async {
        // arrange
        when(
          () => mockProductRemoteData.getProductById(tProductId),
        ).thenThrow(const ServerException('Failed to get product'));
        when(
          () => mockProductLocalData.getCachedProductDetails(tProductId),
        ).thenAnswer((_) async => tProductDetailsCacheModel);

        // act
        final result = await repository.getProductById(tProductId);

        // assert
        expect(result, equals(right(tProductDetailsEntity)));

        verify(
          () => mockProductRemoteData.getProductById(tProductId),
        ).called(1);
        verify(
          () => mockProductLocalData.getCachedProductDetails(tProductId),
        ).called(1);
      },
    );

    test(
      'should return Left(Failure) when remote throws ServerException and reading cache throws CacheException',
      () async {
        // arrange
        when(
          () => mockProductRemoteData.getProductById(tProductId),
        ).thenThrow(const ServerException('Server failure'));
        when(
          () => mockProductLocalData.getCachedProductDetails(tProductId),
        ).thenThrow(const CacheException('Read cache error'));

        // act
        final result = await repository.getProductById(tProductId);

        // assert
        expect(result, equals(left(const Failure('Read cache error'))));

        verify(
          () => mockProductRemoteData.getProductById(tProductId),
        ).called(1);
        verify(
          () => mockProductLocalData.getCachedProductDetails(tProductId),
        ).called(1);
      },
    );

    test(
      'should return Left(Failure) when caching product details throws CacheException',
      () async {
        // arrange
        when(
          () => mockProductRemoteData.getProductById(tProductId),
        ).thenAnswer((_) async => tProductDetailsModel);
        when(
          () => mockProductLocalData.cacheProductDetails(tProductDetailsModel),
        ).thenThrow(const CacheException('Write cache error'));

        // act
        final result = await repository.getProductById(tProductId);

        // assert
        expect(
          result,
          equals(left(const Failure('Local cache error: Write cache error'))),
        );

        verify(
          () => mockProductRemoteData.getProductById(tProductId),
        ).called(1);
        verify(
          () => mockProductLocalData.cacheProductDetails(tProductDetailsModel),
        ).called(1);
      },
    );

    test(
      'should return Left(Failure) when an unhandled exception occurs',
      () async {
        // arrange
        const unknownException = FormatException('Bad data format');
        when(
          () => mockProductRemoteData.getProductById(tProductId),
        ).thenThrow(unknownException);

        // act
        final result = await repository.getProductById(tProductId);

        // assert
        expect(
          result,
          equals(
            left(
              const Failure(
                'Unknown error occurred: FormatException: Bad data format',
              ),
            ),
          ),
        );

        verify(
          () => mockProductRemoteData.getProductById(tProductId),
        ).called(1);
      },
    );
  });
}
