import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookme/Login_Pages/register_page.dart';

void main() {
  testWidgets('Test if register page UI renders correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: RegisterPage(),
    ));

    // Verify that the name, email, and password fields are displayed
    expect(
        find.byWidgetPredicate((widget) =>
            widget is TextField && widget.decoration?.labelText == 'Name'),
        findsOneWidget);
    expect(
        find.byWidgetPredicate((widget) =>
            widget is TextField && widget.decoration?.labelText == 'Email'),
        findsOneWidget);
    expect(
        find.byWidgetPredicate((widget) =>
            widget is TextField && widget.decoration?.labelText == 'Password'),
        findsOneWidget);
  });
}
