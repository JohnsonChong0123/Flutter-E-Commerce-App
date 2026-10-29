import 'package:equatable/equatable.dart';

import '../../../domain/entity/payment/payment_method_entity.dart';

class PaymentMethodModel extends Equatable {
  final String paymentMethodId;
  final String? brand;
  final String? last4;
  final int? expMonth;
  final int? expYear;

  const PaymentMethodModel({
    required this.paymentMethodId,
    this.brand,
    this.last4,
    this.expMonth,
    this.expYear,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      paymentMethodId: json['payment_method_id'] as String,
      brand: json['payment_method_brand'] as String?,
      last4: json['payment_method_last4'] as String?,
      expMonth: (json['payment_method_exp_month'] as num?)?.toInt(),
      expYear: (json['payment_method_exp_year'] as num?)?.toInt(),
    );
  }

  PaymentMethodEntity toEntity() {
    return PaymentMethodEntity(
      paymentMethodId: paymentMethodId,
      brand: brand,
      last4: last4,
      expMonth: expMonth,
      expYear: expYear,
    );
  }

  @override
  List<Object?> get props => [
    paymentMethodId,
    brand,
    last4,
    expMonth,
    expYear,
  ];
}
