import 'package:e_commerce_client/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
          'rating',
          'reviews_count',
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

    test('title and image_url column type should be TEXT', () async {
      final db = await AppDatabase.database;
      final info = await db.rawQuery('PRAGMA table_info(product_summary)');
      final title = info.firstWhere((e) => e['name'] == 'title');
      final imageUrl = info.firstWhere((e) => e['name'] == 'image_url');
      expect(title['type'], equals('TEXT'));
      expect(imageUrl['type'], equals('TEXT'));
    });

    test(
      'initial_prices, final_prices and rating column type should be REAL',
      () async {
        final db = await AppDatabase.database;
        final info = await db.rawQuery('PRAGMA table_info(product_summary)');
        final initialPrice = info.firstWhere(
          (e) => e['name'] == 'initial_prices',
        );
        final finalPrice = info.firstWhere((e) => e['name'] == 'final_prices');
        final rating = info.firstWhere((e) => e['name'] == 'rating');
        expect(initialPrice['type'], equals('REAL'));
        expect(finalPrice['type'], equals('REAL'));
        expect(rating['type'], equals('REAL'));
      },
    );

    test('reviews_count and cached_at column type should be INTEGER', () async {
      final db = await AppDatabase.database;
      final info = await db.rawQuery('PRAGMA table_info(product_summary)');
      final reviewsCount = info.firstWhere((e) => e['name'] == 'reviews_count');
      final cachedAt = info.firstWhere((e) => e['name'] == 'cached_at');
      expect(reviewsCount['type'], equals('INTEGER'));
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
      'title, description and image_url column type should be TEXT',
      () async {
        final db = await AppDatabase.database;
        final info = await db.rawQuery('PRAGMA table_info(product_details)');
        final title = info.firstWhere((e) => e['name'] == 'title');
        final description = info.firstWhere((e) => e['name'] == 'description');
        final imageUrl = info.firstWhere((e) => e['name'] == 'image_url');
        expect(title['type'], equals('TEXT'));
        expect(description['type'], equals('TEXT'));
        expect(imageUrl['type'], equals('TEXT'));
      },
    );

    test(
      'initial_prices and final_prices column type should be REAL',
      () async {
        final db = await AppDatabase.database;
        final info = await db.rawQuery('PRAGMA table_info(product_summary)');
        final initialPrice = info.firstWhere(
          (e) => e['name'] == 'initial_prices',
        );
        final finalPrice = info.firstWhere((e) => e['name'] == 'final_prices');
        final rating = info.firstWhere((e) => e['name'] == 'rating');
        expect(initialPrice['type'], equals('REAL'));
        expect(finalPrice['type'], equals('REAL'));
        expect(rating['type'], equals('REAL'));
      },
    );

    test('cached_at column type should be INTEGER', () async {
      final db = await AppDatabase.database;
      final info = await db.rawQuery('PRAGMA table_info(product_summary)');
      final cachedAt = info.firstWhere((e) => e['name'] == 'cached_at');
      expect(cachedAt['type'], equals('INTEGER'));
    });
  });

  group('Foreign key constraints', () {
    test('foreign key should be enabled', () async {
      final db = await AppDatabase.database;

      final result = await db.rawQuery('PRAGMA foreign_keys');

      expect(result.first.values.first, 1);
    });

    test('should throw when inserting product_details with unknown id', () async {
      final db = await AppDatabase.database;
      expect(
        db.insert('product_details', {
          'id': 'B07V5LK5J3',
          'title':
              'TWINSLUXES Solar Post Cap Lights Outdoor - Waterproof LED Fence Post Solar Lights for 3.5x3.5/4x4/5x5 Wood Posts in Patio, Deck or Garden Decoration 4 Pack',
          'description':
              'Solar Post Cap Lights Waterproof LED Fence Post Solar Lights for 3.5x3.5 4x4 5x5 Wooden Posts. FEATURES & DETAILS   Product Specification Material: ABS Power Source: Solar-powered Lumens: 20 Lumens Color temperature: 3000k Light color: warm white LED: SMD 2835 0.5W *1 PCS Waterproof level: IP65 Battery: 600mah batteries Package Contents 1 x Solar post light 1 x Instruction Manual 1 x Installing Screw Set PERFECT FIT Fits wooden posts,vinyl posts or PVC posts The fence post lights solar powered is flexible and ingenious designed that this solar fence post lights can be easily installed on different inches of wooden or PVC vinyl columns. Ideal for patio, deck and garden decoration practical and beautiful Warm white LED makes the solar fence post lights well at night. How do solar deck post lights work? It’s very simple. You mount post lights solar powered on posts that you stake into the ground, and during the day the solar panel atop of the lights collects rays from the sun, charging the battery within so that energy can be utilized as light when it gets dark. The solar fence post lights 4x4 have an internal light sensor so that this deck lights can turn on automatically at dusk, and off at dawn. How to use solar post lights？ Quick and easy Do It Yourself installation. Easy screw-down installation, all you have to do is mark a couple holes, and drill down to stabilize the fence post solar lights. Plastic housing and lens, both are waterproof and will withstand all weather conditions.     TWINSLUXES, developed since 1986, is a professional manufacturer of solar lights, with CCC, CQC, CE, SAA, UL, GS, ROHS, REACH, PAHS and other international authoritative quality certifications TWINSLUXES Solar Post Lights Outdoor In the Darkness If the surrounder of the solar post cap is full of artificial light on night, that it will not turn on. Because these post cap solar lights depend on the weak light to determine whether it is nighttime or not. So you\'d better moving fence solar lights to darker areas. Cleaning Dirty Solar Panels The solar panels will collect dirt and grime over time, then they can not receive sunlight efficiently as before. Remove any debris that has collected with a smooth wet cloth. If the 4x4 post solar lights doesn\'t light up,check whether the battery is fixed and whether the battery is normal Be sure the post cap lights is in a relatively sunny location. 30 days free return   The deck post lights are beautiful, exquisite and practical. Unique appearance post solar lights, with warm and comfortable light, suit your deck post. It also enriches the mood for night walking and provides convenience.       Unique Outdoor Decoration   The Designed Glass Ball   Turn It ON/ OFF       DIY Installation outdoor solar lights effective IP44 waterproof and heat-resistant . You can install on wood,post, in patio, deck,mailbox or garden . Even in the daytime, it is the best decoration. High Efficiency Reflector TWINSLUXES solar fence post light are of high transmittance. Has a unique appearance and distinctive crack effect Automatically turns on at dusk, off at dawn. Solar Powered The top polysilicon solar panel uses the natural power of the sun to charge the internal 1.2v Ni-MH AA rechargeable battery. No extra wiring required, and the brilliant LEDs are long lasting and energy efficient. Solar Pathway Lights Color Changing Solar Post Cap Lights Outdoor Flickering Flame for 3.5x3.5/4x4/5x5 Yard Deck Solar Garden Lights Outdoor Twinsluxes 2 Color modes Solar Post Lights for 3.5x3.5/4x4/5x5 and larger size Solar Garden Lights Outdoor Size Conventional 3.5x3.5/4x4/5x5 Conventional 3.5x3.5/4x4/5x5 and larger size Conventional Brightness 15lm 15lm 10lm 25lm 15lm Waterproof Grade IP44 IP44 IP44 IP44 IP44 Applicable scene Pathway/Sidewalk/ Lawn/Patio/Yard Post/Deck/Fence/Dock/Garden/ Patio/ Gate/ Pathway/Sidewalk/ Lawn/Patio/Yard Post/Deck/Fence/Dock/Garden/ Patio/ Gate/ Pathway/Sidewalk/ Lawn/Patio/Yard Color Cold Light/Color Changing Flame flicker Warm/Cold Light White light/Warm light Warm/Cold Light',
          'initial_prices': 49.99,
          'final_prices': 33.99,
          'image_url':
              'https://m.media-amazon.com/images/I/71kCgl9yzzL.__AC_SY445_SX342_QL70_FMwebp_.jpg',
          'cached_at': DateTime.now().millisecondsSinceEpoch,
        }),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('should succeed when product exists first', () async {
      final db = await AppDatabase.database;

      await db.insert('product_summary', {
        'id': 'B07V5LK5J3',
        'title':
            'TWINSLUXES Solar Post Cap Lights Outdoor - Waterproof LED Fence Post Solar Lights for 3.5x3.5/4x4/5x5 Wood Posts in Patio, Deck or Garden Decoration 4 Pack',
        'initial_prices': 49.99,
        'final_prices': 33.99,
        'image_url':
            'https://m.media-amazon.com/images/I/71kCgl9yzzL.__AC_SY445_SX342_QL70_FMwebp_.jpg',
        'rating': 4.2,
        'reviews_count': 3178,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      });

      final result = await db.insert('product_details', {
        'id': 'B07V5LK5J3',
        'title':
            'TWINSLUXES Solar Post Cap Lights Outdoor - Waterproof LED Fence Post Solar Lights for 3.5x3.5/4x4/5x5 Wood Posts in Patio, Deck or Garden Decoration 4 Pack',
        'description':
            'Solar Post Cap Lights Waterproof LED Fence Post Solar Lights for 3.5x3.5 4x4 5x5 Wooden Posts. FEATURES & DETAILS   Product Specification Material: ABS Power Source: Solar-powered Lumens: 20 Lumens Color temperature: 3000k Light color: warm white LED: SMD 2835 0.5W *1 PCS Waterproof level: IP65 Battery: 600mah batteries Package Contents 1 x Solar post light 1 x Instruction Manual 1 x Installing Screw Set PERFECT FIT Fits wooden posts,vinyl posts or PVC posts The fence post lights solar powered is flexible and ingenious designed that this solar fence post lights can be easily installed on different inches of wooden or PVC vinyl columns. Ideal for patio, deck and garden decoration practical and beautiful Warm white LED makes the solar fence post lights well at night. How do solar deck post lights work? It’s very simple. You mount post lights solar powered on posts that you stake into the ground, and during the day the solar panel atop of the lights collects rays from the sun, charging the battery within so that energy can be utilized as light when it gets dark. The solar fence post lights 4x4 have an internal light sensor so that this deck lights can turn on automatically at dusk, and off at dawn. How to use solar post lights？ Quick and easy Do It Yourself installation. Easy screw-down installation, all you have to do is mark a couple holes, and drill down to stabilize the fence post solar lights. Plastic housing and lens, both are waterproof and will withstand all weather conditions.     TWINSLUXES, developed since 1986, is a professional manufacturer of solar lights, with CCC, CQC, CE, SAA, UL, GS, ROHS, REACH, PAHS and other international authoritative quality certifications TWINSLUXES Solar Post Lights Outdoor In the Darkness If the surrounder of the solar post cap is full of artificial light on night, that it will not turn on. Because these post cap solar lights depend on the weak light to determine whether it is nighttime or not. So you\'d better moving fence solar lights to darker areas. Cleaning Dirty Solar Panels The solar panels will collect dirt and grime over time, then they can not receive sunlight efficiently as before. Remove any debris that has collected with a smooth wet cloth. If the 4x4 post solar lights doesn\'t light up,check whether the battery is fixed and whether the battery is normal Be sure the post cap lights is in a relatively sunny location. 30 days free return   The deck post lights are beautiful, exquisite and practical. Unique appearance post solar lights, with warm and comfortable light, suit your deck post. It also enriches the mood for night walking and provides convenience.       Unique Outdoor Decoration   The Designed Glass Ball   Turn It ON/ OFF       DIY Installation outdoor solar lights effective IP44 waterproof and heat-resistant . You can install on wood,post, in patio, deck,mailbox or garden . Even in the daytime, it is the best decoration. High Efficiency Reflector TWINSLUXES solar fence post light are of high transmittance. Has a unique appearance and distinctive crack effect Automatically turns on at dusk, off at dawn. Solar Powered The top polysilicon solar panel uses the natural power of the sun to charge the internal 1.2v Ni-MH AA rechargeable battery. No extra wiring required, and the brilliant LEDs are long lasting and energy efficient. Solar Pathway Lights Color Changing Solar Post Cap Lights Outdoor Flickering Flame for 3.5x3.5/4x4/5x5 Yard Deck Solar Garden Lights Outdoor Twinsluxes 2 Color modes Solar Post Lights for 3.5x3.5/4x4/5x5 and larger size Solar Garden Lights Outdoor Size Conventional 3.5x3.5/4x4/5x5 Conventional 3.5x3.5/4x4/5x5 and larger size Conventional Brightness 15lm 15lm 10lm 25lm 15lm Waterproof Grade IP44 IP44 IP44 IP44 IP44 Applicable scene Pathway/Sidewalk/ Lawn/Patio/Yard Post/Deck/Fence/Dock/Garden/ Patio/ Gate/ Pathway/Sidewalk/ Lawn/Patio/Yard Post/Deck/Fence/Dock/Garden/ Patio/ Gate/ Pathway/Sidewalk/ Lawn/Patio/Yard Color Cold Light/Color Changing Flame flicker Warm/Cold Light White light/Warm light Warm/Cold Light',
        'initial_prices': 49.99,
        'final_prices': 33.99,
        'image_url':
            'https://m.media-amazon.com/images/I/71kCgl9yzzL.__AC_SY445_SX342_QL70_FMwebp_.jpg',
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      });

      expect(result, greaterThan(0));
    });
  });

  group('CRUD - product_summary', () {
    test('should insert and query a product_summary', () async {
      final db = await AppDatabase.database;
      final now = DateTime.now().millisecondsSinceEpoch;

      await db.insert('product_summary', {
        'id': 'B00080QHMM',
        'title':
            'Accutire MS-4021B Digital Tire Pressure Gauge with 4 Valve Caps, 5-150psi (psi, bar, kPa, kg/cm2)',
        'initial_prices': 1.79,
        'final_prices': 1.79,
        'image_url':
            'https://m.media-amazon.com/images/I/41UbPFLOVkL._SY445_SX342_QL70_FMwebp_.jpg',
        'rating': 4.4,
        'reviews_count': 8034,
        'cached_at': now,
      });

      final rows = await db.query(
        'product_summary',
        where: 'id = ?',
        whereArgs: ['B00080QHMM'],
      );
      expect(rows.length, equals(1));
      expect(
        rows.first['title'],
        equals(
          'Accutire MS-4021B Digital Tire Pressure Gauge with 4 Valve Caps, 5-150psi (psi, bar, kPa, kg/cm2)',
        ),
      );
      expect(rows.first['initial_prices'], equals(1.79));
      expect(rows.first['final_prices'], equals(1.79));
      expect(
        rows.first['image_url'],
        equals(
          'https://m.media-amazon.com/images/I/41UbPFLOVkL._SY445_SX342_QL70_FMwebp_.jpg',
        ),
      );
      expect(rows.first['rating'], equals(4.4));
      expect(rows.first['reviews_count'], equals(8034));
    });

    test('should throw when title is NULL', () async {
      final db = await AppDatabase.database;
      expect(
        () => db.insert('product_summary', {
          'id': 'B00080QHMM',
          'title': null,
          'initial_prices': 1.79,
          'final_prices': 1.79,
          'image_url':
              'https://m.media-amazon.com/images/I/41UbPFLOVkL._SY445_SX342_QL70_FMwebp_.jpg',
          'rating': 4.4,
          'reviews_count': 8034,
          'cached_at': DateTime.now().millisecondsSinceEpoch,
        }),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('should throw on duplicate id', () async {
      final db = await AppDatabase.database;
      final row = {
        'id': 'B00080QHMM',
        'title':
            'Accutire MS-4021B Digital Tire Pressure Gauge with 4 Valve Caps, 5-150psi (psi, bar, kPa, kg/cm2)',
        'initial_prices': 1.79,
        'final_prices': 1.79,
        'image_url':
            'https://m.media-amazon.com/images/I/41UbPFLOVkL._SY445_SX342_QL70_FMwebp_.jpg',
        'rating': 4.4,
        'reviews_count': 8034,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      };
      await db.insert('product_summary', row);
      expect(
        () => db.insert('product_summary', row),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('should update a product_summary', () async {
      final db = await AppDatabase.database;
      await db.insert('product_summary', {
        'id': 'B00080QHMM',
        'title':
            'Accutire MS-4021B Digital Tire Pressure Gauge with 4 Valve Caps, 5-150psi (psi, bar, kPa, kg/cm2)',
        'initial_prices': 1.79,
        'final_prices': 1.79,
        'image_url':
            'https://m.media-amazon.com/images/I/41UbPFLOVkL._SY445_SX342_QL70_FMwebp_.jpg',
        'rating': 4.4,
        'reviews_count': 8034,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      });
      await db.update(
        'product_summary',
        {
          'title':
              'SAURA LIFE SCIENCE Adivasi Ayurvedic Neelgiri Hair growth Hair Oil-250ML (2)',
        },
        where: 'id = ?',
        whereArgs: ['B00080QHMM'],
      );

      final rows = await db.query(
        'product_summary',
        where: 'id = ?',
        whereArgs: ['B00080QHMM'],
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
      await db.insert('product_summary', {
        'id': 'B00080QHMM',
        'title':
            'Accutire MS-4021B Digital Tire Pressure Gauge with 4 Valve Caps, 5-150psi (psi, bar, kPa, kg/cm2)',
        'initial_prices': 1.79,
        'final_prices': 1.79,
        'image_url':
            'https://m.media-amazon.com/images/I/41UbPFLOVkL._SY445_SX342_QL70_FMwebp_.jpg',
        'rating': 4.4,
        'reviews_count': 8034,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      });
      await db.delete(
        'product_summary',
        where: 'id = ?',
        whereArgs: ['B00080QHMM'],
      );

      final rows = await db.query(
        'product_summary',
        where: 'id = ?',
        whereArgs: ['B00080QHMM'],
      );
      expect(rows, isEmpty);
    });
  });

  group('CRUD - product_details', () {
    test('should insert and query a product_details', () async {
      final db = await AppDatabase.database;

      await db.insert('product_summary', {
        'id': 'B07V5LK5J3',
        'title':
            'TWINSLUXES Solar Post Cap Lights Outdoor - Waterproof LED Fence Post Solar Lights for 3.5x3.5/4x4/5x5 Wood Posts in Patio, Deck or Garden Decoration 4 Pack',
        'initial_prices': 49.99,
        'final_prices': 33.99,
        'image_url':
            'https://m.media-amazon.com/images/I/71kCgl9yzzL.__AC_SY445_SX342_QL70_FMwebp_.jpg',
        'rating': 4.2,
        'reviews_count': 3178,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      });

      await db.insert('product_details', {
        'id': 'B07V5LK5J3',
        'title':
            'TWINSLUXES Solar Post Cap Lights Outdoor - Waterproof LED Fence Post Solar Lights for 3.5x3.5/4x4/5x5 Wood Posts in Patio, Deck or Garden Decoration 4 Pack',
        'description':
            'Solar Post Cap Lights Waterproof LED Fence Post Solar Lights for 3.5x3.5 4x4 5x5 Wooden Posts. FEATURES & DETAILS   Product Specification Material: ABS Power Source: Solar-powered Lumens: 20 Lumens Color temperature: 3000k Light color: warm white LED: SMD 2835 0.5W *1 PCS Waterproof level: IP65 Battery: 600mah batteries Package Contents 1 x Solar post light 1 x Instruction Manual 1 x Installing Screw Set PERFECT FIT Fits wooden posts,vinyl posts or PVC posts The fence post lights solar powered is flexible and ingenious designed that this solar fence post lights can be easily installed on different inches of wooden or PVC vinyl columns. Ideal for patio, deck and garden decoration practical and beautiful Warm white LED makes the solar fence post lights well at night. How do solar deck post lights work? It’s very simple. You mount post lights solar powered on posts that you stake into the ground, and during the day the solar panel atop of the lights collects rays from the sun, charging the battery within so that energy can be utilized as light when it gets dark. The solar fence post lights 4x4 have an internal light sensor so that this deck lights can turn on automatically at dusk, and off at dawn. How to use solar post lights？ Quick and easy Do It Yourself installation. Easy screw-down installation, all you have to do is mark a couple holes, and drill down to stabilize the fence post solar lights. Plastic housing and lens, both are waterproof and will withstand all weather conditions.     TWINSLUXES, developed since 1986, is a professional manufacturer of solar lights, with CCC, CQC, CE, SAA, UL, GS, ROHS, REACH, PAHS and other international authoritative quality certifications TWINSLUXES Solar Post Lights Outdoor In the Darkness If the surrounder of the solar post cap is full of artificial light on night, that it will not turn on. Because these post cap solar lights depend on the weak light to determine whether it is nighttime or not. So you\'d better moving fence solar lights to darker areas. Cleaning Dirty Solar Panels The solar panels will collect dirt and grime over time, then they can not receive sunlight efficiently as before. Remove any debris that has collected with a smooth wet cloth. If the 4x4 post solar lights doesn\'t light up,check whether the battery is fixed and whether the battery is normal Be sure the post cap lights is in a relatively sunny location. 30 days free return   The deck post lights are beautiful, exquisite and practical. Unique appearance post solar lights, with warm and comfortable light, suit your deck post. It also enriches the mood for night walking and provides convenience.       Unique Outdoor Decoration   The Designed Glass Ball   Turn It ON/ OFF       DIY Installation outdoor solar lights effective IP44 waterproof and heat-resistant . You can install on wood,post, in patio, deck,mailbox or garden . Even in the daytime, it is the best decoration. High Efficiency Reflector TWINSLUXES solar fence post light are of high transmittance. Has a unique appearance and distinctive crack effect Automatically turns on at dusk, off at dawn. Solar Powered The top polysilicon solar panel uses the natural power of the sun to charge the internal 1.2v Ni-MH AA rechargeable battery. No extra wiring required, and the brilliant LEDs are long lasting and energy efficient. Solar Pathway Lights Color Changing Solar Post Cap Lights Outdoor Flickering Flame for 3.5x3.5/4x4/5x5 Yard Deck Solar Garden Lights Outdoor Twinsluxes 2 Color modes Solar Post Lights for 3.5x3.5/4x4/5x5 and larger size Solar Garden Lights Outdoor Size Conventional 3.5x3.5/4x4/5x5 Conventional 3.5x3.5/4x4/5x5 and larger size Conventional Brightness 15lm 15lm 10lm 25lm 15lm Waterproof Grade IP44 IP44 IP44 IP44 IP44 Applicable scene Pathway/Sidewalk/ Lawn/Patio/Yard Post/Deck/Fence/Dock/Garden/ Patio/ Gate/ Pathway/Sidewalk/ Lawn/Patio/Yard Post/Deck/Fence/Dock/Garden/ Patio/ Gate/ Pathway/Sidewalk/ Lawn/Patio/Yard Color Cold Light/Color Changing Flame flicker Warm/Cold Light White light/Warm light Warm/Cold Light',
        'initial_prices': 49.99,
        'final_prices': 33.99,
        'image_url':
            'https://m.media-amazon.com/images/I/71kCgl9yzzL.__AC_SY445_SX342_QL70_FMwebp_.jpg',
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      });

      final rows = await db.query(
        'product_details',
        where: 'id = ?',
        whereArgs: ['B07V5LK5J3'],
      );
      expect(rows.length, equals(1));
      expect(
        rows.first['title'],
        equals(
          'TWINSLUXES Solar Post Cap Lights Outdoor - Waterproof LED Fence Post Solar Lights for 3.5x3.5/4x4/5x5 Wood Posts in Patio, Deck or Garden Decoration 4 Pack',
        ),
      );
      expect(rows.first['initial_prices'], equals(49.99));
      expect(rows.first['final_prices'], equals(33.99));
      expect(
        rows.first['image_url'],
        equals(
          'https://m.media-amazon.com/images/I/71kCgl9yzzL.__AC_SY445_SX342_QL70_FMwebp_.jpg',
        ),
      );
    });

    test('should throw when title is NULL', () async {
      final db = await AppDatabase.database;

      await db.insert('product_summary', {
        'id': 'B07V5LK5J3',
        'title':
            'TWINSLUXES Solar Post Cap Lights Outdoor - Waterproof LED Fence Post Solar Lights for 3.5x3.5/4x4/5x5 Wood Posts in Patio, Deck or Garden Decoration 4 Pack',
        'initial_prices': 49.99,
        'final_prices': 33.99,
        'image_url':
            'https://m.media-amazon.com/images/I/71kCgl9yzzL.__AC_SY445_SX342_QL70_FMwebp_.jpg',
        'rating': 4.2,
        'reviews_count': 3178,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      });

      expect(
        () => db.insert('product_details', {
        'id': 'B07V5LK5J3',
        'title': null,
        'description':
            'Solar Post Cap Lights Waterproof LED Fence Post Solar Lights for 3.5x3.5 4x4 5x5 Wooden Posts. FEATURES & DETAILS   Product Specification Material: ABS Power Source: Solar-powered Lumens: 20 Lumens Color temperature: 3000k Light color: warm white LED: SMD 2835 0.5W *1 PCS Waterproof level: IP65 Battery: 600mah batteries Package Contents 1 x Solar post light 1 x Instruction Manual 1 x Installing Screw Set PERFECT FIT Fits wooden posts,vinyl posts or PVC posts The fence post lights solar powered is flexible and ingenious designed that this solar fence post lights can be easily installed on different inches of wooden or PVC vinyl columns. Ideal for patio, deck and garden decoration practical and beautiful Warm white LED makes the solar fence post lights well at night. How do solar deck post lights work? It’s very simple. You mount post lights solar powered on posts that you stake into the ground, and during the day the solar panel atop of the lights collects rays from the sun, charging the battery within so that energy can be utilized as light when it gets dark. The solar fence post lights 4x4 have an internal light sensor so that this deck lights can turn on automatically at dusk, and off at dawn. How to use solar post lights？ Quick and easy Do It Yourself installation. Easy screw-down installation, all you have to do is mark a couple holes, and drill down to stabilize the fence post solar lights. Plastic housing and lens, both are waterproof and will withstand all weather conditions.     TWINSLUXES, developed since 1986, is a professional manufacturer of solar lights, with CCC, CQC, CE, SAA, UL, GS, ROHS, REACH, PAHS and other international authoritative quality certifications TWINSLUXES Solar Post Lights Outdoor In the Darkness If the surrounder of the solar post cap is full of artificial light on night, that it will not turn on. Because these post cap solar lights depend on the weak light to determine whether it is nighttime or not. So you\'d better moving fence solar lights to darker areas. Cleaning Dirty Solar Panels The solar panels will collect dirt and grime over time, then they can not receive sunlight efficiently as before. Remove any debris that has collected with a smooth wet cloth. If the 4x4 post solar lights doesn\'t light up,check whether the battery is fixed and whether the battery is normal Be sure the post cap lights is in a relatively sunny location. 30 days free return   The deck post lights are beautiful, exquisite and practical. Unique appearance post solar lights, with warm and comfortable light, suit your deck post. It also enriches the mood for night walking and provides convenience.       Unique Outdoor Decoration   The Designed Glass Ball   Turn It ON/ OFF       DIY Installation outdoor solar lights effective IP44 waterproof and heat-resistant . You can install on wood,post, in patio, deck,mailbox or garden . Even in the daytime, it is the best decoration. High Efficiency Reflector TWINSLUXES solar fence post light are of high transmittance. Has a unique appearance and distinctive crack effect Automatically turns on at dusk, off at dawn. Solar Powered The top polysilicon solar panel uses the natural power of the sun to charge the internal 1.2v Ni-MH AA rechargeable battery. No extra wiring required, and the brilliant LEDs are long lasting and energy efficient. Solar Pathway Lights Color Changing Solar Post Cap Lights Outdoor Flickering Flame for 3.5x3.5/4x4/5x5 Yard Deck Solar Garden Lights Outdoor Twinsluxes 2 Color modes Solar Post Lights for 3.5x3.5/4x4/5x5 and larger size Solar Garden Lights Outdoor Size Conventional 3.5x3.5/4x4/5x5 Conventional 3.5x3.5/4x4/5x5 and larger size Conventional Brightness 15lm 15lm 10lm 25lm 15lm Waterproof Grade IP44 IP44 IP44 IP44 IP44 Applicable scene Pathway/Sidewalk/ Lawn/Patio/Yard Post/Deck/Fence/Dock/Garden/ Patio/ Gate/ Pathway/Sidewalk/ Lawn/Patio/Yard Post/Deck/Fence/Dock/Garden/ Patio/ Gate/ Pathway/Sidewalk/ Lawn/Patio/Yard Color Cold Light/Color Changing Flame flicker Warm/Cold Light White light/Warm light Warm/Cold Light',
        'initial_prices': 49.99,
        'final_prices': 33.99,
        'image_url':
            'https://m.media-amazon.com/images/I/71kCgl9yzzL.__AC_SY445_SX342_QL70_FMwebp_.jpg',
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      }),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('should throw on duplicate id', () async {
      final db = await AppDatabase.database;
      final productSummaryRow = {
        'id': 'B07V5LK5J3',
        'title':
            'TWINSLUXES Solar Post Cap Lights Outdoor - Waterproof LED Fence Post Solar Lights for 3.5x3.5/4x4/5x5 Wood Posts in Patio, Deck or Garden Decoration 4 Pack',
        'initial_prices': 49.99,
        'final_prices': 33.99,
        'image_url':
            'https://m.media-amazon.com/images/I/71kCgl9yzzL.__AC_SY445_SX342_QL70_FMwebp_.jpg',
        'rating': 4.2,
        'reviews_count': 3178,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      };
      await db.insert('product_summary', productSummaryRow);

      final productDetailsRow = {
        'id': 'B07V5LK5J3',
        'title':
            'TWINSLUXES Solar Post Cap Lights Outdoor - Waterproof LED Fence Post Solar Lights for 3.5x3.5/4x4/5x5 Wood Posts in Patio, Deck or Garden Decoration 4 Pack',
        'description':
            'Solar Post Cap Lights Waterproof LED Fence Post Solar Lights for 3.5x3.5 4x4 5x5 Wooden Posts. FEATURES & DETAILS   Product Specification Material: ABS Power Source: Solar-powered Lumens: 20 Lumens Color temperature: 3000k Light color: warm white LED: SMD 2835 0.5W *1 PCS Waterproof level: IP65 Battery: 600mah batteries Package Contents 1 x Solar post light 1 x Instruction Manual 1 x Installing Screw Set PERFECT FIT Fits wooden posts,vinyl posts or PVC posts The fence post lights solar powered is flexible and ingenious designed that this solar fence post lights can be easily installed on different inches of wooden or PVC vinyl columns. Ideal for patio, deck and garden decoration practical and beautiful Warm white LED makes the solar fence post lights well at night. How do solar deck post lights work? It’s very simple. You mount post lights solar powered on posts that you stake into the ground, and during the day the solar panel atop of the lights collects rays from the sun, charging the battery within so that energy can be utilized as light when it gets dark. The solar fence post lights 4x4 have an internal light sensor so that this deck lights can turn on automatically at dusk, and off at dawn. How to use solar post lights？ Quick and easy Do It Yourself installation. Easy screw-down installation, all you have to do is mark a couple holes, and drill down to stabilize the fence post solar lights. Plastic housing and lens, both are waterproof and will withstand all weather conditions.     TWINSLUXES, developed since 1986, is a professional manufacturer of solar lights, with CCC, CQC, CE, SAA, UL, GS, ROHS, REACH, PAHS and other international authoritative quality certifications TWINSLUXES Solar Post Lights Outdoor In the Darkness If the surrounder of the solar post cap is full of artificial light on night, that it will not turn on. Because these post cap solar lights depend on the weak light to determine whether it is nighttime or not. So you\'d better moving fence solar lights to darker areas. Cleaning Dirty Solar Panels The solar panels will collect dirt and grime over time, then they can not receive sunlight efficiently as before. Remove any debris that has collected with a smooth wet cloth. If the 4x4 post solar lights doesn\'t light up,check whether the battery is fixed and whether the battery is normal Be sure the post cap lights is in a relatively sunny location. 30 days free return   The deck post lights are beautiful, exquisite and practical. Unique appearance post solar lights, with warm and comfortable light, suit your deck post. It also enriches the mood for night walking and provides convenience.       Unique Outdoor Decoration   The Designed Glass Ball   Turn It ON/ OFF       DIY Installation outdoor solar lights effective IP44 waterproof and heat-resistant . You can install on wood,post, in patio, deck,mailbox or garden . Even in the daytime, it is the best decoration. High Efficiency Reflector TWINSLUXES solar fence post light are of high transmittance. Has a unique appearance and distinctive crack effect Automatically turns on at dusk, off at dawn. Solar Powered The top polysilicon solar panel uses the natural power of the sun to charge the internal 1.2v Ni-MH AA rechargeable battery. No extra wiring required, and the brilliant LEDs are long lasting and energy efficient. Solar Pathway Lights Color Changing Solar Post Cap Lights Outdoor Flickering Flame for 3.5x3.5/4x4/5x5 Yard Deck Solar Garden Lights Outdoor Twinsluxes 2 Color modes Solar Post Lights for 3.5x3.5/4x4/5x5 and larger size Solar Garden Lights Outdoor Size Conventional 3.5x3.5/4x4/5x5 Conventional 3.5x3.5/4x4/5x5 and larger size Conventional Brightness 15lm 15lm 10lm 25lm 15lm Waterproof Grade IP44 IP44 IP44 IP44 IP44 Applicable scene Pathway/Sidewalk/ Lawn/Patio/Yard Post/Deck/Fence/Dock/Garden/ Patio/ Gate/ Pathway/Sidewalk/ Lawn/Patio/Yard Post/Deck/Fence/Dock/Garden/ Patio/ Gate/ Pathway/Sidewalk/ Lawn/Patio/Yard Color Cold Light/Color Changing Flame flicker Warm/Cold Light White light/Warm light Warm/Cold Light',
        'initial_prices': 49.99,
        'final_prices': 33.99,
        'image_url':
            'https://m.media-amazon.com/images/I/71kCgl9yzzL.__AC_SY445_SX342_QL70_FMwebp_.jpg',
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      };
      await db.insert('product_details', productDetailsRow);

      expect(
        () => db.insert('product_details', productDetailsRow),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('should update a product_details', () async {
      final db = await AppDatabase.database;
      await db.insert('product_summary', {
        'id': 'B07V5LK5J3',
        'title':
            'TWINSLUXES Solar Post Cap Lights Outdoor - Waterproof LED Fence Post Solar Lights for 3.5x3.5/4x4/5x5 Wood Posts in Patio, Deck or Garden Decoration 4 Pack',
        'initial_prices': 49.99,
        'final_prices': 33.99,
        'image_url':
            'https://m.media-amazon.com/images/I/71kCgl9yzzL.__AC_SY445_SX342_QL70_FMwebp_.jpg',
        'rating': 4.2,
        'reviews_count': 3178,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      });

      await db.insert('product_details', {
        'id': 'B07V5LK5J3',
        'title':
            'TWINSLUXES Solar Post Cap Lights Outdoor - Waterproof LED Fence Post Solar Lights for 3.5x3.5/4x4/5x5 Wood Posts in Patio, Deck or Garden Decoration 4 Pack',
        'description':
            'Solar Post Cap Lights Waterproof LED Fence Post Solar Lights for 3.5x3.5 4x4 5x5 Wooden Posts. FEATURES & DETAILS   Product Specification Material: ABS Power Source: Solar-powered Lumens: 20 Lumens Color temperature: 3000k Light color: warm white LED: SMD 2835 0.5W *1 PCS Waterproof level: IP65 Battery: 600mah batteries Package Contents 1 x Solar post light 1 x Instruction Manual 1 x Installing Screw Set PERFECT FIT Fits wooden posts,vinyl posts or PVC posts The fence post lights solar powered is flexible and ingenious designed that this solar fence post lights can be easily installed on different inches of wooden or PVC vinyl columns. Ideal for patio, deck and garden decoration practical and beautiful Warm white LED makes the solar fence post lights well at night. How do solar deck post lights work? It’s very simple. You mount post lights solar powered on posts that you stake into the ground, and during the day the solar panel atop of the lights collects rays from the sun, charging the battery within so that energy can be utilized as light when it gets dark. The solar fence post lights 4x4 have an internal light sensor so that this deck lights can turn on automatically at dusk, and off at dawn. How to use solar post lights？ Quick and easy Do It Yourself installation. Easy screw-down installation, all you have to do is mark a couple holes, and drill down to stabilize the fence post solar lights. Plastic housing and lens, both are waterproof and will withstand all weather conditions.     TWINSLUXES, developed since 1986, is a professional manufacturer of solar lights, with CCC, CQC, CE, SAA, UL, GS, ROHS, REACH, PAHS and other international authoritative quality certifications TWINSLUXES Solar Post Lights Outdoor In the Darkness If the surrounder of the solar post cap is full of artificial light on night, that it will not turn on. Because these post cap solar lights depend on the weak light to determine whether it is nighttime or not. So you\'d better moving fence solar lights to darker areas. Cleaning Dirty Solar Panels The solar panels will collect dirt and grime over time, then they can not receive sunlight efficiently as before. Remove any debris that has collected with a smooth wet cloth. If the 4x4 post solar lights doesn\'t light up,check whether the battery is fixed and whether the battery is normal Be sure the post cap lights is in a relatively sunny location. 30 days free return   The deck post lights are beautiful, exquisite and practical. Unique appearance post solar lights, with warm and comfortable light, suit your deck post. It also enriches the mood for night walking and provides convenience.       Unique Outdoor Decoration   The Designed Glass Ball   Turn It ON/ OFF       DIY Installation outdoor solar lights effective IP44 waterproof and heat-resistant . You can install on wood,post, in patio, deck,mailbox or garden . Even in the daytime, it is the best decoration. High Efficiency Reflector TWINSLUXES solar fence post light are of high transmittance. Has a unique appearance and distinctive crack effect Automatically turns on at dusk, off at dawn. Solar Powered The top polysilicon solar panel uses the natural power of the sun to charge the internal 1.2v Ni-MH AA rechargeable battery. No extra wiring required, and the brilliant LEDs are long lasting and energy efficient. Solar Pathway Lights Color Changing Solar Post Cap Lights Outdoor Flickering Flame for 3.5x3.5/4x4/5x5 Yard Deck Solar Garden Lights Outdoor Twinsluxes 2 Color modes Solar Post Lights for 3.5x3.5/4x4/5x5 and larger size Solar Garden Lights Outdoor Size Conventional 3.5x3.5/4x4/5x5 Conventional 3.5x3.5/4x4/5x5 and larger size Conventional Brightness 15lm 15lm 10lm 25lm 15lm Waterproof Grade IP44 IP44 IP44 IP44 IP44 Applicable scene Pathway/Sidewalk/ Lawn/Patio/Yard Post/Deck/Fence/Dock/Garden/ Patio/ Gate/ Pathway/Sidewalk/ Lawn/Patio/Yard Post/Deck/Fence/Dock/Garden/ Patio/ Gate/ Pathway/Sidewalk/ Lawn/Patio/Yard Color Cold Light/Color Changing Flame flicker Warm/Cold Light White light/Warm light Warm/Cold Light',
        'initial_prices': 49.99,
        'final_prices': 33.99,
        'image_url':
            'https://m.media-amazon.com/images/I/71kCgl9yzzL.__AC_SY445_SX342_QL70_FMwebp_.jpg',
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      });

      await db.update(
        'product_details',
        {
          'title':
              'SAURA LIFE SCIENCE Adivasi Ayurvedic Neelgiri Hair growth Hair Oil-250ML (2)',
        },
        where: 'id = ?',
        whereArgs: ['B07V5LK5J3'],
      );

      final rows = await db.query(
        'product_details',
        where: 'id = ?',
        whereArgs: ['B07V5LK5J3'],
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
      await db.insert('product_summary', {
        'id': 'B07V5LK5J3',
        'title':
            'TWINSLUXES Solar Post Cap Lights Outdoor - Waterproof LED Fence Post Solar Lights for 3.5x3.5/4x4/5x5 Wood Posts in Patio, Deck or Garden Decoration 4 Pack',
        'initial_prices': 49.99,
        'final_prices': 33.99,
        'image_url':
            'https://m.media-amazon.com/images/I/71kCgl9yzzL.__AC_SY445_SX342_QL70_FMwebp_.jpg',
        'rating': 4.2,
        'reviews_count': 3178,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      });

      await db.insert('product_details', {
        'id': 'B07V5LK5J3',
        'title':
            'TWINSLUXES Solar Post Cap Lights Outdoor - Waterproof LED Fence Post Solar Lights for 3.5x3.5/4x4/5x5 Wood Posts in Patio, Deck or Garden Decoration 4 Pack',
        'description':
            'Solar Post Cap Lights Waterproof LED Fence Post Solar Lights for 3.5x3.5 4x4 5x5 Wooden Posts. FEATURES & DETAILS   Product Specification Material: ABS Power Source: Solar-powered Lumens: 20 Lumens Color temperature: 3000k Light color: warm white LED: SMD 2835 0.5W *1 PCS Waterproof level: IP65 Battery: 600mah batteries Package Contents 1 x Solar post light 1 x Instruction Manual 1 x Installing Screw Set PERFECT FIT Fits wooden posts,vinyl posts or PVC posts The fence post lights solar powered is flexible and ingenious designed that this solar fence post lights can be easily installed on different inches of wooden or PVC vinyl columns. Ideal for patio, deck and garden decoration practical and beautiful Warm white LED makes the solar fence post lights well at night. How do solar deck post lights work? It’s very simple. You mount post lights solar powered on posts that you stake into the ground, and during the day the solar panel atop of the lights collects rays from the sun, charging the battery within so that energy can be utilized as light when it gets dark. The solar fence post lights 4x4 have an internal light sensor so that this deck lights can turn on automatically at dusk, and off at dawn. How to use solar post lights？ Quick and easy Do It Yourself installation. Easy screw-down installation, all you have to do is mark a couple holes, and drill down to stabilize the fence post solar lights. Plastic housing and lens, both are waterproof and will withstand all weather conditions.     TWINSLUXES, developed since 1986, is a professional manufacturer of solar lights, with CCC, CQC, CE, SAA, UL, GS, ROHS, REACH, PAHS and other international authoritative quality certifications TWINSLUXES Solar Post Lights Outdoor In the Darkness If the surrounder of the solar post cap is full of artificial light on night, that it will not turn on. Because these post cap solar lights depend on the weak light to determine whether it is nighttime or not. So you\'d better moving fence solar lights to darker areas. Cleaning Dirty Solar Panels The solar panels will collect dirt and grime over time, then they can not receive sunlight efficiently as before. Remove any debris that has collected with a smooth wet cloth. If the 4x4 post solar lights doesn\'t light up,check whether the battery is fixed and whether the battery is normal Be sure the post cap lights is in a relatively sunny location. 30 days free return   The deck post lights are beautiful, exquisite and practical. Unique appearance post solar lights, with warm and comfortable light, suit your deck post. It also enriches the mood for night walking and provides convenience.       Unique Outdoor Decoration   The Designed Glass Ball   Turn It ON/ OFF       DIY Installation outdoor solar lights effective IP44 waterproof and heat-resistant . You can install on wood,post, in patio, deck,mailbox or garden . Even in the daytime, it is the best decoration. High Efficiency Reflector TWINSLUXES solar fence post light are of high transmittance. Has a unique appearance and distinctive crack effect Automatically turns on at dusk, off at dawn. Solar Powered The top polysilicon solar panel uses the natural power of the sun to charge the internal 1.2v Ni-MH AA rechargeable battery. No extra wiring required, and the brilliant LEDs are long lasting and energy efficient. Solar Pathway Lights Color Changing Solar Post Cap Lights Outdoor Flickering Flame for 3.5x3.5/4x4/5x5 Yard Deck Solar Garden Lights Outdoor Twinsluxes 2 Color modes Solar Post Lights for 3.5x3.5/4x4/5x5 and larger size Solar Garden Lights Outdoor Size Conventional 3.5x3.5/4x4/5x5 Conventional 3.5x3.5/4x4/5x5 and larger size Conventional Brightness 15lm 15lm 10lm 25lm 15lm Waterproof Grade IP44 IP44 IP44 IP44 IP44 Applicable scene Pathway/Sidewalk/ Lawn/Patio/Yard Post/Deck/Fence/Dock/Garden/ Patio/ Gate/ Pathway/Sidewalk/ Lawn/Patio/Yard Post/Deck/Fence/Dock/Garden/ Patio/ Gate/ Pathway/Sidewalk/ Lawn/Patio/Yard Color Cold Light/Color Changing Flame flicker Warm/Cold Light White light/Warm light Warm/Cold Light',
        'initial_prices': 49.99,
        'final_prices': 33.99,
        'image_url':
            'https://m.media-amazon.com/images/I/71kCgl9yzzL.__AC_SY445_SX342_QL70_FMwebp_.jpg',
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      });
      await db.delete(
        'product_details',
        where: 'id = ?',
        whereArgs: ['B07V5LK5J3'],
      );

      final rows = await db.query(
        'product_details',
        where: 'id = ?',
        whereArgs: ['B07V5LK5J3'],
      );
      expect(rows, isEmpty);
    });
  });
}
