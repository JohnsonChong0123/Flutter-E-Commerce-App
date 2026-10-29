import 'package:dio/dio.dart';

import '../../../core/errors/exception.dart';
import '../../models/payment/payment_intent_model.dart';

abstract interface class PaymentRemoteData {
  Future<PaymentIntentModel> createPaymentIntent({
    required int amount,
    required String currency,
    String? paymentMethodId,
  });
}

class PaymentRemoteDataImpl implements PaymentRemoteData {
  final Dio dio;

  PaymentRemoteDataImpl({required this.dio});

  @override
  Future<PaymentIntentModel> createPaymentIntent({
    required int amount,
    required String currency,
    String? paymentMethodId,
  }) async {
    try {
      final response = await dio.post(
        '/payments/create-intent',
        options: Options(extra: {'requiredAuth': true}),
        data: {
          'amount': amount,
          'currency': currency,
          if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
        },
      );
      return PaymentIntentModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (error) {
      if (error.error is ServerException) {
        throw error.error! as ServerException;
      }
      throw const ServerException('Unable to create payment');
    } catch (error) {
      throw ServerException(error.toString());
    }
  }
}
