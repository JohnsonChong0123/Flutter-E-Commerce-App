import 'package:equatable/equatable.dart';

class PaymentIntentEntity extends Equatable {
  final String paymentIntentId;
  final String clientSecret;
  final int amount;
  final String currency;
  final String status;

  const PaymentIntentEntity({
    required this.paymentIntentId,
    required this.clientSecret,
    required this.amount,
    required this.currency,
    required this.status,
  });

  @override
  List<Object?> get props => [
    paymentIntentId,
    clientSecret,
    amount,
    currency,
    status,
  ];
}
