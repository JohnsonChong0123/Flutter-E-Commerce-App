import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_client/data/models/product/localized_aspect_model.dart';
import 'package:e_commerce_client/domain/entity/product/localized_aspect_entity.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  late Map<String, dynamic> tJsonMap;

  const tLocalizedAspectsModel = LocalizedAspectModel(
    type: 'STRING',
    name: 'CAPACITY',
    value: '512GB',
  );

  setUp(() {
    tJsonMap = jsonDecode(fixture('product/localized_aspect.json'));
  });
  group('LocalizedAspectModel', () {
    test('should create a model from valid json', () {
      // Act
      final result = LocalizedAspectModel.fromJson(tJsonMap);

      // Assert
      expect(result, tLocalizedAspectsModel);

      expect(result.type, tLocalizedAspectsModel.type);
      expect(result.name, tLocalizedAspectsModel.name);
      expect(result.value, tLocalizedAspectsModel.value);
    });
    
    test('should convert to entity returns LocalizedAspectEntity with same values', () {
      // Act
      final result = tLocalizedAspectsModel.toEntity();

      // Assert
      expect(result, isA<LocalizedAspectEntity>());
      expect(result.type, tLocalizedAspectsModel.type);
      expect(result.name, tLocalizedAspectsModel.name);
      expect(result.value, tLocalizedAspectsModel.value);
    });
  });
}
