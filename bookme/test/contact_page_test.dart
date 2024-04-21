import 'package:bookme/Contact_Pages.dart/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  testWidgets('Test Delete Function', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ContactPage()));


    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Jane Smith'), findsOneWidget);
    expect(find.text('Bob Johnson'), findsOneWidget);
    expect(find.text('Alice Williams'), findsOneWidget);

    await tester.tap(find.widgetWithIcon(IconButton, Icons.delete).first);
    await tester.pump();
    await tester.tap(find.widgetWithText(TextButton, 'Delete').first);
    await tester.pump();

    expect(find.text('John Doe'), findsNothing);
    expect(find.text('Jane Smith'), findsOneWidget);
    expect(find.text('Bob Johnson'), findsOneWidget);
    expect(find.text('Alice Williams'), findsOneWidget);

  });
}