import 'package:e_commerce_client/presentation/screens/auth/login_screen.dart';
import 'package:e_commerce_client/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:e_commerce_client/main.dart' as app;
import '../../helpers/mocks/mock_auth_remote_data.dart';
import '../../helpers/setup/test_service_locator.dart';

void main() {
  patrolTest('Login → Enter email & password → Navigate to Home', ($) async {
    await initTestServiceLocator(authRemoteData: MockAuthRemoteDataLogin());

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
  });

  patrolTest(
    'Login → Enter empty email & filled password → Show error message',
    ($) async {
      await initTestServiceLocator(authRemoteData: MockAuthRemoteDataLogin());

      app.isTestMode = true;
      app.main();
      await $.pumpAndSettle(timeout: const Duration(seconds: 10));

      expect(find.byType(LoginScreen), findsOneWidget);

      await $(find.byKey(const Key('emailField'))).enterText('');
      await $.pump();

      await $(find.byKey(const Key('passwordField'))).enterText('password123');
      await $.pump();

      await $(find.byKey(const Key('loginButton'))).tap();
      await $.pumpAndSettle();

      expect(find.text('Please enter your email'), findsOneWidget);

      expect(find.byType(LoginScreen), findsOneWidget);
    },
  );

  patrolTest(
    'Login → Enter filled email & empty password → Show error message',
    ($) async {
      await initTestServiceLocator(authRemoteData: MockAuthRemoteDataLogin());

      app.isTestMode = true;
      app.main();
      await $.pumpAndSettle(timeout: const Duration(seconds: 10));

      expect(find.byType(LoginScreen), findsOneWidget);

      await $(
        find.byKey(const Key('emailField')),
      ).enterText('test@example.com');
      await $.pump();

      await $(find.byKey(const Key('passwordField'))).enterText('');
      await $.pump();

      await $(find.byKey(const Key('loginButton'))).tap();
      await $('Please enter your password').waitUntilVisible();

      expect(find.text('Please enter your password'), findsOneWidget);

      expect(find.byType(LoginScreen), findsOneWidget);
    },
  );

  patrolTest('Login → Enter invalid email → Show error message', ($) async {
    await initTestServiceLocator(authRemoteData: MockAuthRemoteDataLogin());

    app.isTestMode = true;
    app.main();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.byType(LoginScreen), findsOneWidget);

    await $(find.byKey(const Key('emailField'))).enterText('invalid-email');
    await $.pump();

    await $(find.byKey(const Key('passwordField'))).enterText('password123');
    await $.pump();

    await $(find.byKey(const Key('loginButton'))).tap();
    await $('Please enter a valid email').waitUntilVisible();

    expect(find.text('Please enter a valid email'), findsOneWidget);

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  patrolTest('Google Login → Navigate to Home', ($) async {
    await initTestServiceLocator(
      authRemoteData: MockAuthRemoteDataLoginWithGoogle(),
    );

    app.isTestMode = true;
    app.main();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.byType(LoginScreen), findsOneWidget);

    await $(find.byKey(const Key('googleLoginButton'))).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  patrolTest('Facebook Login → Navigate to Home', ($) async {
    await initTestServiceLocator(
      authRemoteData: MockAuthRemoteDataLoginWithFacebook(),
    );

    app.isTestMode = true;
    app.main();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.byType(LoginScreen), findsOneWidget);

    await $(find.byKey(const Key('facebookLoginButton'))).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  patrolTest('Login → Click on Sign Up Text → Navigate to Sign Up Screen', ($) async {
    await initTestServiceLocator(authRemoteData: MockAuthRemoteDataLogin());

    app.isTestMode = true;
    app.main();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.byType(LoginScreen), findsOneWidget);

    await $(find.byKey(const Key('signupText'))).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.text('Sign Up'), findsOneWidget);
  });
}
