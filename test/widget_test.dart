import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wedly/main.dart';
import 'package:wedly/core/utils/storage_service.dart';

void main() {
  testWidgets('WEDLY app smoke test', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final storageService = await StorageService.getInstance();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(WEDLYApp(storageService: storageService));

    // Verify that the app starts with the home page
    expect(find.text('WEDLY'), findsOneWidget);
    expect(find.text('مرحباً بك في WEDLY'), findsOneWidget);
    expect(find.text('خدماتنا الرئيسية'), findsOneWidget);
  });
}