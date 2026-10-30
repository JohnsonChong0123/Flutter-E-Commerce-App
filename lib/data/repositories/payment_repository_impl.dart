import 'package:fpdart/fpdart.dart';

import '../../core/errors/exception.dart';
import '../../core/errors/failure.dart';
import '../../domain/entity/payment/payment_intent_entity.dart';
import '../../domain/entity/payment/payment_method_entity.dart';
import '../../domain/entity/payment/setup_intent_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../sources/remote/payment_methods_remote_data.dart';
import '../sources/remote/payment_remote_data.dart';
import '../sources/remote/payment_remote_data_setup.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteData paymentRemoteData;
  final SetupIntentRemoteData setupIntentRemoteData;
  final PaymentMethodsRemoteData paymentMethodsRemoteData;

  PaymentRepositoryImpl({
    required this.paymentRemoteData,
    required this.setupIntentRemoteData,
    required this.paymentMethodsRemoteData,
  });

  @override
  Future<Either<Failure, PaymentIntentEntity>> createPaymentIntent({
    required int amount,
    required String currency,
    String? paymentMethodId,
  }) async {
    try {
      final paymentIntentModel = await paymentRemoteData.createPaymentIntent(
        amount: amount,
        currency: currency,
        paymentMethodId: paymentMethodId,
      );

      return right(paymentIntentModel.toEntity());
    } on ServerException catch (error) {
      return left(Failure(error.message));
    }
  }

  @override
  Future<Either<Failure, SetupIntentEntity>> createSetupIntent({
    String? customerId,
  }) async {
    try {
      final setupIntentModel = await setupIntentRemoteData.createSetupIntent(
        customerId: customerId,
      );

      return right(setupIntentModel.toEntity());
    } on ServerException catch (error) {
      return left(Failure(error.message));
    }
  }

  @override
  Future<Either<Failure, SetupIntentEntity>> getSetupIntent(
    String setupIntentId,
  ) async {
    try {
      final setupIntentModel = await setupIntentRemoteData.getSetupIntent(
        setupIntentId,
      );

      return right(setupIntentModel.toEntity());
    } on ServerException catch (error) {
      return left(Failure(error.message));
    }
  }

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> getPaymentMethods() async {
    try {
      final paymentMethods = await paymentMethodsRemoteData.getPaymentMethods();

      return right(
        paymentMethods.map((method) => method.toEntity()).toList(),
      );
    } on ServerException catch (error) {
      return left(Failure(error.message));
    }
  }
}
