import 'package:e_commerce_client/data/models/product/product_details_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../fixtures/fixture_reader.dart';
import 'dart:convert';

import '../../../fixtures/product/product_fixtures.dart';

void main() {
  late Map<String, dynamic> tJsonMap;

  setUp(() {
    tJsonMap = jsonDecode(fixture('product/product_details.json'));
  });

  group('ProductDetailsModel', () {
    test('fromJson should return valid ProductDetailsModel', () {
      // act
      final result = ProductDetailsModel.fromJson(tJsonMap);

      // assert
      expect(result, equals(tProductDetailsModel));

      expect(result.id, tProductDetailsModel.id);
      expect(result.name, tProductDetailsModel.name);
      expect(result.initialPrice, tProductDetailsModel.initialPrice);
      expect(result.finalPrice, tProductDetailsModel.finalPrice);
      expect(result.description, tProductDetailsModel.description);
      expect(result.imageUrl, tProductDetailsModel.imageUrl);
      expect(result.additionalImages, tProductDetailsModel.additionalImages);
      expect(result.localizedAspects.length, tProductDetailsModel.localizedAspects.length);
      expect(result.localizedAspects.first, tProductDetailsModel.localizedAspects.first);
      expect(result.localizedAspects.first.name, tProductDetailsModel.localizedAspects.first.name);
      expect(result.shippingOptions.length, tProductDetailsModel.shippingOptions.length);
      expect(result.shippingOptions.first, tProductDetailsModel.shippingOptions.first);
      expect(result.shippingOptions.first.shippingCost, tProductDetailsModel.shippingOptions.first.shippingCost);
    });

    test('ProductDetailsModel.toEntity should convert correctly', () {
      // act
      final result = tProductDetailsModel.toEntity();

      // assert
      expect(result, tProductDetailsEntity);
  
      expect(result.id, tProductDetailsEntity.id);
      expect(result.name, tProductDetailsEntity.name);
      expect(result.finalPrice, tProductDetailsEntity.finalPrice);
      expect(result.description, tProductDetailsEntity.description);
      expect(result.imageUrl, tProductDetailsEntity.imageUrl);
      expect(result.additionalImages, tProductDetailsEntity.additionalImages);
    });
  });
}
