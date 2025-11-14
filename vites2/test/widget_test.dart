import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vites2/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Vites2App());

    // Verify that the app shows the home page title.
    expect(find.text('Vites2'), findsOneWidget);
    // Verify that the app shows the home page body text.
    expect(find.text('Vites2 Ana Sayfa'), findsOneWidget);
  });
}
