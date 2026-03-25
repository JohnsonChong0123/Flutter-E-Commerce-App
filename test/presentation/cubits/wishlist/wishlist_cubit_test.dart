import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/usecases/wishlist/add_wishlist.dart';
import 'package:e_commerce_client/domain/usecases/wishlist/clear_wishlist.dart';
import 'package:e_commerce_client/domain/usecases/wishlist/get_wishlist.dart';
import 'package:e_commerce_client/domain/usecases/wishlist/remove_wishlist.dart';
import 'package:e_commerce_client/presentation/cubits/wishlist/wishlist_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/product/product_fixtures.dart';
import '../../../fixtures/wishlist/wishlist_fixtures.dart';

class MockAddWishlist extends Mock implements AddWishlist {}

class MockGetWishlist extends Mock implements GetWishlist {}

class MockRemoveWishlist extends Mock implements RemoveWishlist {}

class MockClearWishlist extends Mock implements ClearWishlist {}

void main() {
  late MockAddWishlist mockAddWishlist;
  late MockGetWishlist mockGetWishlist;
  late MockRemoveWishlist mockRemoveWishlist;
  late MockClearWishlist mockClearWishlist;
  late WishlistCubit cubit;

  const tParams = AddWishlistParam(tProductId);
  const tRemoveParam = RemoveWishlistParams(tProductId);

  setUp(() {
    mockAddWishlist = MockAddWishlist();
    mockGetWishlist = MockGetWishlist();
    mockRemoveWishlist = MockRemoveWishlist();
    mockClearWishlist = MockClearWishlist();
    cubit = WishlistCubit(
      addWishlist: mockAddWishlist,
      getWishlist: mockGetWishlist,
      removeWishlist: mockRemoveWishlist,
      clearWishlist: mockClearWishlist,
    );
  });

  group('WishlistCubit AddWishlist', () {
    blocTest<WishlistCubit, WishlistState>(
      'should emit [WishlistLoading, WishlistSuccess] when add wishlist succeeds',
      build: () {
        when(
          () => mockAddWishlist(tParams),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockGetWishlist(NoParams()),
        ).thenAnswer((_) async => Right(tWishlistEntityList));
        return cubit;
      },
      act: (cubit) => cubit.addWishlist(tProductId),
      expect: () => [
        WishlistLoading(),
        WishlistLoaded(wishlist: tWishlistEntityList),
      ],
      verify: (_) {
        verify(() => mockAddWishlist(AddWishlistParam(tProductId))).called(1);

        verify(() => mockGetWishlist(NoParams())).called(1);
      },
    );

    blocTest<WishlistCubit, WishlistState>(
      'should emit [WishlistLoading, WishlistFailure] when add wishlist fails',
      build: () {
        when(() => mockAddWishlist(tParams)).thenAnswer(
          (_) async => const Left(Failure('Failed to add wishlist')),
        );

        return cubit;
      },
      act: (cubit) => cubit.addWishlist(tProductId),
      expect: () => [
        WishlistLoading(),
        const WishlistFailure(message: 'Failed to add wishlist'),
      ],
      verify: (_) {
        verify(() => mockAddWishlist(tParams)).called(1);
      },
    );
  });

  group('WishlistCubit GetWishlist', () {
    blocTest<WishlistCubit, WishlistState>(
      'should emit [WishlistLoading, WishlistLoaded] when get wishlist succeeds',
      build: () {
        when(
          () => mockGetWishlist(NoParams()),
        ).thenAnswer((_) async => Right(tWishlistEntityList));

        return cubit;
      },
      act: (cubit) => cubit.getWishlist(),
      expect: () => [
        WishlistLoading(),
        WishlistLoaded(wishlist: tWishlistEntityList),
      ],
      verify: (_) {
        verify(() => mockGetWishlist(NoParams())).called(1);
      },
    );

    blocTest<WishlistCubit, WishlistState>(
      'should emit [WishlistLoading, WishlistFailure] when get wishlist fails',
      build: () {
        when(() => mockGetWishlist(NoParams())).thenAnswer(
          (_) async => const Left(Failure('Failed to get wishlist')),
        );

        return cubit;
      },
      act: (cubit) => cubit.getWishlist(),
      expect: () => [
        WishlistLoading(),
        const WishlistFailure(message: 'Failed to get wishlist'),
      ],
      verify: (_) {
        verify(() => mockGetWishlist(NoParams())).called(1);
      },
    );
  });

  group('WishlistCubit RemoveWishlist', () {
    blocTest<WishlistCubit, WishlistState>(
      'should emit [WishlistLoading, WishlistSuccess] when remove wishlist succeeds',
      build: () {
        when(
          () => mockRemoveWishlist(tRemoveParam),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockGetWishlist(NoParams()),
        ).thenAnswer((_) async => Right(tWishlistEntityList));
        return cubit;
      },
      act: (cubit) => cubit.removeWishlist(tProductId),
      expect: () => [
        WishlistLoading(),
        WishlistLoaded(wishlist: tWishlistEntityList),
      ],
      verify: (_) {
        verify(
          () => mockRemoveWishlist(RemoveWishlistParams(tProductId)),
        ).called(1);

        verify(() => mockGetWishlist(NoParams())).called(1);
      },
    );

    blocTest<WishlistCubit, WishlistState>(
      'should emit [WishlistLoading, WishlistLoaded] when remove wishlist fails',
      build: () {
        when(() => mockRemoveWishlist(tRemoveParam)).thenAnswer(
          (_) async => const Left(Failure('Failed to remove wishlist')),
        );
        return cubit;
      },
      act: (cubit) => cubit.removeWishlist(tProductId),
      expect: () => [
        WishlistLoading(),
        const WishlistFailure(message: 'Failed to remove wishlist'),
      ],
      verify: (_) {
        verify(() => mockRemoveWishlist(tRemoveParam)).called(1);
      },
    );
  });

  group('WishlistCubit ClearWishlist', () {
    blocTest<WishlistCubit, WishlistState>(
      'should emit [WishlistLoading, WishlistLoaded] when clear wishlist succeeds',
      build: () {
        when(
          () => mockClearWishlist(NoParams()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockGetWishlist(NoParams()),
        ).thenAnswer((_) async => Right([]));
        return cubit;
      },
      act: (cubit) => cubit.clearWishlist(),
      expect: () => [WishlistLoading(), WishlistLoaded(wishlist: [])],
      verify: (_) {
        verify(() => mockClearWishlist(NoParams())).called(1);
        verify(() => mockGetWishlist(NoParams())).called(1);
      },
    );

    blocTest<WishlistCubit, WishlistState>(
      'should emit [WishlistLoading, WishlistFailure] when clear wishlist fails',
      build: () {
        when(() => mockClearWishlist(NoParams())).thenAnswer(
          (_) async => const Left(Failure('Failed to clear wishlist')),
        );

        return cubit;
      },
      act: (cubit) => cubit.clearWishlist(),
      expect: () => [
        WishlistLoading(),
        const WishlistFailure(message: 'Failed to clear wishlist'),
      ],
      verify: (_) {
        verify(() => mockClearWishlist(NoParams())).called(1);
      },
    );
  });
}
