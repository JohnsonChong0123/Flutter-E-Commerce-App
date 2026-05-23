import 'package:e_commerce_client/presentation/screens/auth/login_screen.dart';
import 'package:e_commerce_client/presentation/screens/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:e_commerce_client/main.dart' as app;
import '../../helpers/mocks/mock_auth_remote_data.dart';
import '../../helpers/setup/test_service_locator.dart';

void main() {
  patrolTest('SignUp → Enter user details → Navigate to Home', ($) async {
    await initTestServiceLocator(authRemoteData: MockAuthRemoteDataSignUp());

    app.isTestMode = true;
    app.main();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.byType(LoginScreen), findsOneWidget);

    await $(find.byKey(const Key('signupText'))).tap();

    await $(find.byKey(const Key('firstNameField'))).enterText('Test');
    await $.pump();

    await $(find.byKey(const Key('lastNameField'))).enterText('User');
    await $.pump();

    await $(find.byKey(const Key('emailField'))).enterText('test@example.com');
    await $.pump();

    await $(find.byKey(const Key('phoneField'))).enterText('012-3456789');
    await $.pump();

    await $(find.byKey(const Key('passwordField'))).enterText('password123');
    await $.pump();

    await $(
      find.byKey(const Key('confirmPasswordField')),
    ).enterText('password123');
    await $.pump();

    await $.scrollUntilVisible(finder: find.byKey(const Key('signUpButton')));

    await $(find.byKey(const Key('signUpButton'))).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  patrolTest('SignUp → Enter empty user details → Stay on SignUp', ($) async {
    await initTestServiceLocator(authRemoteData: MockAuthRemoteDataSignUp());

    app.isTestMode = true;
    app.main();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.byType(LoginScreen), findsOneWidget);

    await $(find.byKey(const Key('signupText'))).tap();

    await $(find.byKey(const Key('firstNameField'))).enterText('');
    await $.pump();

    await $(find.byKey(const Key('lastNameField'))).enterText('');
    await $.pump();

    await $(find.byKey(const Key('emailField'))).enterText('');
    await $.pump();

    await $(find.byKey(const Key('phoneField'))).enterText('');
    await $.pump();

    await $(find.byKey(const Key('passwordField'))).enterText('');
    await $.pump();

    await $(find.byKey(const Key('confirmPasswordField'))).enterText('');
    await $.pump();

    await $.scrollUntilVisible(finder: find.byKey(const Key('signUpButton')));

    await $(find.byKey(const Key('signUpButton'))).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 20));

    expect(find.byType(SignUpScreen), findsOneWidget);
    expect(find.text('Please enter your first name'), findsOneWidget);
    expect(find.text('Please enter your last name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your phone number'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  patrolTest('SignUp → Click on Login Text → Navigate to Login Screen', (
    $,
  ) async {
    await initTestServiceLocator(authRemoteData: MockAuthRemoteDataLogin());

    app.isTestMode = true;
    app.main();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.byType(LoginScreen), findsOneWidget);

    await $(find.byKey(const Key('signupText'))).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.text('Sign Up'), findsOneWidget);

    await $(find.byKey(const Key('loginText'))).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect(find.text('Login'), findsOneWidget);
  });
}
