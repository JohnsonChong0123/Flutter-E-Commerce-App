import 'package:e_commerce_client/presentation/screens/auth/login_screen.dart';
import 'package:e_commerce_client/presentation/screens/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:e_commerce_client/main.dart' as app;
import '../../helpers/mocks/mock_auth_remote_data.dart';
import '../../helpers/setup/test_service_locator.dart';

void main() {
  patrolTest('Cold start → No token → Navigate to Login', ($) async {
    await initTestServiceLocator(
      authRemoteData: MockAuthRemoteDataUnauthenticated(),
    );

    app.isTestMode = true;
    app.main();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  patrolTest('Cold start → With token → Navigate to Home', ($) async {
    await initTestServiceLocator(
      authRemoteData: MockAuthRemoteDataAuthenticated(),
    );

    app.isTestMode = true;
    app.main();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
