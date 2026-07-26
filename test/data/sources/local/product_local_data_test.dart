import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/models/product/product_details_cache_model.dart';
import 'package:e_commerce_client/data/models/product/product_summary_cache_model.dart';
import 'package:e_commerce_client/data/sources/local/product_local_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

import '../../../fixtures/product/product_fixtures.dart';

// Mock Database and Batch
class MockDatabase extends Mock implements Database {}

class MockBatch extends Mock implements Batch {}

void main() {
  late MockDatabase mockDatabase;
  late MockBatch mockBatch;
  late ProductLocalDataImpl productLocalData;

  setUp(() {
    mockDatabase = MockDatabase();
    mockBatch = MockBatch();
    productLocalData = ProductLocalDataImpl(database: mockDatabase);

    // Register fallback values for arguments
    registerFallbackValue(ConflictAlgorithm.replace);
  });

  group('ProductLocalDataImpl', () {
    group('cacheProducts', () {
      test(
        'should cache products in the database when called with valid data',
        () async {
          // arrange
          when(() => mockDatabase.batch()).thenReturn(mockBatch);
          when(
            () => mockBatch.insert(
              any(),
              any(),
              conflictAlgorithm: any(named: 'conflictAlgorithm'),
            ),
          ).thenReturn(mockBatch);
          when(
            () => mockBatch.commit(noResult: true),
          ).thenAnswer((_) async => []);

          // act
          // Note: In actual implementation, we'd need to inject the database
          // For now, this test demonstrates the expected structure
          await productLocalData.cacheProducts([tProductSummaryModel]);

          // assert
          verify(() => mockBatch.commit(noResult: true)).called(1);
        },
      );

      test(
        'should throw CacheException when database operation fails',
        () async {
          // arrange
          when(
            () => mockDatabase.batch(),
          ).thenThrow(Exception('Database error'));

          // act & assert
          expect(
            () => productLocalData.cacheProducts([tProductSummaryModel]),
            throwsA(isA<CacheException>()),
          );
        },
      );

      test('should handle empty products list', () async {
        // arrange
        when(() => mockDatabase.batch()).thenReturn(mockBatch);
        when(
          () => mockBatch.commit(noResult: true),
        ).thenAnswer((_) async => []);

        // act
        await productLocalData.cacheProducts([]);

        // assert
        verify(() => mockBatch.commit(noResult: true)).called(1);
      });
    });

    group('getCachedProducts', () {
      test('should return list of cached products from database', () async {
        // arrange
        final mockRows = [
          {
            'id': 'product_1',
            'title': 'Test Product',
            'initial_prices': '{"value": 614.99, "currency": "USD"}',
            'final_prices': '{"value": 499.99, "currency": "USD"}',
            'image_url': 'https://example.com/image.jpg',
            'cached_at': DateTime.now().millisecondsSinceEpoch,
          },
        ];

        when(
          () => mockDatabase.query(
            'product_summary',
            orderBy: 'cached_at DESC',
            limit: null,
            offset: null,
          ),
        ).thenAnswer((_) async => mockRows);

        // act
        final result = await productLocalData.getCachedProducts();

        // assert
        expect(result, isA<List<ProductSummaryCacheModel>>());
      });

      test('should apply pagination parameters when provided', () async {
        // arrange
        when(
          () => mockDatabase.query(
            'product_summary',
            orderBy: 'cached_at DESC',
            limit: 10,
            offset: 0,
          ),
        ).thenAnswer((_) async => []);

        // act
        await productLocalData.getCachedProducts(limit: 10, page: 1);

        // assert
        verify(
          () => mockDatabase.query(
            'product_summary',
            orderBy: 'cached_at DESC',
            limit: 10,
            offset: 0,
          ),
        ).called(1);
      });

      test('should throw CacheException when query fails', () async {
        // arrange
        when(
          () => mockDatabase.query(any()),
        ).thenThrow(Exception('Query failed'));

        // act & assert
        expect(
          () => productLocalData.getCachedProducts(),
          throwsA(isA<CacheException>()),
        );
      });

      test('should return empty list when no cached products exist', () async {
        // arrange
        when(
          () => mockDatabase.query(
            any(),
            orderBy: any(named: 'orderBy'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => []);
        // act
        final result = await productLocalData.getCachedProducts();

        // assert
        expect(result, isEmpty);
      });
    });

    group('cacheProductDetails', () {
      test('should cache product details in the database', () async {
        // arrange
        when(
          () => mockDatabase.insert(
            any(),
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          ),
        ).thenAnswer((_) async => 1);

        // act
        await productLocalData.cacheProductDetails(tProductDetailsModel);

        // assert
        verify(
          () => mockDatabase.insert(
            'product_details',
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          ),
        ).called(1);
      });

      test('should throw CacheException when insert operation fails', () async {
        // arrange
        when(
          () => mockDatabase.insert(
            any(),
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          ),
        ).thenThrow(Exception('Insert failed'));

        // act & assert
        expect(
          () => productLocalData.cacheProductDetails(tProductDetailsModel),
          throwsA(isA<CacheException>()),
        );
      });
    });

    group('getCachedProductDetails', () {
      test('should return cached product details by id', () async {
        // arrange
        final mockRows = [
          {
            'id': 'product_1',
            'title': 'Test Product',
            'description': 'Test Description',
            'initial_prices': '{"value": 614.99, "currency": "USD"}',
            'final_prices': '{"value": 499.99, "currency": "USD"}',
            'image_url': 'https://example.com/image.jpg',
            'additional_images':
                '["https://example.com/image1.jpg", "https://example.com/image2.jpg"]',
            'localized_aspects':
                '[{"type": "STRING", "name": "Lock Status", "value": "T-Mobile Unlocked"}]',
            'shipping_options':
                '[{"shippingServiceCode": "Standard Shipping", "type": "Standard Shipping", "shippingCost": {"value": 0.00, "currency": "USD"}, "additionalShippingCostPerUnit": {"value": 0.00, "currency": "USD"}, "shippingCostType": "FIXED"}]',
            'cached_at': DateTime.now().millisecondsSinceEpoch,
          },
        ];

        when(
          () => mockDatabase.query(
            'product_details',
            where: 'id = ?',
            whereArgs: ['product_1'],
            limit: 1,
          ),
        ).thenAnswer((_) async => mockRows);

        // act
        final result = await productLocalData.getCachedProductDetails(
          'product_1',
        );

        // assert
        expect(result, isA<ProductDetailsCacheModel>());
        expect(result?.id, 'product_1');
      });

      test('should return null when product details not found', () async {
        // arrange
        when(
          () => mockDatabase.query(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => []);

        // act
        final result = await productLocalData.getCachedProductDetails(
          'nonexistent',
        );

        // assert
        expect(result, isNull);
      });

      test('should throw CacheException when query fails', () async {
        // arrange
        when(
          () => mockDatabase.query(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
            limit: any(named: 'limit'),
          ),
        ).thenThrow(Exception('Query failed'));

        // act & assert
        expect(
          () => productLocalData.getCachedProductDetails('product_1'),
          throwsA(isA<CacheException>()),
        );
      });
    });

    group('clearCachedProducts', () {
      test('should delete all product summary records from database', () async {
        // arrange
        when(
          () => mockDatabase.delete('product_summary'),
        ).thenAnswer((_) async => 5);

        // act
        await productLocalData.clearCachedProducts();

        // assert
        verify(() => mockDatabase.delete('product_summary')).called(1);
      });

      test('should throw CacheException when delete operation fails', () async {
        // arrange
        when(
          () => mockDatabase.delete('product_summary'),
        ).thenThrow(Exception('Delete failed'));

        // act & assert
        expect(
          () => productLocalData.clearCachedProducts(),
          throwsA(isA<CacheException>()),
        );
      });
    });

    group('clearCachedProductDetails', () {
      test('should delete all product details records from database', () async {
        // arrange
        when(
          () => mockDatabase.delete('product_details'),
        ).thenAnswer((_) async => 3);

        // act
        await productLocalData.clearCachedProductDetails();

        // assert
        verify(() => mockDatabase.delete('product_details')).called(1);
      });

      test('should throw CacheException when delete operation fails', () async {
        // arrange
        when(
          () => mockDatabase.delete('product_details'),
        ).thenThrow(Exception('Delete failed'));

        // act & assert
        expect(
          () => productLocalData.clearCachedProductDetails(),
          throwsA(isA<CacheException>()),
        );
      });
    });
  });
}
