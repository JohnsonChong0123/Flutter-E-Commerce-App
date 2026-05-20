import 'package:e_commerce_client/core/common/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppButton Core Contract Test: Verify behavior, global styles, and physical dimensions defense', (WidgetTester tester) async {
    int isPressedCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            title: 'Click Me',
            onPressed: () => isPressedCount++,
          ),
        ),
      ),
    );

    // ==================== Defense Line 1: Business Behavior and Text ====================
    expect(find.text('Click Me'), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    await tester.pump();
    expect(isPressedCount, 1);

    // ==================== Defense Line 2: Physical Dimensions Defense (Prevents height from being modified) ====================
    // Find the SizedBox that contains the hardcoded width and height inside the widget
    final SizedBox sizedBoxWidget = tester.widget(
      find.descendant(
        of: find.byType(AppButton),
        matching: find.byType(SizedBox),
      ).first, // Get the SizedBox at the root of the AppButton
    );
    
    // Assertions: Width must stretch to fill (infinity), height must be locked at 50.0
    expect(sizedBoxWidget.width, double.infinity);
    expect(sizedBoxWidget.height, 50.0); // 👈 If anyone changes this number, CI/CD will fail immediately!

    // ==================== Defense Line 3: Font Style Defense (Prevents font size from being modified) ====================
    final Text textWidget = tester.widget(find.text('Click Me'));
    
    // Assertion: Font size must be locked at 15.0
    expect(textWidget.style?.fontSize, 15.0); // 👈 If anyone scales this font up or down, the unit test intercepts it directly!
  });
}