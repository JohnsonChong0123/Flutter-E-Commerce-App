part of 'checkout_bloc.dart';

class CheckoutState extends Equatable {
  final AddressEntity? selectedAddress;

  const CheckoutState({this.selectedAddress});

  CheckoutState copyWith({
    AddressEntity? selectedAddress,
    bool clearAddress = false,
  }) {
    return CheckoutState(
      selectedAddress: clearAddress
          ? null
          : (selectedAddress ?? this.selectedAddress),
    );
  }

  @override
  List<Object?> get props => [selectedAddress];
}
