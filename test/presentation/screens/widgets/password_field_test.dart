import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import 'package:e_commerce_client/presentation/widgets/password_field.dart';

void main() {
  late TextEditingController controller;
  late ValueNotifier<bool> isObscureNotifier;
  late ValueNotifier<PasswordStrength?> strengthNotifier;

  setUp(() {
    controller = TextEditingController();
    isObscureNotifier = ValueNotifier<bool>(true); // Hide password by default
    strengthNotifier = ValueNotifier<PasswordStrength?>(null);
  });

  tearDown(() {
    controller.dispose();
    isObscureNotifier.dispose();
    strengthNotifier.dispose();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('PasswordField Widget Tests', () {
    testWidgets(
      'Rendering Test: should correctly render base components and initial hidden state',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            PasswordField(
              controller: controller,
              isObscureNotifier: isObscureNotifier,
              hintText: 'Password',
            ),
          ),
        );

        // Verify that hintText is displayed correctly
        expect(find.text('Password'), findsOneWidget);

        // Verify that the visibility eye icon exists
        expect(find.byIcon(Icons.visibility), findsOneWidget);

        // Verify that the underlying TextField is indeed in obscure mode (obscureText == true)
        final TextField textField = tester.widget(find.byType(TextField));
        expect(textField.obscureText, isTrue);
      },
    );

    testWidgets(
      'Interaction Test: clicking the eye icon should toggle password visibility',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            PasswordField(
              controller: controller,
              isObscureNotifier: isObscureNotifier,
              hintText: 'Password',
            ),
          ),
        );

        // 1. Click the eye icon
        await tester.tap(find.byIcon(Icons.visibility));
        await tester.pump(); // Trigger ValueListenableBuilder rebuild

        // 2. Verify that the ValueNotifier value changed to false
        expect(isObscureNotifier.value, isFalse);

        // 3. Verify that the underlying TextField changed to plain text mode
        final TextField textField = tester.widget(find.byType(TextField));
        expect(textField.obscureText, isFalse);
      },
    );

    testWidgets(
      'Logic Test: typing text should automatically calculate and update password strength',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            PasswordField(
              controller: controller,
              isObscureNotifier: isObscureNotifier,
              strengthNotifier: strengthNotifier,
              hintText: 'Password',
            ),
          ),
        );

        // 1. Initial state strength should be null
        expect(strengthNotifier.value, isNull);

        // 2. Enter a simple, weak password
        await tester.enterText(find.byType(TextFormField), '123');
        await tester.pump();

        // 3. Verify strengthNotifier received a value, and since it's too short, it should be weak
        expect(strengthNotifier.value, isNotNull);
        expect(strengthNotifier.value, PasswordStrength.weak);

        // 4. Enter a complex, strong password (contains uppercase, lowercase, numbers, special characters, and sufficient length)
        await tester.enterText(find.byType(TextFormField), 'Atelier2026!');
        await tester.pump();

        // 5. Verify if the strength updates to strong or secure
        expect(strengthNotifier.value, PasswordStrength.secure);
      },
    );

    testWidgets(
      'Boundary Test: typing text should not throw an error when strengthNotifier is not provided',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            PasswordField(
              controller: controller,
              isObscureNotifier: isObscureNotifier,
              hintText: 'Password', // strengthNotifier is omitted here
            ),
          ),
        );

        // Try entering text to ensure it doesn't trigger a crash like NullThrownError
        await tester.enterText(find.byType(TextFormField), 'any_password');
        await tester.pump();

        // If it runs to this point without throwing an error, the `if (strengthNotifier != null)` branch passed safely
        expect(controller.text, 'any_password');
      },
    );
  });
}
