import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/entity/cart_entity.dart';
import 'package:e_commerce_client/domain/entity/cart_item_entity.dart';
import 'package:e_commerce_client/domain/usecases/cart/add_to_cart.dart';
import 'package:e_commerce_client/domain/usecases/cart/clear_cart.dart';
import 'package:e_commerce_client/domain/usecases/cart/get_cart.dart';
import 'package:e_commerce_client/domain/usecases/cart/remove_cart_item.dart';
import 'package:e_commerce_client/domain/usecases/cart/update_cart.dart';
import 'package:e_commerce_client/presentation/blocs/cart/cart_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

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

  const tParams = AddToCartParams(productId: '1', quantity: 2);

  const tUpdateParams = UpdateCartParams(productId: 'B09NQJFRW6', quantity: 2);

  const productId = '1';
  const quantity = 2;

  const tCartEntity = CartEntity(
    id: '1d3ed0a0-b460-4137-81b6-7e4befc3b63b',
    items: [
      CartItemEntity(
        productId: 'B09NQJFRW6',
        name: 'Saucony Men\'s Kinvara 13 Running Shoe',
        price: 57.79,
        quantity: 3,
        imageUrl:
            'https://m.media-amazon.com/images/I/71QeGmahUnL._AC_UX500_.jpg',
      ),
      CartItemEntity(
        productId: 'B0CY242B8P',
        name:
            '4th of July Door Sign Independence Day Wreath Patriotic Door Decoration Flower US Wooden Sign for Memorial Day Front for Door Decor 12 Inch Outdoor',
        price: 7.99,
        quantity: 3,
        imageUrl:
            'https://m.media-amazon.com/images/I/81BvLYGKcuL._AC_SL1500_.jpg',
      ),
    ],
    cartTotal: 197.34,
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
      act: (bloc) => bloc.add(const AddToCartEvent(productId: productId, quantity: quantity)),
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
      act: (bloc) => bloc.add(const AddToCartEvent(productId: productId, quantity: quantity)),
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
          () => mockRemoveCartItem(RemoveCartItemParams(productId: productId)),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockGetCart(NoParams()),
        ).thenAnswer((_) async => Right(tCartEntity));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const RemoveCartItemEvent(productId)),
      expect: () => [CartLoading(), CartLoaded(carts: tCartEntity)],
      verify: (_) {
        verify(
          () => mockRemoveCartItem(RemoveCartItemParams(productId: productId)),
        ).called(1);

        verify(() => mockGetCart(NoParams())).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'should emit [CartLoading, CartFailure] when remove cart item fails',
      build: () {
        when(
          () => mockRemoveCartItem(RemoveCartItemParams(productId: productId)),
        ).thenAnswer(
          (_) async => const Left(Failure('Failed to remove cart item')),
        );

        return cartBloc;
      },
      act: (bloc) => bloc.add(const RemoveCartItemEvent(productId)),
      expect: () => [
        CartLoading(),
        const CartFailure(message: 'Failed to remove cart item'),
      ],
      verify: (_) {
        verify(
          () => mockRemoveCartItem(RemoveCartItemParams(productId: productId)),
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

      act: (bloc) => bloc.add(UpdateCartEvent(productId: tUpdateParams.productId, quantity: tUpdateParams.quantity)),
      wait: const Duration(milliseconds: 100),

      expect: () {
        final updatedItems = tCartEntity.items.map((item) {
          if (item.productId == tUpdateParams.productId) {
            return item.copyWith(quantity: tUpdateParams.quantity);
          }
          return item;
        }).toList();

        final expectedTotal = updatedItems.fold<double>(
          0,
          (prev, element) => prev + (element.price * element.quantity),
        );

        return [
          CartLoaded(
            carts: tCartEntity.copyWith(
              items: updatedItems,
              cartTotal: expectedTotal,
            ),
          ),
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

      act: (bloc) => bloc.add(UpdateCartEvent(productId: tUpdateParams.productId, quantity: tUpdateParams.quantity)),

      expect: () => [const CartFailure(message: 'Failed to update cart')],

      verify: (_) {
        verify(() => mockUpdateCart(tUpdateParams)).called(1);
        verifyNever(() => mockGetCart(NoParams()));
      },
    );
  });
}
