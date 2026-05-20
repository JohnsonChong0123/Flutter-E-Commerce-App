import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_client/core/common/widgets/loader.dart';

void main() {
  testWidgets('Loader Core Contract Test: should render Center and CircularProgressIndicator', (WidgetTester tester) async {
    // 1. Render the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Loader(),
        ),
      ),
    );

    // 2. Defense Line: Verify that the core atomic widgets exist
    expect(find.byType(Loader), findsOneWidget);
    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}