part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  final SetupIntentEntity? setupIntent;
  final bool isSetupIntentLoading;
  final String? setupIntentError;
  final List<PaymentMethodEntity> paymentMethods;
  final bool isPaymentMethodsLoading;
  final String? paymentMethodsError;

  const PaymentState({
    this.setupIntent,
    this.isSetupIntentLoading = false,
    this.setupIntentError,
    this.paymentMethods = const [],
    this.isPaymentMethodsLoading = false,
    this.paymentMethodsError,
  });

  @override
  List<Object?> get props => [
    setupIntent,
    isSetupIntentLoading,
    setupIntentError,
    paymentMethods,
    isPaymentMethodsLoading,
    paymentMethodsError,
  ];
}
