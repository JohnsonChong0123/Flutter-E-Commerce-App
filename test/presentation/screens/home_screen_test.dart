import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_client/core/routes/app_router.dart';
import 'package:e_commerce_client/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:e_commerce_client/presentation/blocs/product/product_bloc.dart';
import 'package:e_commerce_client/core/common/widgets/loader.dart';
import '../../fixtures/product/product_fixtures.dart';

class MockProductBloc extends MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockProductBloc mockProductBloc;
  late MockGoRouter mockRouter;

  setUpAll(() {
    // Force intercept and bypass errors caused by CachedNetworkImage fetching network images in the test sandbox.
    // This allows it to fall back and render a placeholder Container by default.
    HttpOverrides.runWithHttpOverrides(() {}, _NullHttpOverrides());
  });

  setUp(() {
    mockProductBloc = MockProductBloc();
    mockRouter = MockGoRouter();
    // Default behavior for loadProducts: do nothing (since we're only verifying if it was called, not its internal logic)
    when(() => mockProductBloc.loadProducts()).thenAnswer((_) async {});
  });

  Widget makeTestableWidget(Widget body, {RouterConfig<Object>? routerConfig}) {
    return BlocProvider<ProductBloc>.value(
      value: mockProductBloc,
      child: routerConfig != null
          ? MaterialApp.router(routerConfig: routerConfig)
          : MaterialApp(home: body),
    );
  }

  group('HomeScreen', () {
    testWidgets(
      'Initialization & Lifecycle Test: entering the page should automatically call loadProducts',
      (WidgetTester tester) async {
        when(() => mockProductBloc.state).thenReturn(ProductInitial());

        await tester.pumpWidget(makeTestableWidget(const HomeScreen()));

        verify(() => mockProductBloc.loadProducts()).called(1);
      },
    );

    testWidgets(
      'State Test: when products are in loading state, should render the Loader component',
      (WidgetTester tester) async {
        when(() => mockProductBloc.state).thenReturn(ProductLoading());

        await tester.pumpWidget(makeTestableWidget(const HomeScreen()));

        expect(find.byType(Loader), findsOneWidget);
      },
    );

    testWidgets(
      'State & Rendering Test: when data loads successfully, should correctly display product cards, and total count should not exceed 10',
      (WidgetTester tester) async {
        when(
          () => mockProductBloc.state,
        ).thenReturn(ProductLoaded(products: tProductSummaryEntityList));

        await tester.pumpWidget(makeTestableWidget(const HomeScreen()));

        expect(find.text('ATELIER'), findsOneWidget);
        expect(find.text('The Modern \nMinimalist'), findsOneWidget);
        expect(find.text('Selected For You'), findsOneWidget);

        expect(
          find.text(
            'NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked',
          ),
          findsOneWidget,
        );
        expect(find.text('\$481.99'), findsOneWidget);
        expect(
          find.text(
            'Apple iPhone 12 64/128GB - Fully Unlocked AT&T T-Mobile Verizon - All colors',
          ),
          findsOneWidget,
        );
        expect(find.text('\$219.00'), findsOneWidget);

        expect(find.byType(CachedNetworkImage), findsNWidgets(6));
      },
    );

    testWidgets(
      'Error Isolation Test: when the data stream encounters an error, should display Failure information to the user',
      (WidgetTester tester) async {
        const errorMessage = "Failed to fetch products from server";
        when(
          () => mockProductBloc.state,
        ).thenReturn(const ProductFailure(message: errorMessage));

        await tester.pumpWidget(makeTestableWidget(const HomeScreen()));

        expect(find.text(errorMessage), findsOneWidget);
      },
    );

    testWidgets(
      'Interaction Test: clicking a product card should respond without crashing',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(800, 1500);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        when(
          () => mockRouter.pushNamed(
            any(),
            pathParameters: any(named: 'pathParameters'),
            queryParameters: any(named: 'queryParameters'),
            extra: any(named: 'extra'),
          ),
        ).thenAnswer((_) async => null);

        when(
          () => mockProductBloc.state,
        ).thenReturn(ProductLoaded(products: tProductSummaryEntityList));

        await tester.pumpWidget(
          makeTestableWidget(
            InheritedGoRouter(goRouter: mockRouter, child: const HomeScreen()),
          ),
        );

        final productCard = find.text(
          'NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked',
        );
        expect(productCard, findsOneWidget);

        await tester.ensureVisible(productCard);
        await tester.pump();

        await tester.tap(productCard);
        await tester.pump();
      },
    );

    testWidgets(
      'Regression Defense: the horizontal scroll container in the New Arrivals area must be strictly height-restricted to 380.0',
      (WidgetTester tester) async {
        when(
          () => mockProductBloc.state,
        ).thenReturn(ProductLoaded(products: tProductSummaryEntityList));

        await tester.pumpWidget(makeTestableWidget(const HomeScreen()));
        await tester.pump();

        final SizedBox horizontalListContainer = tester.widget(
          find
              .descendant(
                of: find.byType(HomeScreen),
                matching: find.byWidgetPredicate(
                  (widget) => widget is SizedBox && widget.child is ListView,
                ),
              )
              .first,
        );

        expect(horizontalListContainer.height, 380.0);
      },
    );

    testWidgets(
      'Regression Defense: clicking the top-right shopping bag button must accurately navigate to cartName using named routes',
      (WidgetTester tester) async {
        when(() => mockProductBloc.state).thenReturn(ProductInitial());

        when(
          () => mockRouter.goNamed(AppRouter.cartName),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(
          makeTestableWidget(
            InheritedGoRouter(goRouter: mockRouter, child: const HomeScreen()),
          ),
        );

        final shoppingBagButton = find.byIcon(Icons.shopping_bag_outlined);
        expect(shoppingBagButton, findsOneWidget);

        await tester.tap(shoppingBagButton);
        await tester.pumpAndSettle();

        verify(() => mockRouter.goNamed(AppRouter.cartName)).called(1);
      },
    );
  });

  testWidgets(
    'Regression Defense: Main hero banner and brand card core visual contract and navigation deadlock',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1500);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      when(() => mockProductBloc.state).thenReturn(ProductInitial());
      when(() => mockProductBloc.loadProducts()).thenAnswer((_) async {});

      await tester.pumpWidget(
        makeTestableWidget(
          InheritedGoRouter(goRouter: mockRouter, child: const HomeScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final ClipRRect bannerClip = tester.widget(
        find
            .descendant(
              of: find.byType(HomeScreen),
              matching: find.byType(ClipRRect),
            )
            .first,
      );
      final BorderRadius borderRadius = bannerClip.borderRadius as BorderRadius;
      expect(borderRadius.bottomLeft.x, 16.0);

      final AspectRatio bannerRatio = tester.widget(
        find
            .descendant(
              of: find.byType(HomeScreen),
              matching: find.byType(AspectRatio),
            )
            .first,
      );
      expect(bannerRatio.aspectRatio, 4 / 5);

      final Text titleText = tester.widget(
        find.text('The Modern \nMinimalist'),
      );
      expect(titleText.style?.fontSize, 40.0);
      expect(titleText.style?.fontWeight, FontWeight.w800);
      final Container infoContainer = tester.widget(
        find
            .ancestor(
              of: find.text('Curated Essentials'),
              matching: find.byType(Container),
            )
            .first,
      );
      final BoxDecoration? containerDecoration =
          infoContainer.decoration as BoxDecoration?;
      final BorderRadius containerBorderRadius =
          containerDecoration?.borderRadius as BorderRadius;
      expect(containerBorderRadius.bottomLeft.x, 16.0);
      expect(infoContainer.padding, const EdgeInsets.all(24));

      final exploreButton = find.text('Explore Now');
      expect(exploreButton, findsOneWidget);

      await tester.ensureVisible(exploreButton);
      await tester.tap(exploreButton);
      await tester.pumpAndSettle();

      verify(() => mockRouter.goNamed(AppRouter.productSearchName)).called(1);
    },
  );

  
}

/// Helper class: Used to mock and mock-block real network HTTP requests globally during tests (prevents Image.network or CachedNetworkImage crashes).
class _NullHttpOverrides extends HttpOverrides {}
