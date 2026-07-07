import 'package:e_commerce_client/core/extensions/currency_extension.dart';
import 'package:e_commerce_client/presentation/mappers/product_details_mapper.dart';
import 'package:e_commerce_client/presentation/models/product_display_aspect.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../fixtures/product/product_fixtures.dart';
import '../../fixtures/shipping/shipping_fixtures.dart';

void main() {
  group('ProductDetailsMapper.mapAspects', () {
    test('should map only string localized aspects with non-empty names', () {
      final result = ProductDetailsMapper.mapAspects(tProductDetailsEntity);

      expect(
        result,
        contains(const ProductDisplayAspect(name: 'CAPACITY', value: '512GB')),
      );

      expect(
        result,
        contains(const ProductDisplayAspect(name: 'Brand', value: 'Samsung')),
      );

      expect(result.every((e) => e.name.trim().isNotEmpty), true);
    });

    test('should return empty list when localizedAspects is empty', () {
      final product = tProductDetailsEntity.copyWith(
        localizedAspects: const [],
      );

      final result = ProductDetailsMapper.mapAspects(product);

      expect(result, isEmpty);
    });
  });

  group('ProductDetailsMapper.mapShippingAspects', () {
    test('should map shipping options into display aspects', () {
      final result = ProductDetailsMapper.mapShippingAspects(
        tProductDetailsEntity,
      );

      expect(result, {
        'Standard Shipping': [
          ProductDisplayAspect(
            name: 'Cost',
            value: tMoneyEntity.value.formatCurrency(tMoneyEntity.currency),
          ),
          ProductDisplayAspect(
            name: 'Addition Cost / Unit',
            value: tMoneyEntity.value.formatCurrency(tMoneyEntity.currency),
          ),
          const ProductDisplayAspect(name: 'Cost Type', value: 'FIXED'),
        ],
      });
    });

    test('should return N/A when shipping values are null', () {
      final product = tProductDetailsEntity.copyWith(
        shippingOptions: [tShippingOptionEntityNullValues],
      );

      final result = ProductDetailsMapper.mapShippingAspects(product);

      expect(result, {
        'Standard Shipping': [
          const ProductDisplayAspect(name: 'Cost', value: 'N/A'),
          const ProductDisplayAspect(
            name: 'Addition Cost / Unit',
            value: 'N/A',
          ),
          const ProductDisplayAspect(name: 'Cost Type', value: 'N/A'),
        ],
      });
    });

    test('should omit prefix when shippingServiceCode is empty', () {
      final shippingOption = tShippingOptionEntity.copyWith(
        shippingServiceCode: '',
      );

      final product = tProductDetailsEntity.copyWith(
        shippingOptions: [shippingOption],
      );

      final result = ProductDetailsMapper.mapShippingAspects(product);

      expect(
        result.values.first.first,
        ProductDisplayAspect(
          name: 'Cost',
          value: tMoneyEntity.value.formatCurrency(tMoneyEntity.currency),
        ),
      );
    });

    test('should return empty list when shippingOptions is empty', () {
      final product = tProductDetailsEntity.copyWith(shippingOptions: const []);

      final result = ProductDetailsMapper.mapShippingAspects(product);

      expect(result, isEmpty);
    });
  });
}
