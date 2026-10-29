import 'package:equatable/equatable.dart';

import '../../../domain/entity/payment/payment_intent_entity.dart';

class PaymentIntentModel extends Equatable {
  final String paymentIntentId;
  final String clientSecret;
  final int amount;
  final String currency;
  final String status;

  const PaymentIntentModel({
    required this.paymentIntentId,
    required this.clientSecret,
    required this.amount,
    required this.currency,
    required this.status,
  });

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) {
    return PaymentIntentModel(
      paymentIntentId: json['payment_intent_id'] as String,
      clientSecret: json['client_secret'] as String,
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String,
      status: json['status'] as String? ?? 'requires_payment_method',
    );
  }

  PaymentIntentEntity toEntity() {
    return PaymentIntentEntity(
      paymentIntentId: paymentIntentId,
      clientSecret: clientSecret,
      amount: amount,
      currency: currency,
      status: status,
    );
  }

  @override
  List<Object?> get props => [
    paymentIntentId,
    clientSecret,
    amount,
    currency,
    status,
  ];
}
