import 'package:dio/dio.dart';

import '../../../core/errors/exception.dart';
import '../../models/payment/payment_method_model.dart';

abstract interface class PaymentMethodsRemoteData {
  Future<List<PaymentMethodModel>> getPaymentMethods();
}

class PaymentMethodsRemoteDataImpl implements PaymentMethodsRemoteData {
  final Dio dio;

  PaymentMethodsRemoteDataImpl({required this.dio});

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    try {
      final response = await dio.get(
        '/payments/payment-methods',
        options: Options(extra: {'requiredAuth': true}),
      );
      final data = response.data as List;
      return data
          .map(
            (item) => PaymentMethodModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    } on DioException catch (error) {
      if (error.error is ServerException) {
        throw error.error! as ServerException;
      }
      throw const ServerException('Unable to retrieve payment methods');
    } catch (error) {
      throw ServerException(error.toString());
    }
  }
}
