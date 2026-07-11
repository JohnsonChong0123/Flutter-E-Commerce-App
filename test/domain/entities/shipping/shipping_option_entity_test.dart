import 'package:e_commerce_client/domain/entity/shipping/money_entity.dart';
import 'package:e_commerce_client/domain/entity/shipping/shipping_option_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShippingOptionEntity.formatShippingPrice', () {
    test('should return N/A when both costs are null', () {
      const option = ShippingOptionEntity(
        shippingServiceCode: 'standard',
        type: 'Standard',
      );

      expect(option.formatShippingPrice(2), 'N/A');
    });

    test('should return base price when only shippingCost exists', () {
      const option = ShippingOptionEntity(
        shippingServiceCode: 'standard',
        type: 'Standard',
        shippingCost: MoneyEntity(currency: 'USD', value: 10),
      );

      expect(option.formatShippingPrice(1), r'$10.00');
    });

    test('should return only base price when quantity is 1', () {
      const option = ShippingOptionEntity(
        shippingServiceCode: 'standard',
        type: 'Standard',
        shippingCost: MoneyEntity(currency: 'USD', value: 10),
        additionalShippingCostPerUnit: MoneyEntity(currency: 'USD', value: 2),
      );

      expect(option.formatShippingPrice(1), r'$10.00');
    });

    test('should return base plus additional cost when quantity is greater than 1', () {
      const option = ShippingOptionEntity(
        shippingServiceCode: 'standard',
        type: 'Standard',
        shippingCost: MoneyEntity(currency: 'USD', value: 10),
        additionalShippingCostPerUnit: MoneyEntity(currency: 'USD', value: 2),
      );

      expect(option.formatShippingPrice(3), r'$10.00 + $4.00');
    });
  });
}