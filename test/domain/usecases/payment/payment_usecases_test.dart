import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/entity/payment/payment_intent_entity.dart';
import 'package:e_commerce_client/domain/entity/payment/payment_method_entity.dart';
import 'package:e_commerce_client/domain/entity/payment/setup_intent_entity.dart';
import 'package:e_commerce_client/domain/repositories/payment_repository.dart';
import 'package:e_commerce_client/domain/usecases/payment/create_payment_intent.dart';
import 'package:e_commerce_client/domain/usecases/payment/create_setup_intent.dart';
import 'package:e_commerce_client/domain/usecases/payment/get_payment_methods.dart';
import 'package:e_commerce_client/domain/usecases/payment/get_setup_intent.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockPaymentRepository extends Mock implements PaymentRepository {}

void main() {
  late MockPaymentRepository mockRepository;

  const paymentIntent = PaymentIntentEntity(
    paymentIntentId: 'pi_test_123',
    clientSecret: 'pi_test_secret',
    amount: 1999,
    currency: 'usd',
    status: 'requires_payment_method',
  );

  const setupIntent = SetupIntentEntity(
    setupIntentId: 'seti_test_123',
    clientSecret: 'seti_test_secret',
    customerId: 'cus_test_123',
    status: 'succeeded',
  );

  const paymentMethods = [
    PaymentMethodEntity(
      paymentMethodId: 'pm_card_visa',
      brand: 'visa',
      last4: '4242',
      expMonth: 12,
      expYear: 2030,
    ),
  ];

  const failure = Failure('Payment service unavailable');

  setUp(() {
    mockRepository = MockPaymentRepository();
  });

  group('CreatePaymentIntent', () {
    const params = CreatePaymentIntentParams(
      amount: 1999,
      currency: 'usd',
      paymentMethodId: 'pm_card_visa',
    );

    test(
      'returns payment intent and forwards all parameters on success',
      () async {
        when(
          () => mockRepository.createPaymentIntent(
            amount: params.amount,
            currency: params.currency,
            paymentMethodId: params.paymentMethodId,
          ),
        ).thenAnswer((_) async => const Right(paymentIntent));

        final result = await CreatePaymentIntent(mockRepository)(params);

        expect(result, const Right(paymentIntent));
        verify(
          () => mockRepository.createPaymentIntent(
            amount: 1999,
            currency: 'usd',
            paymentMethodId: 'pm_card_visa',
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('returns repository failure', () async {
      when(
        () => mockRepository.createPaymentIntent(
          amount: params.amount,
          currency: params.currency,
          paymentMethodId: params.paymentMethodId,
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await CreatePaymentIntent(mockRepository)(params);

      expect(result, const Left(failure));
      verify(
        () => mockRepository.createPaymentIntent(
          amount: 1999,
          currency: 'usd',
          paymentMethodId: 'pm_card_visa',
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('CreateSetupIntent', () {
    const params = CreateSetupIntentParams(customerId: 'cus_test_123');

    test('returns setup intent and forwards customer id on success', () async {
      when(
        () => mockRepository.createSetupIntent(customerId: params.customerId),
      ).thenAnswer((_) async => const Right(setupIntent));

      final result = await CreateSetupIntent(mockRepository)(params);

      expect(result, const Right(setupIntent));
      verify(
        () => mockRepository.createSetupIntent(customerId: 'cus_test_123'),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('returns repository failure', () async {
      when(
        () => mockRepository.createSetupIntent(customerId: params.customerId),
      ).thenAnswer((_) async => const Left(failure));

      final result = await CreateSetupIntent(mockRepository)(params);

      expect(result, const Left(failure));
      verify(
        () => mockRepository.createSetupIntent(customerId: 'cus_test_123'),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('GetPaymentMethods', () {
    test('returns payment methods on success', () async {
      when(
        () => mockRepository.getPaymentMethods(),
      ).thenAnswer((_) async => const Right(paymentMethods));

      final result = await GetPaymentMethods(mockRepository)(NoParams());

      expect(result, const Right(paymentMethods));
      verify(() => mockRepository.getPaymentMethods()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('returns repository failure', () async {
      when(
        () => mockRepository.getPaymentMethods(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await GetPaymentMethods(mockRepository)(NoParams());

      expect(result, const Left(failure));
      verify(() => mockRepository.getPaymentMethods()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('GetSetupIntent', () {
    const params = GetSetupIntentParams('seti_test_123');

    test('returns setup intent and forwards id on success', () async {
      when(
        () => mockRepository.getSetupIntent(params.setupIntentId),
      ).thenAnswer((_) async => const Right(setupIntent));

      final result = await GetSetupIntent(mockRepository)(params);

      expect(result, const Right(setupIntent));
      verify(() => mockRepository.getSetupIntent('seti_test_123')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('returns repository failure', () async {
      when(
        () => mockRepository.getSetupIntent(params.setupIntentId),
      ).thenAnswer((_) async => const Left(failure));

      final result = await GetSetupIntent(mockRepository)(params);

      expect(result, const Left(failure));
      verify(() => mockRepository.getSetupIntent('seti_test_123')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
