import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookme/Login_Pages/login_page.dart';
import 'package:bookme/Login_Pages/sign_in_page.dart';
import 'package:bookme/Login_Pages/register_page.dart';

void main() {
  testWidgets('Test if sign-in page buttons work correctly',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: SignInPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
    ));

    // Verify that sign-in page is displayed.
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);

    // Tap on the Log In button.
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    // Verify that we navigated to the login page.
    expect(find.byType(LoginPage), findsOneWidget);

    // Go back to the sign-in page.
    await tester.pageBack();

    // Tap on the Register button.
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    // Verify that we navigated to the register page.
    expect(find.byType(RegisterPage), findsOneWidget);
  });
}
