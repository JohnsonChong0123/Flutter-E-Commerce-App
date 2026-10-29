import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failure.dart';
import '../../../core/usecase/usecase.dart';
import '../../entity/payment/setup_intent_entity.dart';
import '../../repositories/payment_repository.dart';

class CreateSetupIntentParams {
  final String? customerId;

  const CreateSetupIntentParams({this.customerId});
}

class CreateSetupIntent
    implements UseCase<SetupIntentEntity, CreateSetupIntentParams> {
  final PaymentRepository repository;

  CreateSetupIntent(this.repository);

  @override
  Future<Either<Failure, SetupIntentEntity>> call(
    CreateSetupIntentParams params,
  ) {
    return repository.createSetupIntent(customerId: params.customerId);
  }
}
