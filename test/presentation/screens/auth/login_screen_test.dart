import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce_client/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:e_commerce_client/presentation/screens/auth/login_screen.dart';
import 'package:e_commerce_client/core/common/widgets/loader.dart';

// 1. Mock AuthBloc
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUpAll(() {
    // Register Fallback Value to avoid mocktail any() errors
    // Assuming AuthLogin is one of your concrete event subclasses
    registerFallbackValue(const AuthLogin(email: '', password: ''));
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<AuthBloc>.value(
      value: mockAuthBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Rendering Test: should successfully display all login-related fields and third-party buttons',
    (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());

      await tester.pumpWidget(makeTestableWidget(const LoginScreen()));

      // Verify basic text and fields
      expect(find.text("ATELIER"), findsOneWidget);
      expect(find.text("Welcome Back"), findsOneWidget);
      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);

      // Verify all buttons
      expect(find.byKey(const Key('loginButton')), findsOneWidget);
      expect(find.byKey(const Key('googleLoginButton')), findsOneWidget);
      expect(find.byKey(const Key('facebookLoginButton')), findsOneWidget);
      expect(find.byKey(const Key('signupText')), findsOneWidget);
    },
  );

  testWidgets(
    'Interaction Test: clicking Login should trigger AuthLogin event after form validation passes',
    (WidgetTester tester) async {
      // Force expand the virtual viewport to prevent click failures caused by components being pushed off-screen by keyboards or long pages
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      when(() => mockAuthBloc.state).thenReturn(AuthInitial());

      await tester.pumpWidget(makeTestableWidget(const LoginScreen()));

      // Fill in email and password (ensure they match the built-in validation rules in your AuthField and PasswordField)
      await tester.enterText(
        find.byKey(const Key('emailField')),
        'johnson@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('passwordField')),
        'Password123!',
      );
      await tester.pump();

      // Click the login button
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      // Verify whether the corresponding standard login event was dispatched
      verify(() => mockAuthBloc.add(any(that: isA<AuthLogin>()))).called(1);
    },
  );

  testWidgets(
    'Interaction Test: clicking Google login should trigger AuthGoogleLogin event',
    (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());

      await tester.pumpWidget(makeTestableWidget(const LoginScreen()));

      // Find and click the Google button inside the SignInButton
      await tester.tap(find.byKey(const Key('googleLoginButton')));
      await tester.pump();

      verify(
        () => mockAuthBloc.add(any(that: isA<AuthGoogleLogin>())),
      ).called(1);
    },
  );

  testWidgets(
    'State Test: when standard login is loading, should display Loader and hide the standard login button',
    (WidgetTester tester) async {
      // Mock the standard login loading state
      when(
        () => mockAuthBloc.state,
      ).thenReturn(const AuthLoading(type: AuthLoadingType.normal));

      await tester.pumpWidget(makeTestableWidget(const LoginScreen()));

      // The standard login button should be replaced by the Loader (Key should not be found)
      expect(find.byKey(const Key('loginButton')), findsNothing);
      // Third-party login buttons should remain intact on the screen
      expect(find.byKey(const Key('googleLoginButton')), findsOneWidget);
      expect(find.byKey(const Key('facebookLoginButton')), findsOneWidget);
      // Verify that the Loader is indeed rendered
      expect(find.byType(Loader), findsOneWidget);
    },
  );

  testWidgets(
    'State Test: when Google login is loading, only the Google area should display the Loader',
    (WidgetTester tester) async {
      // Mock the Google login loading state
      when(
        () => mockAuthBloc.state,
      ).thenReturn(const AuthLoading(type: AuthLoadingType.google));

      await tester.pumpWidget(makeTestableWidget(const LoginScreen()));

      // Google button disappears and turns into a Loader
      expect(find.byKey(const Key('googleLoginButton')), findsNothing);
      // The standard login button and Facebook button must still exist
      expect(find.byKey(const Key('loginButton')), findsOneWidget);
      expect(find.byKey(const Key('facebookLoginButton')), findsOneWidget);

      expect(find.byType(Loader), findsOneWidget);
    },
  );
}
