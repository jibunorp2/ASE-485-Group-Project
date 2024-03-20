import 'package:bookme/Login_Pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Login Page UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));


    expect(find.text('Login'), findsOneWidget);

    expect(find.byType(TextField), findsNWidgets(2));

    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Empty Login Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    // Tap on the login button
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify that the user is still on the login page
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Successful Login Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    // Enter email and password
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).last, 'password');

    // Tap on the login button
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Verify that the user navigates to the contact page
    expect(find.text('Contacts Page'), findsOneWidget);
  });
}