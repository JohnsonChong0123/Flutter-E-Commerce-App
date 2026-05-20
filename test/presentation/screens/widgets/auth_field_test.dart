import 'package:e_commerce_client/core/common/widgets/app_button.dart';
import 'package:e_commerce_client/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TextEditingController controller;

  setUp(() {
    controller = TextEditingController();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('AuthField Widget Tests', () {
    testWidgets('should display error message when email input is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          Form(
            child: Builder(
              builder: (context) => Column(
                children: [
                  AuthField(hintText: 'Email', controller: controller),
                  AppButton(
                    onPressed: () => Form.of(context).validate(),
                    title: 'Validate',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Tap the validate button
      await tester.tap(find.text('Validate'));
      await tester.pump();

      // Verify that the error message is displayed
      expect(find.text("Please enter your email"), findsOneWidget);
    });

    testWidgets('should display format error message when email is invalid', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          Form(
            child: Builder(
              builder: (context) => Column(
                children: [
                  AuthField(hintText: 'Email', controller: controller),
                  AppButton(
                    onPressed: () => Form.of(context).validate(),
                    title: 'Validate',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField), 'invalid-email');
      await tester.tap(find.text('Validate'));
      await tester.pump();

      expect(find.text("Please enter a valid email"), findsOneWidget);
    });
    
    testWidgets('should toggle password visibility when icon is tapped', (
      WidgetTester tester,
    ) async {
      bool toggled = false;
      await tester.pumpWidget(
        makeTestableWidget(
          AuthField(
            hintText: 'Password',
            controller: controller,
            isPassword: true,
            isObscure: true,
            toggleVisibility: () => toggled = true,
          ),
        ),
      );

      // Verify initial state: should be visibility icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      // Tap the icon
      await tester.tap(find.byIcon(Icons.visibility));

      // Verify that the callback was called
      expect(toggled, isTrue);
    });

    testWidgets(
      'should display error message when hintText is phone number and input is invalid',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            Form(
              child: Builder(
                builder: (context) => Column(
                  children: [
                    AuthField(hintText: 'Phone Number', controller: controller),
                    AppButton(
                      onPressed: () => Form.of(context).validate(),
                      title: 'Validate',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), '123');
        await tester.tap(find.text('Validate'));
        await tester.pump();

        expect(find.text("Please enter a valid phone number"), findsOneWidget);
      },
    );

    testWidgets('should use custom validator if provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          Form(
            child: Builder(
              builder: (context) => Column(
                children: [
                  AuthField(
                    hintText: 'Email',
                    controller: controller,
                    validator: (value) =>
                        'Custom Error', // Always returns an error message
                  ),
                  AppButton(
                    onPressed: () => Form.of(context).validate(),
                    title: 'Validate',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'valid@email.com');
      await tester.tap(find.text('Validate'));
      await tester.pump();

      // Email is valid, but custom validator forces an error message
      expect(find.text("Custom Error"), findsOneWidget);
    });

    testWidgets('should apply correct keyboard type', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          AuthField(
            hintText: 'Email',
            controller: controller,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
      );

      final TextField textField = tester.widget(find.byType(TextField));
      expect(textField.keyboardType, TextInputType.emailAddress);
    });

    testWidgets('should trigger onChanged callback when text is entered', (
      WidgetTester tester,
    ) async {
      String changedValue = '';
      await tester.pumpWidget(
        makeTestableWidget(
          AuthField(
            hintText: 'Name',
            controller: controller,
            onChanged: (value) => changedValue = value,
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Atelier');
      expect(changedValue, 'Atelier');
    });
  });
}
