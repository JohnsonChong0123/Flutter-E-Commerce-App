import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/usecases/cart/add_to_cart.dart';
import 'package:e_commerce_client/domain/usecases/cart/clear_cart.dart';
import 'package:e_commerce_client/domain/usecases/cart/get_cart.dart';
import 'package:e_commerce_client/domain/usecases/cart/remove_cart_item.dart';
import 'package:e_commerce_client/domain/usecases/cart/update_cart.dart';
import 'package:e_commerce_client/presentation/blocs/cart/cart_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import '../../../fixtures/cart/cart_fixtures.dart';
import '../../../fixtures/product/product_fixtures.dart';

class MockAddToCart extends Mock implements AddToCart {}

class MockGetCart extends Mock implements GetCart {}

class MockRemoveCartItem extends Mock implements RemoveCartItem {}

class MockClearCart extends Mock implements ClearCart {}

class MockUpdateCart extends Mock implements UpdateCart {}

void main() {
  late MockAddToCart mockAddToCart;
  late MockGetCart mockGetCart;
  late MockRemoveCartItem mockRemoveCartItem;
  late MockClearCart mockClearCart;
  late MockUpdateCart mockUpdateCart;
  late CartBloc cartBloc;

  const tQuantity = 3;

  const tParams = AddToCartParams(
    productId: tProductId,
    quantity: tQuantity,
  );

  const tUpdateParams = UpdateCartParams(
    productId: tProductId,
    quantity: tQuantity,
  );

  setUp(() {
    mockAddToCart = MockAddToCart();
    mockGetCart = MockGetCart();
    mockRemoveCartItem = MockRemoveCartItem();
    mockClearCart = MockClearCart();
    mockUpdateCart = MockUpdateCart();
    cartBloc = CartBloc(
      addToCart: mockAddToCart,
      getCart: mockGetCart,
      removeCartItem: mockRemoveCartItem,
      clearCart: mockClearCart,
      updateCart: mockUpdateCart,
    );
  });

  group('CartBloc AddToCart', () {
    blocTest<CartBloc, CartState>(
      'should emit [CartLoading, CartSuccess] when add to cart succeeds',
      build: () {
        when(
          () => mockAddToCart(tParams),
        ).thenAnswer((_) async => const Right(unit));
        return cartBloc;
      },
      act: (bloc) => bloc.add(
        const AddToCartEvent(productId: tProductId, quantity: tQuantity),
      ),
      expect: () => [CartLoading(), CartSuccess()],
      verify: (_) {
        verify(() => mockAddToCart(tParams)).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'should emit [CartLoading, CartFailure] when add to cart fails',
      build: () {
        when(
          () => mockAddToCart(tParams),
        ).thenAnswer((_) async => const Left(Failure('Failed to add to cart')));

        return cartBloc;
      },
      act: (bloc) => bloc.add(
        const AddToCartEvent(productId: tProductId, quantity: tQuantity),
      ),
      expect: () => [
        CartLoading(),
        const CartFailure(message: 'Failed to add to cart'),
      ],
      verify: (_) {
        verify(() => mockAddToCart(tParams)).called(1);
      },
    );
  });

  group('CartBloc GetCart', () {
    blocTest<CartBloc, CartState>(
      'should emit [CartLoading, CartLoaded] when get cart succeeds',
      build: () {
        when(
          () => mockGetCart(NoParams()),
        ).thenAnswer((_) async => const Right(tCartEntity));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const GetCartEvent()),
      expect: () => [CartLoading(), CartLoaded(carts: tCartEntity)],
      verify: (_) {
        verify(() => mockGetCart(NoParams())).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'should emit [CartLoading, CartFailure] when get cart fails',
      build: () {
        when(
          () => mockGetCart(NoParams()),
        ).thenAnswer((_) async => const Left(Failure('Failed to get cart')));

        return cartBloc;
      },
      act: (bloc) => bloc.add(const GetCartEvent()),
      expect: () => [
        CartLoading(),
        const CartFailure(message: 'Failed to get cart'),
      ],
      verify: (_) {
        verify(() => mockGetCart(NoParams())).called(1);
      },
    );
  });

  group('CartBloc RemoveCartItem', () {
    blocTest<CartBloc, CartState>(
      'should emit [CartLoading, CartLoaded] when remove cart item succeeds',
      build: () {
        when(
          () => mockRemoveCartItem(RemoveCartItemParams(productId: tProductId)),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockGetCart(NoParams()),
        ).thenAnswer((_) async => Right(tCartEntity));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const RemoveCartItemEvent(tProductId)),
      expect: () => [CartLoading(), CartLoaded(carts: tCartEntity)],
      verify: (_) {
        verify(
          () => mockRemoveCartItem(RemoveCartItemParams(productId: tProductId)),
        ).called(1);

        verify(() => mockGetCart(NoParams())).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'should emit [CartLoading, CartFailure] when remove cart item fails',
      build: () {
        when(
          () => mockRemoveCartItem(RemoveCartItemParams(productId: tProductId)),
        ).thenAnswer(
          (_) async => const Left(Failure('Failed to remove cart item')),
        );

        return cartBloc;
      },
      act: (bloc) => bloc.add(const RemoveCartItemEvent(tProductId)),
      expect: () => [
        CartLoading(),
        const CartFailure(message: 'Failed to remove cart item'),
      ],
      verify: (_) {
        verify(
          () => mockRemoveCartItem(RemoveCartItemParams(productId: tProductId)),
        ).called(1);
        verifyNever(() => mockGetCart(NoParams()));
      },
    );
  });

  group('CartBloc ClearCart', () {
    blocTest<CartBloc, CartState>(
      'should emit [CartLoading, CartLoaded] when clear cart succeeds',
      build: () {
        when(
          () => mockClearCart(NoParams()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockGetCart(NoParams()),
        ).thenAnswer((_) async => Right(tCartEntity));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const ClearCartEvent()),
      expect: () => [CartLoading(), CartLoaded(carts: tCartEntity)],
      verify: (_) {
        verify(() => mockClearCart(NoParams())).called(1);
        verify(() => mockGetCart(NoParams())).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'should emit [CartLoading, CartFailure] when clear cart fails',
      build: () {
        when(
          () => mockClearCart(NoParams()),
        ).thenAnswer((_) async => const Left(Failure('Failed to clear cart')));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const ClearCartEvent()),
      expect: () => [
        CartLoading(),
        const CartFailure(message: 'Failed to clear cart'),
      ],
      verify: (_) {
        verify(() => mockClearCart(NoParams())).called(1);
        verifyNever(() => mockGetCart(NoParams()));
      },
    );
  });

  group('CartBloc UpdateCart', () {
    blocTest<CartBloc, CartState>(
      'should emit [CartLoaded] with updated item when update cart succeeds',
      build: () {
        when(
          () => mockUpdateCart(tUpdateParams),
        ).thenAnswer((_) async => const Right(unit));
        return cartBloc;
      },

      seed: () => CartLoaded(carts: tCartEntity),

      act: (bloc) {
        bloc.add(
          UpdateCartQuantityLocalEvent(
            productId: tUpdateParams.productId,
            newQuantity: tUpdateParams.quantity,
          ),
        );
        bloc.add(
          UpdateCartEvent(
            productId: tUpdateParams.productId,
            quantity: tUpdateParams.quantity,
          ),
        );
      },

      wait: const Duration(milliseconds: 600),

      expect: () {
        final tUpdateCart = tCartEntity.updateQuantityAndTotal(
          tUpdateParams.productId,
          tUpdateParams.quantity,
        );

        return [
          CartLoaded(carts: tUpdateCart, isCalculating: true),
          CartLoaded(carts: tUpdateCart, isCalculating: false),
        ];
      },
      verify: (_) {
        verify(() => mockUpdateCart(tUpdateParams)).called(1);
        verifyNever(() => mockGetCart(NoParams()));
      },
    );

    blocTest<CartBloc, CartState>(
      'should emit [CartFailure] when update cart fails',
      build: () {
        when(
          () => mockUpdateCart(tUpdateParams),
        ).thenAnswer((_) async => const Left(Failure('Failed to update cart')));
        return cartBloc;
      },
      seed: () => CartLoaded(carts: tCartEntity),

      act: (bloc) {
        bloc.add(
          UpdateCartQuantityLocalEvent(
            productId: tUpdateParams.productId,
            newQuantity: tUpdateParams.quantity,
          ),
        );
        bloc.add(
          UpdateCartEvent(
            productId: tUpdateParams.productId,
            quantity: tUpdateParams.quantity,
          ),
        );
      },
      wait: const Duration(milliseconds: 600),
      expect: () {
        final tUpdateCart = tCartEntity.updateQuantityAndTotal(
          tUpdateParams.productId,
          tUpdateParams.quantity,
        );

        return [
          CartLoaded(carts: tUpdateCart, isCalculating: true),
          const CartFailure(message: 'Failed to update cart'),
        ];
      },

      verify: (_) {
        verify(() => mockUpdateCart(tUpdateParams)).called(1);
        verifyNever(() => mockGetCart(NoParams()));
      },
    );
  });
}
