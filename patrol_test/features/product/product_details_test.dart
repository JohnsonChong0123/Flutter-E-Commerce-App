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

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(
      find.text(
        'TWINSLUXES Solar Post Cap Lights Outdoor - Waterproof LED Fence Post Solar Lights for 3.5x3.5/4x4/5x5 Wood Posts in Patio, Deck or Garden Decoration 4 Pack',
      ),
      findsOneWidget,
    );

    await $(
      find.text(
        'TWINSLUXES Solar Post Cap Lights Outdoor - Waterproof LED Fence Post Solar Lights for 3.5x3.5/4x4/5x5 Wood Posts in Patio, Deck or Garden Decoration 4 Pack',
      ),
    ).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.byType(ProductDetailScreen), findsOneWidget);
    expect(
      find.text(
        'TWINSLUXES Solar Post Cap Lights Outdoor - Waterproof LED Fence Post Solar Lights for 3.5x3.5/4x4/5x5 Wood Posts in Patio, Deck or Garden Decoration 4 Pack',
      ),
      findsOneWidget,
    );
  });
}
