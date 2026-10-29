import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failure.dart';
import '../../../core/usecase/usecase.dart';
import '../../entity/payment/setup_intent_entity.dart';
import '../../repositories/payment_repository.dart';

class GetSetupIntent
    implements UseCase<SetupIntentEntity, GetSetupIntentParams> {
  final PaymentRepository repository;

  GetSetupIntent(this.repository);

  @override
  Future<Either<Failure, SetupIntentEntity>> call(GetSetupIntentParams params) {
    return repository.getSetupIntent(params.setupIntentId);
  }
}

class GetSetupIntentParams {
  final String setupIntentId;

  const GetSetupIntentParams(this.setupIntentId);
}
