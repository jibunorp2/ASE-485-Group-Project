import 'package:bookme/Login_Pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  testWidgets('Sign In Page UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignInPage()));

    // Verify that the app bar title is rendered
    expect(find.text('BookMe - Sign In'), findsOneWidget);

    // Verify that the Log In button is rendered
    expect(find.text('Log In'), findsOneWidget);

    // Verify that the Register button is rendered
    expect(find.text('Register'), findsOneWidget);
  });
}