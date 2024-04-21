import 'package:bookme/main.dart';
import 'package:bookme/Login_Pages/sign_in_page.dart';
import 'package:flutter_test/flutter_test.dart';
// Assuming your project structure is such

void main() {
  testWidgets('Test if sign-in page is displayed', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that sign-in page is displayed.
    expect(find.byType(SignInPage), findsOneWidget);
  });
}
