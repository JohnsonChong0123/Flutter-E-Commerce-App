part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final String productId;
  final int quantity;

  const AddToCartEvent({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

class GetCartEvent extends CartEvent {
  const GetCartEvent();
}

class RemoveCartItemEvent extends CartEvent {
  final String productId;

  const RemoveCartItemEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}

class UpdateCartEvent extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateCartEvent({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}