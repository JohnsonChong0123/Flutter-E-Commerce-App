import 'package:fpdart/fpdart.dart';

import '../../core/errors/failure.dart';
import '../entity/payment/payment_intent_entity.dart';
import '../entity/payment/payment_method_entity.dart';
import '../entity/payment/setup_intent_entity.dart';

abstract interface class PaymentRepository {
  Future<Either<Failure, PaymentIntentEntity>> createPaymentIntent({
    required int amount,
    required String currency,
    String? paymentMethodId,
  });

  Future<Either<Failure, SetupIntentEntity>> createSetupIntent({
    String? customerId,
  });

  Future<Either<Failure, SetupIntentEntity>> getSetupIntent(
    String setupIntentId,
  );

  Future<Either<Failure, List<PaymentMethodEntity>>> getPaymentMethods();
}
