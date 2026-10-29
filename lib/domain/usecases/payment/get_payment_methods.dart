import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failure.dart';
import '../../../core/usecase/usecase.dart';
import '../../entity/payment/payment_method_entity.dart';
import '../../repositories/payment_repository.dart';

class GetPaymentMethods
    implements UseCase<List<PaymentMethodEntity>, NoParams> {
  final PaymentRepository repository;

  GetPaymentMethods(this.repository);

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> call(NoParams params) {
    return repository.getPaymentMethods();
  }
}
