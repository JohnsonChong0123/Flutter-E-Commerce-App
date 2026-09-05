import 'package:e_commerce_client/presentation/screens/auth/login_screen.dart';
import 'package:e_commerce_client/presentation/screens/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:patrol/patrol.dart';
import 'package:e_commerce_client/main.dart' as app;
import '../../helpers/mocks/mock_auth_remote_data.dart';
import '../../helpers/setup/test_service_locator.dart';

void main() {
  Future<void> setupAndRunApp(dynamic mockAuthData) async {
    await GetIt.I.reset();
    await initTestServiceLocator(authRemoteData: mockAuthData);

    app.isTestMode = true;
    app.main();
  }

  // patrolTest('Cold start → No token → Navigate to Login', ($) async {
  //   await initTestServiceLocator(
  //     authRemoteData: MockAuthRemoteDataUnauthenticated(),
  //   );

  //   app.isTestMode = true;
  //   app.main();
  //   await $.pumpAndSettle(timeout: const Duration(seconds: 10));

  //   expect($(LoginScreen), findsOneWidget);
  // });

  patrolTest('Cold start → With token → Navigate to Home', ($) async {
    await setupAndRunApp(MockAuthRemoteDataAuthenticated());
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($(HomeScreen), findsOneWidget);
  });
}
