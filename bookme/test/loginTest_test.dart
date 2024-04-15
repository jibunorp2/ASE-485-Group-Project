import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookme/Contact_Pages.dart/contact_page.dart';
import 'package:bookme/Login_Pages/login_page.dart';

void main() {
  testWidgets('Test login functionality', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LoginPage(),
    ));

    final emailField = find.widgetWithText(TextField, 'Email');
    final passwordField = find.widgetWithText(TextField, 'Password');
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');

    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    // Enter some email and password
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password');

    // After entering email and password, button should be enabled
    expect(tester.widget<ElevatedButton>(loginButton).enabled, true);

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

    final loginButton = find.widgetWithText(ElevatedButton, 'Login');

    // Enter some email and leave password empty
    await tester.enterText(
        find.widgetWithText(TextField, 'Email'), 'test@example.com');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), '');

    // Enter password
    await tester.enterText(
        find.widgetWithText(TextField, 'Password'), 'password');

    // After entering password, button should be enabled
    expect(tester.widget<ElevatedButton>(loginButton).enabled, true);
  });
}
