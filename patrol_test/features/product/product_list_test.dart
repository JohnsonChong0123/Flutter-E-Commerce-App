import 'package:e_commerce_client/presentation/screens/auth/login_screen.dart';
import 'package:e_commerce_client/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:e_commerce_client/main.dart' as app;
import '../../helpers/mocks/mock_auth_remote_data.dart';
import '../../helpers/mocks/mock_product_remote_data.dart';
import '../../helpers/setup/test_service_locator.dart';

void main() {
  patrolTest('Login → Enter email & password → Navigate to Home', ($) async {
    await initTestServiceLocator(
      authRemoteData: MockAuthRemoteDataLogin(),
      productRemoteData: MockProductRemoteData(),
    );

    app.isTestMode = true;
    app.main();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.byType(LoginScreen), findsOneWidget);

    await $(find.byKey(const Key('emailField'))).enterText('test@example.com');
    await $.pump();

    await $(find.byKey(const Key('passwordField'))).enterText('password123');
    await $.pump();

    await $(find.byKey(const Key('loginButton'))).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('TWINSLUXES Solar Post Cap Lights Outdoor - Waterproof LED Fence Post Solar Lights for 3.5x3.5/4x4/5x5 Wood Posts in Patio, Deck or Garden Decoration 4 Pack'), findsOneWidget);
  });
}
