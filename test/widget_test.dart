import 'package:flutter_test/flutter_test.dart';

import 'package:wedly/main.dart';

void main() {
  testWidgets('WEDLY app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WEDLYApp());

    // Verify that the app starts with the home page
    expect(find.text('WEDLY'), findsOneWidget);
    expect(find.text('مرحباً بك في WEDLY'), findsOneWidget);
    expect(find.text('خدماتنا الرئيسية'), findsOneWidget);
  });
}