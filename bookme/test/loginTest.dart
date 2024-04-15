import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookme/Contact_Pages.dart/contact_page.dart';
import 'package:bookme/Login_Pages/login_page.dart';

void main() {
  testWidgets('Test login functionality', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LoginPage(),
    ));

    final emailField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);
    final loginButton = find.text('Login');

    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    // Enter some email and password
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password');

    // Tap the login button
    await tester.tap(loginButton);

    // Wait for the Navigator to finish pushing the next route
    await tester.pumpAndSettle();

    // Ensure that the ContactPage is pushed after successful login
    expect(find.byType(ContactPage), findsOneWidget);
  });

  testWidgets('Test login button disabled when email and password are empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LoginPage(),
    ));

    final loginButton = find.text('Login');

    // Initially, login button should be disabled
    expect(tester.widget<ElevatedButton>(loginButton).enabled, false);

    // Enter some email and password
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), '');

    // After entering email, button should still be disabled
    expect(tester.widget<ElevatedButton>(loginButton).enabled, false);

    // Enter password
    await tester.enterText(find.byType(TextField).at(1), 'password');

    // After entering password, button should be enabled
    expect(tester.widget<ElevatedButton>(loginButton).enabled, true);
  });
}
