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
