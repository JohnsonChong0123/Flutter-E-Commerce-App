part of 'checkout_bloc.dart';

sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class UpdateCheckoutAddressEvent extends CheckoutEvent {
  final AddressEntity address;

  const UpdateCheckoutAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class CreatePaymentIntentEvent extends CheckoutEvent {
  final double total;
  final String currency;
  final String? paymentMethodId;

  const CreatePaymentIntentEvent({
    required this.total,
    this.currency = 'usd',
    this.paymentMethodId,
  });

  @override
  List<Object?> get props => [total, currency, paymentMethodId];
}
