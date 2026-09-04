import 'package:e_commerce_client/main.dart' as app;
import 'package:e_commerce_client/presentation/screens/cart/cart_screen.dart';
import 'package:e_commerce_client/presentation/screens/home_screen.dart';
import 'package:e_commerce_client/presentation/screens/product/product_search_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../../helpers/mocks/mock_auth_remote_data.dart';
import '../../helpers/mocks/mock_product_remote_data.dart';
import '../../helpers/setup/test_service_locator.dart';

void main() {
  patrolTest('Cold start → With token → Navigate to Home → Navigate to Cart', (
    $,
  ) async {
    await initTestServiceLocator(
      authRemoteData: MockAuthRemoteDataAuthenticated(),
    );

    app.isTestMode = true;
    app.main();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($(HomeScreen), findsOneWidget);

    await $(#topRightCartButton).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($(CartScreen), findsOneWidget);
  });

  patrolTest(
    'Cold start → With token → Navigate to Home → Navigate to Product Search',
    ($) async {
      await initTestServiceLocator(
        authRemoteData: MockAuthRemoteDataAuthenticated(),
      );

      app.isTestMode = true;
      app.main();
      await $.pumpAndSettle(timeout: const Duration(seconds: 10));

      expect($(HomeScreen), findsOneWidget);
      await $.scrollUntilVisible(finder: $(#exploreNowButton));

      await $(#exploreNowButton).tap();
      await $.pumpAndSettle(timeout: const Duration(seconds: 10));

      expect($(ProductSearchScreen), findsOneWidget);
    },
  );

  patrolTest('Cold start → With token → Products load → Open Product Details', (
    $,
  ) async {
    await initTestServiceLocator(
      authRemoteData: MockAuthRemoteDataAuthenticated(),
      productRemoteData: MockProductRemoteData(),
    );

    app.isTestMode = true;
    app.main();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($(HomeScreen), findsOneWidget);

    const productName =
        'NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked';

    await $.scrollUntilVisible(finder: $(productName));

    await $(productName).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($(productName), findsWidgets);
  });
}
