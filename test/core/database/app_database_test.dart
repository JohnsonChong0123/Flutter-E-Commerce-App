import 'dart:convert';

import 'package:e_commerce_client/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Map<String, Object?> buildSummaryRow({
  String id = 'v1|377049276589|645539111213',
  Object? title =
      'NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked',
  String? initialPrices,
  String? finalPrices,
  String imageUrl =
      'https://i.ebayimg.com/images/g/ZAIAAOSws5Nna86X/s-l225.jpg',
  int? cachedAt,
}) {
  return {
    'id': id,
    'title': title,
    'initial_prices':
        initialPrices ?? jsonEncode({'value': 614.99, 'currency': 'USD'}),
    'final_prices':
        finalPrices ?? jsonEncode({'value': 481.99, 'currency': 'USD'}),
    'image_url': imageUrl,
    'cached_at': cachedAt ?? DateTime.now().millisecondsSinceEpoch,
  };
}

Map<String, Object?> buildDetailsRow({
  String id = 'v1|377049276589|645539111213',
  Object? title =
      'NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked',
  String? description =
      "🔥 NEW SEALED SAMSUNG GALAXY S23 ULTRA 5G FACTORY UNLOCKED GSM CDMA ALL MEMORY🔥",
  String? initialPrices,
  String? finalPrices,
  String? imageUrl =
      'https://i.ebayimg.com/images/g/ZAIAAOSws5Nna86X/s-l225.jpg',
  String? additionalImages,
  String? localAspect,
  String? shippingOption,
  int? cachedAt,
}) {
  return {
    'id': id,
    'title': title,
    'description': description,
    'initial_prices':
        initialPrices ?? jsonEncode({'value': 614.99, 'currency': 'USD'}),
    'final_prices':
        finalPrices ?? jsonEncode({'value': 481.99, 'currency': 'USD'}),
    'image_url': imageUrl,
    'additional_images':
        additionalImages ??
        jsonEncode([
          'https://i.ebayimg.com/images/g/ZAIAAOSws5Nna86X/s-l500.jpg',
          'https://i.ebayimg.com/images/g/extra_img2.jpg',
        ]),
    'localized_aspects':
        localAspect ??
        jsonEncode({
          'type': "STRING",
          'name': "Lock Status",
          'value': "T-Mobile Unlocked",
        }),
    'shipping_options':
        shippingOption ??
        jsonEncode({
          'shippingServiceCode': "Standard Shipping",
          'type': "Standard Shipping",
          'shippingCost': {'value': 0.00, 'currency': 'USD'},
          'additionalShippingCostPerUnit': {'value': 0.00, 'currency': 'USD'},
          'shippingCostType': "FIXED",
        }),
    'cached_at': cachedAt ?? DateTime.now().millisecondsSinceEpoch,
  };
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    await AppDatabase.initForTest();
  });

  tearDown(() async {
    await AppDatabase.reset();
  });

  group('Initialization', () {
    test('should return an open Database instance', () async {
      final db = await AppDatabase.database;
      expect(db.isOpen, isTrue);
    });

    test(
      'should return the same instance on multiple calls (singleton)',
      () async {
        final db1 = await AppDatabase.database;
        final db2 = await AppDatabase.database;
        expect(identical(db1, db2), isTrue);
      },
    );
  });

  group('Table structure - product_summary', () {
    test('should contain product_summary table', () async {
      final db = await AppDatabase.database;
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='product_summary'",
      );
      expect(tables, isNotEmpty);
    });

    test('should contain all required columns', () async {
      final db = await AppDatabase.database;
      final info = await db.rawQuery('PRAGMA table_info(product_summary)');
      final columns = info.map((e) => e['name'] as String).toSet();
      expect(
        columns,
        containsAll([
          'id',
          'title',
          'initial_prices',
          'final_prices',
          'image_url',
          'cached_at',
        ]),
      );
    });

    test('id should be PRIMARY KEY', () async {
      final db = await AppDatabase.database;
      final info = await db.rawQuery('PRAGMA table_info(product_summary)');
      final pk = info.firstWhere((e) => e['name'] == 'id');
      expect(pk['pk'], equals(1));
    });

    test(
      'id, title, image_url, initial_prices and final_prices column type should be TEXT',
      () async {
        final db = await AppDatabase.database;
        final info = await db.rawQuery('PRAGMA table_info(product_summary)');
        final id = info.firstWhere((e) => e['name'] == 'id');
        final title = info.firstWhere((e) => e['name'] == 'title');
        final imageUrl = info.firstWhere((e) => e['name'] == 'image_url');
        final initialPrice = info.firstWhere(
          (e) => e['name'] == 'initial_prices',
        );
        final finalPrice = info.firstWhere((e) => e['name'] == 'final_prices');
        expect(id['type'], equals('TEXT'));
        expect(title['type'], equals('TEXT'));
        expect(imageUrl['type'], equals('TEXT'));
        expect(initialPrice['type'], equals('TEXT'));
        expect(finalPrice['type'], equals('TEXT'));
      },
    );

    test('cached_at column type should be INTEGER', () async {
      final db = await AppDatabase.database;
      final info = await db.rawQuery('PRAGMA table_info(product_summary)');
      final cachedAt = info.firstWhere((e) => e['name'] == 'cached_at');
      expect(cachedAt['type'], equals('INTEGER'));
    });
  });

  group('Table structure - product_details', () {
    test('should contain product_details table', () async {
      final db = await AppDatabase.database;
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='product_details'",
      );
      expect(tables, isNotEmpty);
    });

    test('should contain all required columns', () async {
      final db = await AppDatabase.database;
      final info = await db.rawQuery('PRAGMA table_info(product_details)');
      final columns = info.map((e) => e['name'] as String).toSet();
      expect(
        columns,
        containsAll([
          'id',
          'description',
          'title',
          'initial_prices',
          'final_prices',
          'image_url',
          'cached_at',
        ]),
      );
    });

    test('id should be PRIMARY KEY', () async {
      final db = await AppDatabase.database;
      final info = await db.rawQuery('PRAGMA table_info(product_details)');
      final pk = info.firstWhere((e) => e['name'] == 'id');
      expect(pk['pk'], equals(1));
    });

    test(
      'title, description, image_url, initial_prices, final_prices, additional_images, localized_aspects and shipping_options column type should be TEXT',
      () async {
        final db = await AppDatabase.database;
        final info = await db.rawQuery('PRAGMA table_info(product_details)');
        final title = info.firstWhere((e) => e['name'] == 'title');
        final description = info.firstWhere((e) => e['name'] == 'description');
        final imageUrl = info.firstWhere((e) => e['name'] == 'image_url');
        final initialPrice = info.firstWhere(
          (e) => e['name'] == 'initial_prices',
        );
        final finalPrice = info.firstWhere((e) => e['name'] == 'final_prices');
        final additionalImages = info.firstWhere(
          (e) => e['name'] == 'additional_images',
        );
        final localizedAspect = info.firstWhere(
          (e) => e['name'] == 'localized_aspects',
        );
        final shippingOptions = info.firstWhere(
          (e) => e['name'] == 'shipping_options',
        );
        expect(title['type'], equals('TEXT'));
        expect(description['type'], equals('TEXT'));
        expect(imageUrl['type'], equals('TEXT'));
        expect(initialPrice['type'], equals('TEXT'));
        expect(finalPrice['type'], equals('TEXT'));
        expect(additionalImages['type'], equals('TEXT'));
        expect(localizedAspect['type'], equals('TEXT'));
        expect(shippingOptions['type'], equals('TEXT'));
      },
    );

    test('cached_at column type should be INTEGER', () async {
      final db = await AppDatabase.database;
      final info = await db.rawQuery('PRAGMA table_info(product_details)');
      final cachedAt = info.firstWhere((e) => e['name'] == 'cached_at');
      expect(cachedAt['type'], equals('INTEGER'));
    });
  });

  group('CRUD - product_summary', () {
    test('should insert and query a product_summary', () async {
      final db = await AppDatabase.database;

      await db.insert('product_summary', buildSummaryRow());

      final rows = await db.query(
        'product_summary',
        where: 'id = ?',
        whereArgs: ['v1|377049276589|645539111213'],
      );
      expect(rows.length, equals(1));
      expect(
        rows.first['title'],
        equals(
          'NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked',
        ),
      );
      final initialPriceMap =
          jsonDecode(rows.first['initial_prices'] as String)
              as Map<String, dynamic>;
      final finalPriceMap =
          jsonDecode(rows.first['final_prices'] as String)
              as Map<String, dynamic>;
      expect(initialPriceMap['value'], equals(614.99));
      expect(finalPriceMap['value'], equals(481.99));
      expect(
        rows.first['image_url'],
        equals('https://i.ebayimg.com/images/g/ZAIAAOSws5Nna86X/s-l225.jpg'),
      );
    });

    test('should throw when title is NULL', () async {
      final db = await AppDatabase.database;
      expect(
        () => db.insert('product_summary', buildSummaryRow(title: null)),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('should throw on duplicate id', () async {
      final db = await AppDatabase.database;
      await db.insert('product_summary', buildSummaryRow());
      expect(
        () => db.insert('product_summary', buildSummaryRow()),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('should update a product_summary', () async {
      final db = await AppDatabase.database;
      await db.insert('product_summary', buildSummaryRow());
      await db.update(
        'product_summary',
        {
          'title':
              'SAURA LIFE SCIENCE Adivasi Ayurvedic Neelgiri Hair growth Hair Oil-250ML (2)',
        },
        where: 'id = ?',
        whereArgs: ['v1|377049276589|645539111213'],
      );

      final rows = await db.query(
        'product_summary',
        where: 'id = ?',
        whereArgs: ['v1|377049276589|645539111213'],
      );
      expect(
        rows.first['title'],
        equals(
          'SAURA LIFE SCIENCE Adivasi Ayurvedic Neelgiri Hair growth Hair Oil-250ML (2)',
        ),
      );
    });

    test('should delete a product_summary', () async {
      final db = await AppDatabase.database;
      await db.insert('product_summary', buildSummaryRow());
      await db.delete(
        'product_summary',
        where: 'id = ?',
        whereArgs: ['v1|377049276589|645539111213'],
      );

      final rows = await db.query(
        'product_summary',
        where: 'id = ?',
        whereArgs: ['v1|377049276589|645539111213'],
      );
      expect(rows, isEmpty);
    });
  });

  group('CRUD - product_details', () {
    test('should insert and query a product_details', () async {
      final db = await AppDatabase.database;

      await db.insert('product_details', buildDetailsRow());

      final rows = await db.query(
        'product_details',
        where: 'id = ?',
        whereArgs: ['v1|377049276589|645539111213'],
      );
      expect(rows.length, equals(1));
      expect(
        rows.first['title'],
        equals(
          'NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked',
        ),
      );
      final initialPriceMap =
          jsonDecode(rows.first['initial_prices'] as String)
              as Map<String, dynamic>;
      final finalPriceMap =
          jsonDecode(rows.first['final_prices'] as String)
              as Map<String, dynamic>;
      expect(initialPriceMap['value'], equals(614.99));
      expect(finalPriceMap['value'], equals(481.99));
      expect(
        rows.first['image_url'],
        equals('https://i.ebayimg.com/images/g/ZAIAAOSws5Nna86X/s-l225.jpg'),
      );
      final images =
          jsonDecode(rows.first['additional_images'] as String)
              as List<dynamic>;
      expect(images.length, equals(2));
      expect(images.first, contains('s-l500.jpg'));

      final aspect =
          jsonDecode(rows.first['localized_aspects'] as String)
              as Map<String, dynamic>;
      expect(aspect['name'], equals('Lock Status'));
      expect(aspect['value'], equals('T-Mobile Unlocked'));

      final shipping =
          jsonDecode(rows.first['shipping_options'] as String)
              as Map<String, dynamic>;
      expect(shipping['type'], equals('Standard Shipping'));
      final shippingCostMap = shipping['shippingCost'] as Map<String, dynamic>;
      expect(shippingCostMap['value'], equals(0.0));
      expect(shippingCostMap['currency'], equals('USD'));
    });

    test('should throw when title is NULL', () async {
      final db = await AppDatabase.database;

      expect(
        () => db.insert('product_details', buildDetailsRow(title: null)),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('should throw on duplicate id', () async {
      final db = await AppDatabase.database;
      await db.insert('product_details', buildDetailsRow());
      expect(
        () => db.insert('product_details', buildDetailsRow()),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('should update a product_details', () async {
      final db = await AppDatabase.database;

      await db.insert('product_details', buildDetailsRow());

      await db.update(
        'product_details',
        {
          'title':
              'SAURA LIFE SCIENCE Adivasi Ayurvedic Neelgiri Hair growth Hair Oil-250ML (2)',
        },
        where: 'id = ?',
        whereArgs: ['v1|377049276589|645539111213'],
      );

      final rows = await db.query(
        'product_details',
        where: 'id = ?',
        whereArgs: ['v1|377049276589|645539111213'],
      );
      expect(
        rows.first['title'],
        equals(
          'SAURA LIFE SCIENCE Adivasi Ayurvedic Neelgiri Hair growth Hair Oil-250ML (2)',
        ),
      );
    });

    test('should delete a product_details', () async {
      final db = await AppDatabase.database;
      await db.insert('product_details', buildDetailsRow());
      await db.delete(
        'product_details',
        where: 'id = ?',
        whereArgs: ['v1|377049276589|645539111213'],
      );

      final rows = await db.query(
        'product_details',
        where: 'id = ?',
        whereArgs: ['v1|377049276589|645539111213'],
      );
      expect(rows, isEmpty);
    });
  });
}
