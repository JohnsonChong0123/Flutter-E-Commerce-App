import 'package:e_commerce_client/data/models/payment/payment_intent_model.dart';
import 'package:e_commerce_client/data/models/payment/payment_method_model.dart';
import 'package:e_commerce_client/data/models/payment/setup_intent_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentIntentModel', () {
    test('fromJson should return valid PaymentIntentModel', () {
      const json = {
        'payment_intent_id': 'pi_test_123',
        'client_secret': 'pi_test_secret',
        'amount': 1999,
        'currency': 'usd',
        'status': 'requires_payment_method',
      };

      const expected = PaymentIntentModel(
        paymentIntentId: 'pi_test_123',
        clientSecret: 'pi_test_secret',
        amount: 1999,
        currency: 'usd',
        status: 'requires_payment_method',
      );

      final result = PaymentIntentModel.fromJson(json);

      expect(result, equals(expected));
    });

    test('fromJson should default status when status is null', () {
      const json = {
        'payment_intent_id': 'pi_test_456',
        'client_secret': 'pi_test_secret_2',
        'amount': 2500,
        'currency': 'myr',
      };

      const expected = PaymentIntentModel(
        paymentIntentId: 'pi_test_456',
        clientSecret: 'pi_test_secret_2',
        amount: 2500,
        currency: 'myr',
        status: 'requires_payment_method',
      );

      final result = PaymentIntentModel.fromJson(json);

      expect(result, equals(expected));
    });
  });

  group('PaymentMethodModel', () {
    test('fromJson should return valid PaymentMethodModel', () {
      const json = {
        'payment_method_id': 'pm_card_visa',
        'payment_method_brand': 'visa',
        'payment_method_last4': '4242',
        'payment_method_exp_month': 12,
        'payment_method_exp_year': 2030,
      };

      const expected = PaymentMethodModel(
        paymentMethodId: 'pm_card_visa',
        brand: 'visa',
        last4: '4242',
        expMonth: 12,
        expYear: 2030,
      );

      final result = PaymentMethodModel.fromJson(json);

      expect(result, equals(expected));
    });

    test('fromJson should allow optional fields to be null', () {
      const json = {'payment_method_id': 'pm_wallet'};

      const expected = PaymentMethodModel(
        paymentMethodId: 'pm_wallet',
        brand: null,
        last4: null,
        expMonth: null,
        expYear: null,
      );

      final result = PaymentMethodModel.fromJson(json);

      expect(result, equals(expected));
    });
  });

  group('SetupIntentModel', () {
    test('fromJson should return valid SetupIntentModel', () {
      const json = {
        'setup_intent_id': 'seti_test_123',
        'client_secret': 'seti_test_secret',
        'customer_id': 'cus_test_123',
        'status': 'succeeded',
        'payment_method_id': 'pm_card_visa',
        'payment_method_brand': 'visa',
        'payment_method_last4': '4242',
        'payment_method_exp_month': 12,
        'payment_method_exp_year': 2030,
      };

      const expected = SetupIntentModel(
        setupIntentId: 'seti_test_123',
        clientSecret: 'seti_test_secret',
        customerId: 'cus_test_123',
        status: 'succeeded',
        paymentMethodId: 'pm_card_visa',
        paymentMethodBrand: 'visa',
        paymentMethodLast4: '4242',
        paymentMethodExpMonth: 12,
        paymentMethodExpYear: 2030,
      );

      final result = SetupIntentModel.fromJson(json);

      expect(result, equals(expected));
    });

    test('fromJson should allow optional payment fields to be null', () {
      const json = {
        'setup_intent_id': 'seti_test_456',
        'client_secret': 'seti_test_secret_2',
        'customer_id': 'cus_test_456',
        'status': 'requires_action',
      };

      const expected = SetupIntentModel(
        setupIntentId: 'seti_test_456',
        clientSecret: 'seti_test_secret_2',
        customerId: 'cus_test_456',
        status: 'requires_action',
        paymentMethodId: null,
        paymentMethodBrand: null,
        paymentMethodLast4: null,
        paymentMethodExpMonth: null,
        paymentMethodExpYear: null,
      );

      final result = SetupIntentModel.fromJson(json);

      expect(result, equals(expected));
    });
  });
}
