import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:e_commerce_client/domain/usecases/cart/get_cart.dart';
import 'package:e_commerce_client/domain/usecases/cart/remove_cart_item.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../core/usecase/usecase.dart';
import '../../../domain/entity/cart/cart_entity.dart';
import '../../../domain/usecases/cart/add_to_cart.dart';
import '../../../domain/usecases/cart/clear_cart.dart';
import '../../../domain/usecases/cart/update_cart.dart';

part 'cart_state.dart';
part 'cart_event.dart';

EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCart _addToCart;
  final GetCart _getCart;
  final RemoveCartItem _removeCartItem;
  final ClearCart _clearCart;
  final UpdateCart _updateCart;

  CartBloc({
    required AddToCart addToCart,
    required GetCart getCart,
    required RemoveCartItem removeCartItem,
    required ClearCart clearCart,
    required UpdateCart updateCart,
  }) : _addToCart = addToCart,
       _getCart = getCart,
       _removeCartItem = removeCartItem,
       _clearCart = clearCart,
       _updateCart = updateCart,
       super(CartInitial()) {
    // Use droppable transformer to ignore new rapid events while one is processing
    on<AddToCartEvent>(_onAddToCart, transformer: droppable());
    on<GetCartEvent>(_onGetCart, transformer: droppable());
    on<RemoveCartItemEvent>(_onRemoveCartItem, transformer: sequential());
    on<ClearCartEvent>(_onClearCart, transformer: sequential());
    on<UpdateCartEvent>(
      _onUpdateCart,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<UpdateCartQuantityLocalEvent>(_onUpdateCartQuantityLocal);
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    final result = await _addToCart(
      AddToCartParams(productId: event.productId, quantity: event.quantity),
    );
    result.fold(
      (failure) => emit(CartFailure(message: failure.message)),
      (_) => emit(const CartSuccess()),
    );
  }

  Future<void> _onGetCart(GetCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await _getCart(NoParams());
    result.fold(
      (failure) => emit(CartFailure(message: failure.message)),
      (carts) => emit(CartLoaded(carts: carts)),
    );
  }

  Future<void> _onRemoveCartItem(
    RemoveCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    final result = await _removeCartItem(
      RemoveCartItemParams(productId: event.productId),
    );
    await result.fold(
      (failure) async => emit(CartFailure(message: failure.message)),
      (_) async {
        final cartResult = await _getCart(NoParams());
        cartResult.fold(
          (failure) => emit(CartFailure(message: failure.message)),
          (carts) => emit(CartLoaded(carts: carts)),
        );
      },
    );
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    final result = await _clearCart(NoParams());
    await result.fold(
      (failure) async => emit(CartFailure(message: failure.message)),
      (_) async {
        final cartResult = await _getCart(NoParams());
        cartResult.fold(
          (failure) => emit(CartFailure(message: failure.message)),
          (carts) => emit(CartLoaded(carts: carts)),
        );
      },
    );
  }

  Future<void> _onUpdateCart(
    UpdateCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      final cart = currentState.carts;

      final result = await _updateCart(
        UpdateCartParams(productId: event.productId, quantity: event.quantity),
      );

      result.fold((failure) => emit(CartFailure(message: failure.message)), (
        _,
      ) {
        final updatedCart = cart.updateQuantityAndTotal(
          event.productId,
          event.quantity,
        );

        emit(CartLoaded(carts: updatedCart, isCalculating: false));
      });
    }
  }

  Future<void> _onUpdateCartQuantityLocal(
    UpdateCartQuantityLocalEvent event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      final cart = currentState.carts;

      final updatedCart = cart.updateQuantityAndTotal(
        event.productId,
        event.newQuantity,
      );

      emit(CartLoaded(carts: updatedCart, isCalculating: true));
    }
  }
}
