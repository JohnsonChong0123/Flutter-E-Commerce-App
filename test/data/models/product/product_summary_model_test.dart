import 'dart:convert';
import 'package:e_commerce_client/data/models/product/product_summary_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../fixtures/fixture_reader.dart';
import '../../../fixtures/product/product_fixtures.dart';

void main() {
  late Map<String, dynamic> tJsonMap;

  setUp(() {
    tJsonMap = jsonDecode(fixture('product/product_summary.json'));
  });

  group('ProductSummaryModel', () {
    test('fromJson should return valid ProductSummaryModel', () {
      // Act
      final result = ProductSummaryModel.fromJson(tJsonMap);

      // Assert
      expect(result, tProductSummaryModel);

      expect(result.id, tProductSummaryModel.id);
      expect(result.name, tProductSummaryModel.name);
      expect(result.initialPrice, tProductSummaryModel.initialPrice);
      expect(result.finalPrice, tProductSummaryModel.finalPrice);
      expect(result.imageUrl, tProductSummaryModel.imageUrl);
    });

    test('toEntity should convert to ProductSummaryEntity correctly', () {
      // Act
      final result = tProductSummaryModel.toEntity();

      // Assert
      expect(result, tProductSummaryEntity);

      expect(result.id, tProductSummaryModel.id);
      expect(result.name, tProductSummaryModel.name);
      expect(result.initialPrice!.value, tProductSummaryModel.initialPrice!.value);
      expect(result.finalPrice!.value, tProductSummaryModel.finalPrice!.value);
      expect(result.imageUrl, tProductSummaryModel.imageUrl);
    });
  });
}
