import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_client/core/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:e_commerce_client/domain/entity/product/product_summary_entity.dart';
import 'package:e_commerce_client/presentation/widgets/product_card.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockGoRouter mockRouter;

  setUpAll(() {
    // Intercept and block real HTTP handshakes from CachedNetworkImage to prevent errors in the test sandbox
    HttpOverrides.runWithHttpOverrides(() {}, _NullHttpOverrides());
  });

  setUp(() {
    mockRouter = MockGoRouter();
  });

  // Helper method: Since context.pushNamed is used inside the widget,
  // we need to wrap it with InheritedGoRouter to inject the mock router into the context.
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: InheritedGoRouter(
        goRouter: mockRouter,
        child: Scaffold(body: SizedBox(width: 280, height: 300, child: body)),
      ),
    );
  }

  group('ProductCard Widget Tests', () {
    testWidgets(
      'Rendering Test: when there is no discount, should correctly display product info and hide initial price',
      (WidgetTester tester) async {
        final noDiscountProduct = ProductSummaryEntity(
          id: 'prod_123',
          name: 'Minimalist T-Shirt',
          imageUrl: 'https://example.com/image.jpg',
          initialPrice: 29.99,
          finalPrice: 29.99,
        );

        await tester.pumpWidget(
          makeTestableWidget(ProductCard(product: noDiscountProduct)),
        );

        expect(find.text('Minimalist T-Shirt'), findsOneWidget);
        expect(find.text('\$29.99'), findsOneWidget);

        expect(find.byType(CachedNetworkImage), findsOneWidget);
      },
    );

    testWidgets(
      'Discount Logic Test: when the product has a discount, the initial price should render with a strikethrough',
      (WidgetTester tester) async {
        final discountProduct = ProductSummaryEntity(
          id: 'prod_456',
          name: 'Premium Jacket',
          imageUrl: 'https://example.com/jacket.jpg',
          initialPrice: 150.00,
          finalPrice: 99.99,
        );

        await tester.pumpWidget(
          makeTestableWidget(ProductCard(product: discountProduct)),
        );

        expect(find.text('\$150.00'), findsOneWidget);
        expect(find.text('\$99.99'), findsOneWidget);

        final Text initialPriceText = tester.widget(find.text('\$150.00'));
        expect(initialPriceText.style?.decoration, TextDecoration.lineThrough);
      },
    );

    testWidgets(
      'Boundary Test: when imageUrl is an empty string, should render a fallback unsupported image icon',
      (WidgetTester tester) async {
        final emptyImageProduct = ProductSummaryEntity(
          id: 'prod_789',
          name: 'Socks',
          imageUrl: '', 
          initialPrice: 9.99,
          finalPrice: 9.99,
        );

        await tester.pumpWidget(
          makeTestableWidget(ProductCard(product: emptyImageProduct)),
        );

        expect(find.byType(CachedNetworkImage), findsNothing);
        
        expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
      },
    );

    testWidgets(
      'Interaction and Routing Test: clicking the card should call context.pushNamed with the correct id path parameter',
      (WidgetTester tester) async {
        final testProduct = ProductSummaryEntity(
          id: 'target_id_007',
          name: 'Caps',
          imageUrl: 'https://example.com/cap.jpg',
          initialPrice: 19.99,
          finalPrice: 19.99,
        );

      
        when(
          () => mockRouter.pushNamed(
            any(),
            pathParameters: any(named: 'pathParameters'),
            queryParameters: any(named: 'queryParameters'),
            extra: any(named: 'extra'),
          ),
        ).thenAnswer((_) async => null);

        await tester.pumpWidget(
          makeTestableWidget(ProductCard(product: testProduct)),
        );

        
        await tester.tap(find.byType(ProductCard));
        await tester.pump();

        
        verify(
          () => mockRouter.pushNamed(
            AppRouter.productDetailsName,
            pathParameters: {'id': 'target_id_007'},
          ),
        ).called(1);
      },
    );
  });

  testWidgets(
    'ProductCard Core Visual Defense: Locks core physical styles and prevents accidental tampering with the core UI contract',
    (WidgetTester tester) async {
      
      final testProduct = ProductSummaryEntity(
        id: 'target_id_007',
        name: 'Caps Collection Edition',
        imageUrl: 'https://example.com/cap.jpg',
        initialPrice: 29.99,
        finalPrice: 19.99,
      );

      
      await tester.pumpWidget(
        makeTestableWidget(ProductCard(product: testProduct)),
      );

      
      final Card cardWidget = tester.widget(find.byType(Card));
      
      expect(cardWidget.elevation, 2.0);

      
      final roundedShape = cardWidget.shape as RoundedRectangleBorder?;
      final BorderRadius cardRadius =
          roundedShape?.borderRadius as BorderRadius;
      expect(cardRadius.bottomLeft.x, 8.0); 

      
      
      final ClipRRect clipRRectWidget = tester.widget(
        find.byType(ClipRRect).first,
      );
      final BorderRadius imageRadius =
          clipRRectWidget.borderRadius as BorderRadius;
      expect(
        imageRadius.bottomLeft.x,
        8.0,
      ); 

      
      final Text nameText = tester.widget(find.text('Caps Collection Edition'));
      
      expect(nameText.maxLines, 2); 
      expect(
        nameText.overflow,
        TextOverflow.ellipsis,
      ); 
      expect(
        nameText.style?.fontSize,
        14.0,
      ); 

      
      
      final Text initialPriceText = tester.widget(find.text('\$29.99'));
      
      expect(
        initialPriceText.style?.decoration,
        TextDecoration.lineThrough,
      ); 
      expect(
        initialPriceText.style?.fontSize,
        14.0,
      ); 
    },
  );
}

/// Helper class: Used to mock and mock-block real network HTTP requests globally during tests
class _NullHttpOverrides extends HttpOverrides {}
