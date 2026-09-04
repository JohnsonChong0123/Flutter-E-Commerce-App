import 'package:e_commerce_client/presentation/screens/home_screen.dart';
import 'package:e_commerce_client/presentation/screens/product/product_details_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:e_commerce_client/main.dart' as app;
import '../../helpers/mocks/mock_auth_remote_data.dart';
import '../../helpers/mocks/mock_product_remote_data.dart';
import '../../helpers/setup/test_service_locator.dart';

void main() {
  patrolTest('HomeScreen → Click Product → Navigate to ProductDetailScreen', (
    $,
  ) async {
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
    expect($(productName), findsOneWidget);

    await $.scrollUntilVisible(finder: $(productName));

    await $(productName).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($(ProductDetailScreen), findsOneWidget);
    expect($(productName), findsOneWidget);
  });
}
