import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce_client/core/common/widgets/loader.dart';
import 'package:e_commerce_client/presentation/blocs/auth/auth_bloc.dart';
import 'package:e_commerce_client/presentation/screens/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Mock AuthBloc
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    registerFallbackValue(
      const AuthSignUp(
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
        password: '',
      ),
    );
  });

  // Helper method: Wrap the necessary Provider and Material environment
  Widget makeTestableWidget(Widget body) {
    return BlocProvider<AuthBloc>.value(
      value: mockAuthBloc,
      child: MaterialApp(home: body),
    );
  }

  group('SignUpScreen Widget Tests', () {
    testWidgets(
      'Widget test: should display all input fields and sign up button',
      (WidgetTester tester) async {
        // Set an initial state
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(makeTestableWidget(const SignUpScreen()));

        // Use the keys defined in your code to find
        expect(find.byKey(const Key('firstNameField')), findsOneWidget);
        expect(find.byKey(const Key('lastNameField')), findsOneWidget);
        expect(find.byKey(const Key('emailField')), findsOneWidget);
        expect(find.byKey(const Key('phoneField')), findsOneWidget);
        expect(find.byKey(const Key('passwordField')), findsOneWidget);
        expect(find.byKey(const Key('confirmPasswordField')), findsOneWidget);
        expect(find.byKey(const Key('signUpButton')), findsOneWidget);
        expect(find.text("Join the Atelier"), findsOneWidget);
      },
    );

    testWidgets(
      'Logic test: should display error message when passwords do not match',
      (WidgetTester tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(makeTestableWidget(const SignUpScreen()));

        // Enter password
        await tester.enterText(
          find.byKey(const Key('passwordField')),
          'Password123!',
        );
        // Enter mismatched confirm password
        await tester.enterText(
          find.byKey(const Key('confirmPasswordField')),
          'WrongPass123',
        );

        await tester.ensureVisible(find.byKey(const Key('signUpButton')));
        await tester.pumpAndSettle(); // Wait for scroll animation to complete

        // Tap sign up
        await tester.tap(find.byKey(const Key('signUpButton')));
        await tester.pump(); // Trigger a rebuild to show validation error

        expect(find.text("Passwords do not match"), findsOneWidget);
        // Verify that no Bloc event was triggered
        verifyNever(() => mockAuthBloc.add(any()));
      },
    );

    testWidgets(
      'Logic test: should toggle password visibility when eye icon is tapped',
      (WidgetTester tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(makeTestableWidget(const SignUpScreen()));

        // Initially, password should be obscured
        final passwordFieldFinder = find.byKey(const Key('passwordField'));
        final textFieldFinder = find.descendant(
          of: passwordFieldFinder,
          matching: find.byType(TextField),
        );

        TextField textField = tester.widget(textFieldFinder);
        expect(textField.obscureText, isTrue);

        // Tap the eye icon to toggle visibility
        await tester.tap(
          find.descendant(
            of: find.byKey(const Key('passwordField')),
            matching: find.byType(IconButton),
          ),
        );
        await tester.pump(); // Trigger a rebuild

        // After tapping, password should be visible
        textField = tester.widget(textFieldFinder);
        expect(textField.obscureText, isFalse);
      },
    );

    testWidgets(
      'Validation test: should show error when required fields are empty',
      (WidgetTester tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(makeTestableWidget(const SignUpScreen()));

        await tester.ensureVisible(find.byKey(const Key('signUpButton')));
        await tester.pumpAndSettle(); // Wait for scroll animation to complete

        // Tap sign up without filling any fields
        await tester.tap(find.byKey(const Key('signUpButton')));
        await tester.pump(); // Trigger a rebuild to show validation errors

        expect(find.text("Please enter your first name"), findsOneWidget);
        expect(find.text("Please enter your last name"), findsOneWidget);
        expect(find.text("Please enter your email"), findsOneWidget);
        expect(find.text("Please enter your phone number"), findsOneWidget);
        expect(find.text("Please enter your password"), findsOneWidget);

        // Verify that no Bloc event was triggered
        verifyNever(() => mockAuthBloc.add(any()));
      },
    );

    testWidgets(
      'Validation test: should show error when email format is invalid',
      (WidgetTester tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(makeTestableWidget(const SignUpScreen()));

        // Enter invalid email
        await tester.enterText(
          find.byKey(const Key('emailField')),
          'invalid-email',
        );

        await tester.drag(find.byType(Scrollable).first, const Offset(0, -200));
        await tester.pumpAndSettle(); // Wait for scroll animation to complete

        await tester.ensureVisible(find.byKey(const Key('signUpButton')));

        // Tap sign up
        await tester.tap(find.byKey(const Key('signUpButton')));
        await tester.pump(); // Trigger a rebuild to show validation error

        expect(find.text("Please enter a valid email"), findsOneWidget);
        // Verify that no Bloc event was triggered
        verifyNever(() => mockAuthBloc.add(any()));
      },
    );

    testWidgets(
      'Validation test: should show error when phone number format is invalid',
      (WidgetTester tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(makeTestableWidget(const SignUpScreen()));

        // Enter invalid phone number
        await tester.enterText(
          find.byKey(const Key('phoneField')),
          'invalid-phone',
        );

        await tester.drag(find.byType(Scrollable).first, const Offset(0, -200));
        await tester.pumpAndSettle(); // Wait for scroll animation to complete

        await tester.ensureVisible(find.byKey(const Key('signUpButton')));
        // Tap sign up
        await tester.tap(find.byKey(const Key('signUpButton')));
        await tester.pump(); // Trigger a rebuild to show validation error

        expect(find.text("Please enter a valid phone number"), findsOneWidget);
        // Verify that no Bloc event was triggered
        verifyNever(() => mockAuthBloc.add(any()));
      },
    );

    testWidgets(
      'State test: should display Loader instead of button when AuthLoading',
      (WidgetTester tester) async {
        // Simulate loading state
        when(() => mockAuthBloc.state).thenReturn(AuthLoading());

        await tester.pumpWidget(makeTestableWidget(const SignUpScreen()));

        // Verify Loader is displayed
        expect(find.byType(Loader), findsOneWidget);
        // Verify sign up button is gone
        expect(find.byKey(const Key('signUpButton')), findsNothing);
      },
    );

    testWidgets(
      'Success flow test: should send AuthSignUp event after form validation passes',
      (WidgetTester tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(makeTestableWidget(const SignUpScreen()));

        // Fill in all required fields
        await tester.enterText(find.byKey(const Key('firstNameField')), 'John');
        await tester.enterText(find.byKey(const Key('lastNameField')), 'Doe');
        await tester.enterText(
          find.byKey(const Key('emailField')),
          'test@example.com',
        );
        await tester.enterText(
          find.byKey(const Key('phoneField')),
          '0123456789',
        );
        await tester.enterText(
          find.byKey(const Key('passwordField')),
          'Password123!',
        );
        await tester.enterText(
          find.byKey(const Key('confirmPasswordField')),
          'Password123!',
        );

        await tester.ensureVisible(find.byKey(const Key('signUpButton')));
        await tester.pumpAndSettle(); // Wait for scroll animation to complete

        await tester.tap(find.byKey(const Key('signUpButton')));
        await tester.pump();

        // Verify that the correct event was added to the Bloc
        verify(() => mockAuthBloc.add(any(that: isA<AuthSignUp>()))).called(1);
      },
    );
  });
}
