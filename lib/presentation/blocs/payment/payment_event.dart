part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class LoadPaymentMethodsEvent extends PaymentEvent {
  const LoadPaymentMethodsEvent();
}

class CreateSetupIntentEvent extends PaymentEvent {
  final String? customerId;

  const CreateSetupIntentEvent({this.customerId});

  @override
  List<Object?> get props => [customerId];
}

class VerifySetupIntentEvent extends PaymentEvent {
  final String setupIntentId;

  const VerifySetupIntentEvent(this.setupIntentId);

  @override
  List<Object?> get props => [setupIntentId];
}
