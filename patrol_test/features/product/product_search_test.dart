import 'package:e_commerce_client/presentation/screens/home_screen.dart';
import 'package:e_commerce_client/presentation/screens/product/product_details_screen.dart';
import 'package:e_commerce_client/presentation/screens/product/product_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:e_commerce_client/main.dart' as app;
import '../../helpers/mocks/mock_auth_remote_data.dart';
import '../../helpers/mocks/mock_product_remote_data.dart';
import '../../helpers/setup/test_service_locator.dart';

void main() {
  patrolTest(
    'Cold start → With token → Navigate to Home → Navigate to Product Search → Open Product Details',
    ($) async {
      await initTestServiceLocator(
        authRemoteData: MockAuthRemoteDataAuthenticated(),
        productRemoteData: MockProductRemoteData(),
      );

      app.isTestMode = true;
      app.main();
      await $.pumpAndSettle(timeout: const Duration(seconds: 10));

      expect($(HomeScreen), findsOneWidget);
      await $.scrollUntilVisible(finder: $(#exploreNowButton));

      await $(#exploreNowButton).tap();
      await $.pumpAndSettle(timeout: const Duration(seconds: 20));

      expect($(ProductSearchScreen), findsOneWidget);

      const samsungProduct =
          'NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked';

      await $.scrollUntilVisible(finder: $(samsungProduct));

      await $(samsungProduct).tap();
      await $.pumpAndSettle(timeout: const Duration(seconds: 10));

      expect($(ProductDetailScreen), findsOneWidget);
    },
  );

  patrolTest(
    'Cold start → With token → Navigate to Home → Navigate to Product Search → Search Product → Open Product Details',
    ($) async {
      await initTestServiceLocator(
        authRemoteData: MockAuthRemoteDataAuthenticated(),
        productRemoteData: MockProductRemoteData(),
      );

      app.isTestMode = true;
      app.main();
      await $.pumpAndSettle(timeout: const Duration(seconds: 10));

      expect($(HomeScreen), findsOneWidget);
      await $.scrollUntilVisible(finder: $(#exploreNowButton));

      await $(#exploreNowButton).tap();
      await $.pumpAndSettle(timeout: const Duration(seconds: 20));

      expect($(ProductSearchScreen), findsOneWidget);

      await $(#productSearchBar).tap();
      await $(#productSearchBar).enterText('A');
      FocusManager.instance.primaryFocus?.unfocus();
      await $.pumpAndSettle(timeout: const Duration(seconds: 2));

      const iphoneProduct =
          'Apple iPhone 12 64/128GB - Fully Unlocked AT&T T-Mobile Verizon - All colors';

      await $.scrollUntilVisible(finder: $(iphoneProduct));

      await $(iphoneProduct).tap();
      await $.pumpAndSettle(timeout: const Duration(seconds: 10));

      expect($(ProductDetailScreen), findsOneWidget);
    },
  );
}
