import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/data/models/payment/payment_intent_model.dart';
import 'package:e_commerce_client/data/models/payment/payment_method_model.dart';
import 'package:e_commerce_client/data/models/payment/setup_intent_model.dart';
import 'package:e_commerce_client/data/repositories/payment_repository_impl.dart';
import 'package:e_commerce_client/data/sources/remote/payment_methods_remote_data.dart';
import 'package:e_commerce_client/data/sources/remote/payment_remote_data.dart';
import 'package:e_commerce_client/data/sources/remote/payment_remote_data_setup.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPaymentRemoteData extends Mock implements PaymentRemoteData {}

class MockSetupIntentRemoteData extends Mock implements SetupIntentRemoteData {}

class MockPaymentMethodsRemoteData extends Mock
    implements PaymentMethodsRemoteData {}

void main() {
  late MockPaymentRemoteData mockPaymentRemoteData;
  late MockSetupIntentRemoteData mockSetupIntentRemoteData;
  late MockPaymentMethodsRemoteData mockPaymentMethodsRemoteData;
  late PaymentRepositoryImpl paymentRepository;

  const tPaymentIntent = PaymentIntentModel(
    paymentIntentId: 'pi_test_123',
    clientSecret: 'pi_test_secret',
    amount: 1999,
    currency: 'usd',
    status: 'requires_payment_method',
  );

  const tSetupIntent = SetupIntentModel(
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

  const tPaymentMethods = [
    PaymentMethodModel(
      paymentMethodId: 'pm_card_visa',
      brand: 'visa',
      last4: '4242',
      expMonth: 12,
      expYear: 2030,
    ),
    PaymentMethodModel(
      paymentMethodId: 'pm_card_mastercard',
      brand: 'mastercard',
      last4: '4444',
      expMonth: 6,
      expYear: 2029,
    ),
  ];

  setUp(() {
    mockPaymentRemoteData = MockPaymentRemoteData();
    mockSetupIntentRemoteData = MockSetupIntentRemoteData();
    mockPaymentMethodsRemoteData = MockPaymentMethodsRemoteData();
    paymentRepository = PaymentRepositoryImpl(
      paymentRemoteData: mockPaymentRemoteData,
      setupIntentRemoteData: mockSetupIntentRemoteData,
      paymentMethodsRemoteData: mockPaymentMethodsRemoteData,
    );
  });

  group('createPaymentIntent', () {
    test('should return Right(PaymentIntentEntity) when success', () async {
      when(
        () => mockPaymentRemoteData.createPaymentIntent(
          amount: 1999,
          currency: 'usd',
          paymentMethodId: 'pm_card_visa',
        ),
      ).thenAnswer((_) async => tPaymentIntent);

      final result = await paymentRepository.createPaymentIntent(
        amount: 1999,
        currency: 'usd',
        paymentMethodId: 'pm_card_visa',
      );

      final actual = result.fold(
        (failure) => fail('Expected Right, got Left: $failure'),
        (paymentIntent) => paymentIntent,
      );

      expect(actual.paymentIntentId, 'pi_test_123');
      expect(actual.clientSecret, 'pi_test_secret');
      expect(actual.amount, 1999);
      expect(actual.currency, 'usd');
      expect(actual.status, 'requires_payment_method');
      verify(
        () => mockPaymentRemoteData.createPaymentIntent(
          amount: 1999,
          currency: 'usd',
          paymentMethodId: 'pm_card_visa',
        ),
      ).called(1);
    });

    test('should return Left(Failure) when ServerException occurs', () async {
      when(
        () => mockPaymentRemoteData.createPaymentIntent(
          amount: 1999,
          currency: 'usd',
          paymentMethodId: 'pm_card_visa',
        ),
      ).thenThrow(const ServerException('Payment failed'));

      final result = await paymentRepository.createPaymentIntent(
        amount: 1999,
        currency: 'usd',
        paymentMethodId: 'pm_card_visa',
      );

      final actual = result.fold(
        (failure) => failure,
        (paymentIntent) => fail('Expected Left, got Right: $paymentIntent'),
      );

      expect(actual, const Failure('Payment failed'));
    });
  });

  group('createSetupIntent', () {
    test('should return Right(SetupIntentEntity) when success', () async {
      when(
        () => mockSetupIntentRemoteData.createSetupIntent(
          customerId: 'cus_test_123',
        ),
      ).thenAnswer((_) async => tSetupIntent);

      final result = await paymentRepository.createSetupIntent(
        customerId: 'cus_test_123',
      );

      final actual = result.fold(
        (failure) => fail('Expected Right, got Left: $failure'),
        (setupIntent) => setupIntent,
      );

      expect(actual.setupIntentId, 'seti_test_123');
      expect(actual.clientSecret, 'seti_test_secret');
      expect(actual.customerId, 'cus_test_123');
      expect(actual.status, 'succeeded');
      expect(actual.paymentMethodId, 'pm_card_visa');
      expect(actual.paymentMethodBrand, 'visa');
      expect(actual.paymentMethodLast4, '4242');
      expect(actual.paymentMethodExpMonth, 12);
      expect(actual.paymentMethodExpYear, 2030);
      verify(
        () => mockSetupIntentRemoteData.createSetupIntent(
          customerId: 'cus_test_123',
        ),
      ).called(1);
    });

    test('should return Left(Failure) when ServerException occurs', () async {
      when(
        () => mockSetupIntentRemoteData.createSetupIntent(
          customerId: 'cus_test_123',
        ),
      ).thenThrow(const ServerException('Setup intent failed'));

      final result = await paymentRepository.createSetupIntent(
        customerId: 'cus_test_123',
      );

      final actual = result.fold(
        (failure) => failure,
        (setupIntent) => fail('Expected Left, got Right: $setupIntent'),
      );

      expect(actual, const Failure('Setup intent failed'));
    });
  });

  group('getSetupIntent', () {
    test('should return Right(SetupIntentEntity) when success', () async {
      when(
        () => mockSetupIntentRemoteData.getSetupIntent('seti_test_123'),
      ).thenAnswer((_) async => tSetupIntent);

      final result = await paymentRepository.getSetupIntent('seti_test_123');

      final actual = result.fold(
        (failure) => fail('Expected Right, got Left: $failure'),
        (setupIntent) => setupIntent,
      );

      expect(actual.setupIntentId, 'seti_test_123');
      expect(actual.clientSecret, 'seti_test_secret');
      expect(actual.customerId, 'cus_test_123');
      expect(actual.status, 'succeeded');
      expect(actual.paymentMethodId, 'pm_card_visa');
      expect(actual.paymentMethodBrand, 'visa');
      expect(actual.paymentMethodLast4, '4242');
      expect(actual.paymentMethodExpMonth, 12);
      expect(actual.paymentMethodExpYear, 2030);
      verify(
        () => mockSetupIntentRemoteData.getSetupIntent('seti_test_123'),
      ).called(1);
    });

    test('should return Left(Failure) when ServerException occurs', () async {
      when(
        () => mockSetupIntentRemoteData.getSetupIntent('seti_test_123'),
      ).thenThrow(const ServerException('Get setup intent failed'));

      final result = await paymentRepository.getSetupIntent('seti_test_123');

      final actual = result.fold(
        (failure) => failure,
        (setupIntent) => fail('Expected Left, got Right: $setupIntent'),
      );

      expect(actual, const Failure('Get setup intent failed'));
    });
  });

  group('getPaymentMethods', () {
    test(
      'should return Right(List<PaymentMethodEntity>) when success',
      () async {
        when(
          () => mockPaymentMethodsRemoteData.getPaymentMethods(),
        ).thenAnswer((_) async => tPaymentMethods);

        final result = await paymentRepository.getPaymentMethods();

        final actual = result.fold(
          (failure) => fail('Expected Right, got Left: $failure'),
          (paymentMethods) => paymentMethods,
        );

        expect(actual, hasLength(2));
        expect(actual.first.paymentMethodId, 'pm_card_visa');
        expect(actual.first.brand, 'visa');
        expect(actual.first.last4, '4242');
        expect(actual.first.expMonth, 12);
        expect(actual.first.expYear, 2030);
        expect(actual[1].paymentMethodId, 'pm_card_mastercard');
        expect(actual[1].brand, 'mastercard');
        expect(actual[1].last4, '4444');
        expect(actual[1].expMonth, 6);
        expect(actual[1].expYear, 2029);
        verify(
          () => mockPaymentMethodsRemoteData.getPaymentMethods(),
        ).called(1);
      },
    );

    test('should return Left(Failure) when ServerException occurs', () async {
      when(
        () => mockPaymentMethodsRemoteData.getPaymentMethods(),
      ).thenThrow(const ServerException('Get payment methods failed'));

      final result = await paymentRepository.getPaymentMethods();

      final actual = result.fold(
        (failure) => failure,
        (paymentMethods) => fail('Expected Left, got Right: $paymentMethods'),
      );

      expect(actual, const Failure('Get payment methods failed'));
    });
  });
}
