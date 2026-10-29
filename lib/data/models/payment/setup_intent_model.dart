import 'package:equatable/equatable.dart';

import '../../../domain/entity/payment/setup_intent_entity.dart';

class SetupIntentModel extends Equatable {
  final String setupIntentId;
  final String clientSecret;
  final String customerId;
  final String status;
  final String? paymentMethodId;
  final String? paymentMethodBrand;
  final String? paymentMethodLast4;
  final int? paymentMethodExpMonth;
  final int? paymentMethodExpYear;

  const SetupIntentModel({
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

  factory SetupIntentModel.fromJson(Map<String, dynamic> json) {
    return SetupIntentModel(
      setupIntentId: json['setup_intent_id'] as String,
      clientSecret: json['client_secret'] as String,
      customerId: json['customer_id'] as String,
      status: json['status'] as String,
      paymentMethodId: json['payment_method_id'] as String?,
      paymentMethodBrand: json['payment_method_brand'] as String?,
      paymentMethodLast4: json['payment_method_last4'] as String?,
      paymentMethodExpMonth: (json['payment_method_exp_month'] as num?)
          ?.toInt(),
      paymentMethodExpYear: (json['payment_method_exp_year'] as num?)?.toInt(),
    );
  }

  SetupIntentEntity toEntity() {
    return SetupIntentEntity(
      setupIntentId: setupIntentId,
      clientSecret: clientSecret,
      customerId: customerId,
      status: status,
      paymentMethodId: paymentMethodId,
      paymentMethodBrand: paymentMethodBrand,
      paymentMethodLast4: paymentMethodLast4,
      paymentMethodExpMonth: paymentMethodExpMonth,
      paymentMethodExpYear: paymentMethodExpYear,
    );
  }

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
