import 'package:dio/dio.dart';
import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/models/payment/setup_intent_model.dart';
import 'package:e_commerce_client/data/sources/remote/payment_remote_data_setup.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late SetupIntentRemoteDataImpl setupIntentRemoteData;

  const setupIntentJson = {
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

  setUp(() {
    mockDio = MockDio();
    setupIntentRemoteData = SetupIntentRemoteDataImpl(dio: mockDio);
  });

  group('createSetupIntent', () {
    test('returns SetupIntentModel and sends customer id', () async {
      when(
        () => mockDio.post(
          '/payments/create-setup-intent',
          options: any(named: 'options'),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/payments/create-setup-intent'),
          statusCode: 200,
          data: setupIntentJson,
        ),
      );

      final result = await setupIntentRemoteData.createSetupIntent(
        customerId: 'cus_test_123',
      );

      expect(result, isA<SetupIntentModel>());
      expect(result.setupIntentId, 'seti_test_123');
      expect(result.clientSecret, 'seti_test_secret');
      expect(result.customerId, 'cus_test_123');
      expect(result.status, 'succeeded');
      verify(
        () => mockDio.post(
          '/payments/create-setup-intent',
          options: any(named: 'options'),
          data: {'customer_id': 'cus_test_123'},
        ),
      ).called(1);
    });

    test('omits customer id when it is not provided', () async {
      when(
        () => mockDio.post(
          '/payments/create-setup-intent',
          options: any(named: 'options'),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/payments/create-setup-intent'),
          statusCode: 200,
          data: setupIntentJson,
        ),
      );

      await setupIntentRemoteData.createSetupIntent();

      verify(
        () => mockDio.post(
          '/payments/create-setup-intent',
          options: any(named: 'options'),
          data: <String, dynamic>{},
        ),
      ).called(1);
    });

    test(
      'maps DioException to a create setup intent ServerException',
      () async {
        when(
          () => mockDio.post(
            '/payments/create-setup-intent',
            options: any(named: 'options'),
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: '/payments/create-setup-intent',
            ),
          ),
        );

        expect(
          () => setupIntentRemoteData.createSetupIntent(),
          throwsA(
            isA<ServerException>().having(
              (error) => error.message,
              'message',
              'Unable to create setup intent',
            ),
          ),
        );
      },
    );

    test('preserves ServerException from Dio', () async {
      const exception = ServerException('Setup intent rejected');
      when(
        () => mockDio.post(
          '/payments/create-setup-intent',
          options: any(named: 'options'),
          data: any(named: 'data'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/payments/create-setup-intent'),
          error: exception,
        ),
      );

      expect(
        () => setupIntentRemoteData.createSetupIntent(),
        throwsA(same(exception)),
      );
    });
  });

  group('getSetupIntent', () {
    test('returns SetupIntentModel for the requested id', () async {
      when(
        () => mockDio.get(
          '/payments/setup-intent/seti_test_123',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(
            path: '/payments/setup-intent/seti_test_123',
          ),
          statusCode: 200,
          data: setupIntentJson,
        ),
      );

      final result = await setupIntentRemoteData.getSetupIntent(
        'seti_test_123',
      );

      expect(result.setupIntentId, 'seti_test_123');
      expect(result.paymentMethodId, 'pm_card_visa');
      verify(
        () => mockDio.get(
          '/payments/setup-intent/seti_test_123',
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test(
      'maps DioException to a retrieve setup intent ServerException',
      () async {
        when(
          () => mockDio.get(
            '/payments/setup-intent/seti_test_123',
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: '/payments/setup-intent/seti_test_123',
            ),
          ),
        );

        expect(
          () => setupIntentRemoteData.getSetupIntent('seti_test_123'),
          throwsA(
            isA<ServerException>().having(
              (error) => error.message,
              'message',
              'Unable to retrieve setup intent',
            ),
          ),
        );
      },
    );

    test('wraps an invalid response as a ServerException', () async {
      when(
        () => mockDio.get(
          '/payments/setup-intent/seti_test_123',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(
            path: '/payments/setup-intent/seti_test_123',
          ),
          statusCode: 200,
          data: {'unexpected': true},
        ),
      );

      expect(
        () => setupIntentRemoteData.getSetupIntent('seti_test_123'),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
