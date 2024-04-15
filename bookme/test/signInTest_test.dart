import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookme/Login_Pages/sign_in_page.dart';

void main() {
  testWidgets('Test if sign-in page UI renders correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SignInPage(),
    ));

    // Verify that the app bar title is displayed
    expect(find.text('BookMe - Sign In'), findsOneWidget);

    // Verify that the Log In button is displayed
    expect(find.text('Log In'), findsOneWidget);

    // Verify that the Register button is displayed
    expect(find.text('Register'), findsOneWidget);
  });
}
