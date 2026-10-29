import 'package:dio/dio.dart';
import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/models/payment/payment_intent_model.dart';
import 'package:e_commerce_client/data/sources/remote/payment_remote_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late PaymentRemoteDataImpl paymentRemoteData;

  const paymentIntentJson = {
    'payment_intent_id': 'pi_test_123',
    'client_secret': 'pi_test_secret',
    'amount': 1999,
    'currency': 'usd',
    'status': 'requires_payment_method',
  };

  setUp(() {
    mockDio = MockDio();
    paymentRemoteData = PaymentRemoteDataImpl(dio: mockDio);
  });

  group('createPaymentIntent', () {
    test('returns PaymentIntentModel and sends the payment method', () async {
      when(
        () => mockDio.post(
          '/payments/create-intent',
          options: any(named: 'options'),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/payments/create-intent'),
          statusCode: 200,
          data: paymentIntentJson,
        ),
      );

      final result = await paymentRemoteData.createPaymentIntent(
        amount: 1999,
        currency: 'usd',
        paymentMethodId: 'pm_card_visa',
      );

      expect(result, isA<PaymentIntentModel>());
      expect(result.paymentIntentId, 'pi_test_123');
      expect(result.clientSecret, 'pi_test_secret');
      expect(result.amount, 1999);
      expect(result.currency, 'usd');
      expect(result.status, 'requires_payment_method');
      verify(
        () => mockDio.post(
          '/payments/create-intent',
          options: any(named: 'options'),
          data: {
            'amount': 1999,
            'currency': 'usd',
            'payment_method_id': 'pm_card_visa',
          },
        ),
      ).called(1);
    });

    test('omits payment method when it is not provided', () async {
      when(
        () => mockDio.post(
          '/payments/create-intent',
          options: any(named: 'options'),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/payments/create-intent'),
          statusCode: 200,
          data: paymentIntentJson,
        ),
      );

      await paymentRemoteData.createPaymentIntent(
        amount: 1999,
        currency: 'usd',
      );

      verify(
        () => mockDio.post(
          '/payments/create-intent',
          options: any(named: 'options'),
          data: {'amount': 1999, 'currency': 'usd'},
        ),
      ).called(1);
    });

    test('preserves ServerException from Dio', () async {
      const exception = ServerException('Payment rejected');
      when(
        () => mockDio.post(
          '/payments/create-intent',
          options: any(named: 'options'),
          data: any(named: 'data'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/payments/create-intent'),
          error: exception,
        ),
      );

      expect(
        () => paymentRemoteData.createPaymentIntent(
          amount: 1999,
          currency: 'usd',
        ),
        throwsA(same(exception)),
      );
    });

    test(
      'maps an unexpected DioException to a payment ServerException',
      () async {
        when(
          () => mockDio.post(
            '/payments/create-intent',
            options: any(named: 'options'),
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/payments/create-intent'),
          ),
        );

        expect(
          () => paymentRemoteData.createPaymentIntent(
            amount: 1999,
            currency: 'usd',
          ),
          throwsA(
            isA<ServerException>().having(
              (error) => error.message,
              'message',
              'Unable to create payment',
            ),
          ),
        );
      },
    );

    test('wraps an invalid response as a ServerException', () async {
      when(
        () => mockDio.post(
          '/payments/create-intent',
          options: any(named: 'options'),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/payments/create-intent'),
          statusCode: 200,
          data: {'unexpected': true},
        ),
      );

      expect(
        () => paymentRemoteData.createPaymentIntent(
          amount: 1999,
          currency: 'usd',
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
