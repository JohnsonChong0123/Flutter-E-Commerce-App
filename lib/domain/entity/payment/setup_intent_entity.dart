import 'package:equatable/equatable.dart';

class SetupIntentEntity extends Equatable {
  final String setupIntentId;
  final String clientSecret;
  final String customerId;
  final String status;
  final String? paymentMethodId;
  final String? paymentMethodBrand;
  final String? paymentMethodLast4;
  final int? paymentMethodExpMonth;
  final int? paymentMethodExpYear;

  const SetupIntentEntity({
    required this.setupIntentId,
    required this.clientSecret,
    required this.customerId,
    required this.status,
    this.paymentMethodId,
    this.paymentMethodBrand,
    this.paymentMethodLast4,
    this.paymentMethodExpMonth,
    this.paymentMethodExpYear,
  });

  @override
  List<Object?> get props => [
    setupIntentId,
    clientSecret,
    customerId,
    status,
    paymentMethodId,
    paymentMethodBrand,
    paymentMethodLast4,
    paymentMethodExpMonth,
    paymentMethodExpYear,
  ];
}
