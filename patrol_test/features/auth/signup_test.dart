import 'package:e_commerce_client/presentation/screens/auth/login_screen.dart';
import 'package:e_commerce_client/presentation/screens/auth/sign_up_screen.dart';
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

    expect($(LoginScreen), findsOneWidget);

    await $(#signupText).tap();

    await $(#firstNameField).enterText('Test');
    await $.pump();

    await $(#lastNameField).enterText('User');
    await $.pump();

    await $(#emailField).enterText('test@example.com');
    await $.pump();

    await $(#phoneField).enterText('012-3456789');
    await $.pump();

    await $(#passwordField).enterText('password123');
    await $.pump();

    await $(#confirmPasswordField).enterText('password123');
    await $.pump();

    await $.scrollUntilVisible(finder: $(#signUpButton));

    await $(#signUpButton).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($(LoginScreen), findsOneWidget);
  });

  patrolTest('SignUp → Enter empty user details → Stay on SignUp', ($) async {
    await initTestServiceLocator(authRemoteData: MockAuthRemoteDataSignUp());

    app.isTestMode = true;
    app.main();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($(LoginScreen), findsOneWidget);

    await $(#signupText).tap();

    await $(#firstNameField).enterText('');
    await $.pump();

    await $(#lastNameField).enterText('');
    await $.pump();

    await $(#emailField).enterText('');
    await $.pump();

    await $(#phoneField).enterText('');
    await $.pump();

    await $(#passwordField).enterText('');
    await $.pump();

    await $(#confirmPasswordField).enterText('');
    await $.pump();

    await $.scrollUntilVisible(finder: $(#signUpButton));

    await $(#signUpButton).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 20));

    expect($(SignUpScreen), findsOneWidget);
    expect($('Please enter your first name'), findsOneWidget);
    expect($('Please enter your last name'), findsOneWidget);
    expect($('Please enter your email'), findsOneWidget);
    expect($('Please enter your phone number'), findsOneWidget);
    expect($('Please enter your password'), findsOneWidget);
  });

  patrolTest('SignUp → Click on Login Text → Navigate to Login Screen', (
    $,
  ) async {
    await initTestServiceLocator(authRemoteData: MockAuthRemoteDataLogin());

    app.isTestMode = true;
    app.main();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($(LoginScreen), findsOneWidget);

    await $(#signupText).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($('Sign Up'), findsOneWidget);

    await $(#loginText).tap();
    await $.pumpAndSettle(timeout: const Duration(seconds: 10));

    expect($('Login'), findsOneWidget);
  });
}
