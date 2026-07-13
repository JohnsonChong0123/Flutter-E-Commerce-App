part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {
  const CartInitial();
}

final class CartLoading extends CartState {
  const CartLoading();
}

final class CartSuccess extends CartState {
  const CartSuccess();
}

final class CartLoaded extends CartState {
  final CartEntity carts;
  final bool isCalculating;
  final bool isActionSuccess;

  final Map<String, String?> selectedShippingCodes;

  const CartLoaded({
    required this.carts,
    this.isCalculating = false,
    this.isActionSuccess = false,
    this.selectedShippingCodes = const {},
  });

  double get totalShippingCost => carts.calculateTotalShipping(selectedShippingCodes);
  
  double get grandTotal => carts.calculateGrandTotal(selectedShippingCodes);

  CartLoaded copyWith({
    CartEntity? carts,
    bool? isCalculating,
    bool? isActionSuccess,
    Map<String, String?>? selectedShippingCodes,
  }) {
    return CartLoaded(
      carts: carts ?? this.carts,
      isCalculating: isCalculating ?? this.isCalculating,
      isActionSuccess: isActionSuccess ?? this.isActionSuccess,
      selectedShippingCodes: selectedShippingCodes ?? this.selectedShippingCodes,
    );
  }

  @override
  List<Object> get props => [carts, isCalculating, isActionSuccess, selectedShippingCodes];
}

final class CartFailure extends CartState {
  final String message;

  const CartFailure({required this.message});

  @override
  List<Object> get props => [message];
}
