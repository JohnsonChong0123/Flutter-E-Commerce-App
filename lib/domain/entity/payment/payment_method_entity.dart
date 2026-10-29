import 'package:equatable/equatable.dart';

class PaymentMethodEntity extends Equatable {
  final String paymentMethodId;
  final String? brand;
  final String? last4;
  final int? expMonth;
  final int? expYear;

  const PaymentMethodEntity({
    required this.paymentMethodId,
    this.brand,
    this.last4,
    this.expMonth,
    this.expYear,
  });

  @override
  List<Object?> get props => [paymentMethodId, brand, last4, expMonth, expYear];
}
