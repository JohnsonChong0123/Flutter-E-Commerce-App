part of 'checkout_bloc.dart';

class CheckoutState extends Equatable {
  final AddressEntity? selectedAddress;
  final PaymentIntentEntity? paymentIntent;
  final bool isPaymentLoading;
  final String? paymentError;

  const CheckoutState({
    this.selectedAddress,
    this.paymentIntent,
    this.isPaymentLoading = false,
    this.paymentError,
  });

  @override
  List<Object?> get props => [
    selectedAddress,
    paymentIntent,
    isPaymentLoading,
    paymentError,
  ];
}
