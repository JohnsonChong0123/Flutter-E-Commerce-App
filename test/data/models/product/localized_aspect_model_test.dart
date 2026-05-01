import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_client/data/models/product/localized_aspect_model.dart';
import 'package:e_commerce_client/domain/entity/product/localized_aspect_entity.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  late Map<String, dynamic> tJsonMap;

  setUp(() {
    tJsonMap = jsonDecode(fixture('product/product_details.json'));
  });
  group('LocalizedAspectModel', () {
    test('fromJson creates model from valid json', () {
      Map<String, dynamic>? findAspect(Map<String, dynamic> m) {
        if (m.containsKey('type') && m.containsKey('name') && m.containsKey('value')) {
          return Map<String, dynamic>.from(m);
        }
        for (final v in m.values) {
          if (v is Map<String, dynamic>) {
            final found = findAspect(v);
            if (found != null) return found;
          } else if (v is List) {
            for (final e in v) {
              if (e is Map<String, dynamic>) {
                final found = findAspect(e);
                if (found != null) return found;
              }
            }
          }
        }
        return null;
      }

      final json = findAspect(tJsonMap) ?? {'type': 'STRING', 'name': 'CAPACITY', 'value': '512GB'};
      final model = LocalizedAspectModel.fromJson(json);

      expect(model.type, 'STRING');
      expect(model.name, 'CAPACITY');
      expect(model.value, '512GB');
    });

    test('fromJson handles missing keys and null values', () {
      final empty = LocalizedAspectModel.fromJson({});

      expect(empty.type, '');
      expect(empty.name, '');
      expect(empty.value, '');

      final mixed = LocalizedAspectModel.fromJson({
        'type': null,
        'name': 123,
        'value': true,
      });

      // null becomes empty string because of the null-aware operator and ?? ''
      expect(mixed.type, '');
      // non-string values are converted via toString()
      expect(mixed.name, '123');
      expect(mixed.value, 'true');
    });

    test('toEntity returns LocalizedAspectEntity with same values', () {
      final model = LocalizedAspectModel(type: 't', name: 'n', value: 'v');
      final entity = model.toEntity();

      expect(entity, isA<LocalizedAspectEntity>());
      expect(entity.type, 't');
      expect(entity.name, 'n');
      expect(entity.value, 'v');
    });

    test('equatable equality works as expected', () {
      final a = LocalizedAspectModel(type: 't', name: 'n', value: 'v');
      final b = LocalizedAspectModel(type: 't', name: 'n', value: 'v');
      final c = LocalizedAspectModel(type: 'x', name: 'n', value: 'v');

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });
}
