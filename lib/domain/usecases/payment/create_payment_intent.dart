import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failure.dart';
import '../../../core/usecase/usecase.dart';
import '../../entity/payment/payment_intent_entity.dart';
import '../../repositories/payment_repository.dart';

class CreatePaymentIntentParams {
  final int amount;
  final String currency;
  final String? paymentMethodId;

  const CreatePaymentIntentParams({
    required this.amount,
    required this.currency,
    this.paymentMethodId,
  });
}

class CreatePaymentIntent
    implements UseCase<PaymentIntentEntity, CreatePaymentIntentParams> {
  final PaymentRepository repository;

  CreatePaymentIntent(this.repository);

  @override
  Future<Either<Failure, PaymentIntentEntity>> call(
    CreatePaymentIntentParams params,
  ) {
    return repository.createPaymentIntent(
      amount: params.amount,
      currency: params.currency,
      paymentMethodId: params.paymentMethodId,
    );
  }
}
