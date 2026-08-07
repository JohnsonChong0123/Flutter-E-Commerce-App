import 'dart:convert';

import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/sources/local/cart_local_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

import '../../../fixtures/cart/cart_fixtures.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  late MockDatabase mockDatabase;
  late CartLocalDataImpl cartLocalData;

  setUp(() {
    mockDatabase = MockDatabase();
    cartLocalData = CartLocalDataImpl(database: mockDatabase);
  });

  group('cacheCart', () {
    test('should cache cart data in the database', () async {
      when(
        () => mockDatabase.insert(
          any(),
          any(),
          conflictAlgorithm: any(named: 'conflictAlgorithm'),
        ),
      ).thenAnswer((_) async => 1);

      await cartLocalData.cacheCart(tCartModel);

      verify(
        () => mockDatabase.insert(
          'cart_cache',
          any(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ),
      ).called(1);
    });

    test('should throw CacheException when insert fails', () async {
      when(
        () => mockDatabase.insert(
          any(),
          any(),
          conflictAlgorithm: any(named: 'conflictAlgorithm'),
        ),
      ).thenThrow(Exception('Insert failed'));

      expect(
        () => cartLocalData.cacheCart(tCartModel),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('getLastCart', () {
    test('should return the latest cached cart', () async {
      final mockRows = [
        {
          'id': tCartModel.id,
          'cart_json': jsonEncode(tCartModel.toJson()),
          'cached_at': DateTime.now().millisecondsSinceEpoch,
        },
      ];

      when(
        () => mockDatabase.query(
          'cart_cache',
          orderBy: 'cached_at DESC',
          limit: 1,
        ),
      ).thenAnswer((_) async => mockRows);

      final result = await cartLocalData.getLastCart();

      expect(result, equals(tCartModel));
    });

    test('should throw CacheException when cache is empty', () async {
      when(
        () => mockDatabase.query(
          'cart_cache',
          orderBy: 'cached_at DESC',
          limit: 1,
        ),
      ).thenAnswer((_) async => []);

      expect(() => cartLocalData.getLastCart(), throwsA(isA<CacheException>()));
    });
  });

  group('clearCartCache', () {
    test('should clear cached cart rows', () async {
      when(() => mockDatabase.delete('cart_cache')).thenAnswer((_) async => 1);

      await cartLocalData.clearCartCache();

      verify(() => mockDatabase.delete('cart_cache')).called(1);
    });
  });
}
