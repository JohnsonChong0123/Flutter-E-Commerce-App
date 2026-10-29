import 'package:dio/dio.dart';
import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/models/payment/payment_method_model.dart';
import 'package:e_commerce_client/data/sources/remote/payment_methods_remote_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late PaymentMethodsRemoteDataImpl paymentMethodsRemoteData;

  const paymentMethodsJson = [
    {
      'payment_method_id': 'pm_card_visa',
      'payment_method_brand': 'visa',
      'payment_method_last4': '4242',
      'payment_method_exp_month': 12,
      'payment_method_exp_year': 2030,
    },
    {
      'payment_method_id': 'pm_card_mastercard',
      'payment_method_brand': 'mastercard',
      'payment_method_last4': '4444',
      'payment_method_exp_month': 6,
      'payment_method_exp_year': 2029,
    },
  ];

  setUp(() {
    mockDio = MockDio();
    paymentMethodsRemoteData = PaymentMethodsRemoteDataImpl(dio: mockDio);
  });

  group('getPaymentMethods', () {
    test('returns payment methods and requests authenticated data', () async {
      when(
        () => mockDio.get(
          '/payments/payment-methods',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/payments/payment-methods'),
          statusCode: 200,
          data: paymentMethodsJson,
        ),
      );

      final result = await paymentMethodsRemoteData.getPaymentMethods();

      expect(result, hasLength(2));
      expect(result.first, isA<PaymentMethodModel>());
      expect(result.first.paymentMethodId, 'pm_card_visa');
      expect(result.first.brand, 'visa');
      expect(result.first.last4, '4242');
      expect(result.first.expMonth, 12);
      expect(result.first.expYear, 2030);
      verify(
        () => mockDio.get(
          '/payments/payment-methods',
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('preserves ServerException from Dio', () async {
      const exception = ServerException('Authentication required');
      when(
        () => mockDio.get(
          '/payments/payment-methods',
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/payments/payment-methods'),
          error: exception,
        ),
      );

      expect(
        () => paymentMethodsRemoteData.getPaymentMethods(),
        throwsA(same(exception)),
      );
    });

    test('maps an unexpected DioException to a ServerException', () async {
      when(
        () => mockDio.get(
          '/payments/payment-methods',
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/payments/payment-methods'),
        ),
      );

      expect(
        () => paymentMethodsRemoteData.getPaymentMethods(),
        throwsA(
          isA<ServerException>().having(
            (error) => error.message,
            'message',
            'Unable to retrieve payment methods',
          ),
        ),
      );
    });

    test('wraps an invalid response as a ServerException', () async {
      when(
        () => mockDio.get(
          '/payments/payment-methods',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/payments/payment-methods'),
          statusCode: 200,
          data: {'unexpected': true},
        ),
      );

      expect(
        () => paymentMethodsRemoteData.getPaymentMethods(),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
