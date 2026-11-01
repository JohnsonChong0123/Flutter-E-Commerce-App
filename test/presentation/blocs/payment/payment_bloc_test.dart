import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/entity/payment/payment_method_entity.dart';
import 'package:e_commerce_client/domain/entity/payment/setup_intent_entity.dart';
import 'package:e_commerce_client/domain/usecases/payment/create_setup_intent.dart';
import 'package:e_commerce_client/domain/usecases/payment/get_payment_methods.dart';
import 'package:e_commerce_client/domain/usecases/payment/get_setup_intent.dart';
import 'package:e_commerce_client/presentation/blocs/payment/payment_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateSetupIntent extends Mock implements CreateSetupIntent {}

class MockGetSetupIntent extends Mock implements GetSetupIntent {}

class MockGetPaymentMethods extends Mock implements GetPaymentMethods {}

void main() {
  late MockCreateSetupIntent mockCreateSetupIntent;
  late MockGetSetupIntent mockGetSetupIntent;
  late MockGetPaymentMethods mockGetPaymentMethods;

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

  setUpAll(() {
    registerFallbackValue(
      const CreateSetupIntentParams(customerId: 'fallback_customer'),
    );
    registerFallbackValue(const GetSetupIntentParams('fallback_setup_intent'));
  });

  setUp(() {
    mockCreateSetupIntent = MockCreateSetupIntent();
    mockGetSetupIntent = MockGetSetupIntent();
    mockGetPaymentMethods = MockGetPaymentMethods();
  });

  test('initial state has no setup intent or payment methods', () {
    final bloc = PaymentBloc();
    addTearDown(bloc.close);

    expect(bloc.state, const PaymentState());
  });

  group('LoadPaymentMethodsEvent', () {
    blocTest<PaymentBloc, PaymentState>(
      'emits loading then loaded state on success',
      build: () {
        when(
          () => mockGetPaymentMethods(NoParams()),
        ).thenAnswer((_) async => const Right(paymentMethods));
        return PaymentBloc(getPaymentMethods: mockGetPaymentMethods);
      },
      act: (bloc) => bloc.add(const LoadPaymentMethodsEvent()),
      expect: () => [
        const PaymentState(isPaymentMethodsLoading: true),
        const PaymentState(paymentMethods: paymentMethods),
      ],
      verify: (_) {
        verify(() => mockGetPaymentMethods(NoParams())).called(1);
      },
    );

    blocTest<PaymentBloc, PaymentState>(
      'emits loading then error state when loading fails',
      build: () {
        when(() => mockGetPaymentMethods(NoParams())).thenAnswer(
          (_) async => const Left(Failure('Unable to load methods')),
        );
        return PaymentBloc(getPaymentMethods: mockGetPaymentMethods);
      },
      act: (bloc) => bloc.add(const LoadPaymentMethodsEvent()),
      expect: () => [
        const PaymentState(isPaymentMethodsLoading: true),
        const PaymentState(paymentMethodsError: 'Unable to load methods'),
      ],
    );

    blocTest<PaymentBloc, PaymentState>(
      'emits configuration error when use case is unavailable',
      build: () => PaymentBloc(),
      act: (bloc) => bloc.add(const LoadPaymentMethodsEvent()),
      expect: () => [
        const PaymentState(isPaymentMethodsLoading: true),
        const PaymentState(paymentMethodsError: 'Payment is not configured'),
      ],
    );
  });

  group('CreateSetupIntentEvent', () {
    blocTest<PaymentBloc, PaymentState>(
      'emits loading then setup intent on success',
      build: () {
        when(
          () => mockCreateSetupIntent(any()),
        ).thenAnswer((_) async => const Right(setupIntent));
        return PaymentBloc(createSetupIntent: mockCreateSetupIntent);
      },
      act: (bloc) =>
          bloc.add(const CreateSetupIntentEvent(customerId: 'cus_test_123')),
      expect: () => [
        const PaymentState(isSetupIntentLoading: true),
        const PaymentState(setupIntent: setupIntent),
      ],
      verify: (_) {
        verify(() => mockCreateSetupIntent(any())).called(1);
      },
    );

    blocTest<PaymentBloc, PaymentState>(
      'emits loading then error when creating setup intent fails',
      build: () {
        when(
          () => mockCreateSetupIntent(any()),
        ).thenAnswer((_) async => const Left(Failure('Creation failed')));
        return PaymentBloc(createSetupIntent: mockCreateSetupIntent);
      },
      act: (bloc) =>
          bloc.add(const CreateSetupIntentEvent(customerId: 'cus_test_123')),
      expect: () => [
        const PaymentState(isSetupIntentLoading: true),
        const PaymentState(setupIntentError: 'Creation failed'),
      ],
    );

    blocTest<PaymentBloc, PaymentState>(
      'emits configuration error when create use case is unavailable',
      build: () => PaymentBloc(),
      act: (bloc) => bloc.add(const CreateSetupIntentEvent()),
      expect: () => [
        const PaymentState(isSetupIntentLoading: true),
        const PaymentState(setupIntentError: 'Payment is not configured'),
      ],
    );
  });

  group('VerifySetupIntentEvent', () {
    blocTest<PaymentBloc, PaymentState>(
      'emits loading then verified setup intent on success',
      build: () {
        when(
          () => mockGetSetupIntent(any()),
        ).thenAnswer((_) async => const Right(setupIntent));
        return PaymentBloc(getSetupIntent: mockGetSetupIntent);
      },
      act: (bloc) => bloc.add(const VerifySetupIntentEvent('seti_test_123')),
      expect: () => [
        const PaymentState(isSetupIntentLoading: true),
        const PaymentState(setupIntent: setupIntent),
      ],
      verify: (_) {
        verify(() => mockGetSetupIntent(any())).called(1);
      },
    );

    blocTest<PaymentBloc, PaymentState>(
      'emits loading then error when verification fails',
      build: () {
        when(
          () => mockGetSetupIntent(any()),
        ).thenAnswer((_) async => const Left(Failure('Verification failed')));
        return PaymentBloc(getSetupIntent: mockGetSetupIntent);
      },
      act: (bloc) => bloc.add(const VerifySetupIntentEvent('seti_test_123')),
      expect: () => [
        const PaymentState(isSetupIntentLoading: true),
        const PaymentState(setupIntentError: 'Verification failed'),
      ],
    );

    blocTest<PaymentBloc, PaymentState>(
      'emits configuration error when verify use case is unavailable',
      build: () => PaymentBloc(),
      act: (bloc) => bloc.add(const VerifySetupIntentEvent('seti_test_123')),
      expect: () => [
        const PaymentState(setupIntentError: 'Payment is not configured'),
      ],
    );
  });
}
