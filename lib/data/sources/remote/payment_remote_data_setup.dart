import 'package:dio/dio.dart';

import '../../../core/errors/exception.dart';
import '../../models/payment/setup_intent_model.dart';

abstract interface class SetupIntentRemoteData {
  Future<SetupIntentModel> createSetupIntent({String? customerId});
  Future<SetupIntentModel> getSetupIntent(String setupIntentId);
}

class SetupIntentRemoteDataImpl implements SetupIntentRemoteData {
  final Dio dio;

  SetupIntentRemoteDataImpl({required this.dio});

  @override
  Future<SetupIntentModel> createSetupIntent({String? customerId}) async {
    try {
      final response = await dio.post(
        '/payments/create-setup-intent',
        options: Options(extra: {'requiredAuth': true}),
        data: {if (customerId != null) 'customer_id': customerId},
      );
      return SetupIntentModel.fromJson(_asJson(response.data));
    } on DioException catch (error) {
      throw _toServerException(error, 'Unable to create setup intent');
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  @override
  Future<SetupIntentModel> getSetupIntent(String setupIntentId) async {
    try {
      final response = await dio.get(
        '/payments/setup-intent/$setupIntentId',
        options: Options(extra: {'requiredAuth': true}),
      );
      return SetupIntentModel.fromJson(_asJson(response.data));
    } on DioException catch (error) {
      throw _toServerException(error, 'Unable to retrieve setup intent');
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Map<String, dynamic> _asJson(Object? data) {
    return Map<String, dynamic>.from(data as Map);
  }

  ServerException _toServerException(
    DioException error,
    String fallbackMessage,
  ) {
    if (error.error is ServerException) {
      return error.error! as ServerException;
    }
    return ServerException(fallbackMessage);
  }
}
