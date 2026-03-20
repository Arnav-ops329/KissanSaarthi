// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:kissansaarthi/providers/app_provider.dart';
import 'package:kissansaarthi/providers/locale_provider.dart';
import 'package:kissansaarthi/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app wrapped in providers and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ],
        child: const KissanSaarthiApp(),
      ),
    );

    // Verify the app starts without crashing
    await tester.pump();
  });
}
