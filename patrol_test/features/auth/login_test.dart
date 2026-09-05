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

  patrolTest('Login → Enter email & password → Navigate to Home', ($) async {
    await setupAndRunApp(MockAuthRemoteDataLogin());
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($(LoginScreen), findsOneWidget);

    await $(#emailField).enterText('test@example.com');
    await $.pump();

    await $(#passwordField).enterText('password123');
    await $.pump();

    await $(#loginButton).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($(HomeScreen), findsOneWidget);
  });

  patrolTest(
    'Login → Enter empty email & filled password → Show error message',
    ($) async {
      await setupAndRunApp(MockAuthRemoteDataLogin());
      await $.pumpAndSettle(timeout: const Duration(seconds: 10));

      expect($(LoginScreen), findsOneWidget);

      await $(#emailField).enterText('');
      await $.pump();

      await $(#passwordField).enterText('password123');
      await $.pump();

      await $(#loginButton).tap();
      await $.pumpAndSettle();

      expect($('Please enter your email'), findsOneWidget);

      expect($(LoginScreen), findsOneWidget);
    },
  );

  patrolTest(
    'Login → Enter filled email & empty password → Show error message',
    ($) async {
      await setupAndRunApp(MockAuthRemoteDataLogin());
      await $.pumpAndSettle(timeout: const Duration(seconds: 10));  
      expect($(LoginScreen), findsOneWidget);

      await $(#emailField).enterText('test@example.com');
      await $.pump();

      await $(#passwordField).enterText('');
      await $.pump();

      await $(#loginButton).tap();
      await $('Please enter your password').waitUntilVisible();

      expect($('Please enter your password'), findsOneWidget);

      expect($(LoginScreen), findsOneWidget);
    },
  );

  patrolTest('Login → Enter invalid email → Show error message', ($) async {
    await setupAndRunApp(MockAuthRemoteDataLogin());
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));
    expect($(LoginScreen), findsOneWidget);

    await $(#emailField).enterText('invalid-email');
    await $.pump();

    await $(#passwordField).enterText('password123');
    await $.pump();

    await $(#loginButton).tap();
    await $('Please enter a valid email').waitUntilVisible();

    expect($('Please enter a valid email'), findsOneWidget);

    expect($(LoginScreen), findsOneWidget);
  });

  patrolTest('Google Login → Navigate to Home', ($) async {
    await setupAndRunApp(MockAuthRemoteDataLoginWithGoogle());
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));
    expect($(LoginScreen), findsOneWidget);

    await $(#googleLoginButton).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($(HomeScreen), findsOneWidget);
  });

  patrolTest('Facebook Login → Navigate to Home', ($) async {
    await setupAndRunApp(MockAuthRemoteDataLoginWithFacebook());
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));
    expect($(LoginScreen), findsOneWidget);

    await $(#facebookLoginButton).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($(HomeScreen), findsOneWidget);
  });

  patrolTest('Login → Click on Sign Up Text → Navigate to Sign Up Screen', (
    $,
  ) async {
    await setupAndRunApp(MockAuthRemoteDataLogin());
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));
    expect($(LoginScreen), findsOneWidget);

    await $(#signupText).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($('Sign Up'), findsOneWidget);
  });
}
