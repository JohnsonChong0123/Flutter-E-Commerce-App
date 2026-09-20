import 'package:e_commerce_client/main.dart' as app;
import 'package:e_commerce_client/presentation/screens/cart/cart_screen.dart';
import 'package:e_commerce_client/presentation/screens/home_screen.dart';
import 'package:e_commerce_client/presentation/screens/product/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../../helpers/mocks/mock_auth_remote_data.dart';
import '../../helpers/mocks/mock_product_remote_data.dart';
import '../../helpers/setup/test_service_locator.dart';

void main() {
  patrolTest('Add a product and verify the cart contents', ($) async {
    await initTestServiceLocator(
      authRemoteData: MockAuthRemoteDataAuthenticated(),
      productRemoteData: MockProductRemoteData(),
    );

    app.isTestMode = true;
    app.main();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    const productName =
        'NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked';

    expect($(HomeScreen), findsOneWidget);
    await $.scrollUntilVisible(finder: $(productName));
    await $(productName).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($(ProductDetailScreen), findsOneWidget);
    await $.scrollUntilVisible(finder: $('Add To Cart'));
    await $('Add To Cart').tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    await $('Add to cart').tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    await $(Icons.shopping_bag_outlined).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($(CartScreen), findsOneWidget);
    expect($(productName), findsOneWidget);
  });
}
