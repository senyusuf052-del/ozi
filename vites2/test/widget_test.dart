// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:vites2/main.dart';
import 'mock.dart';

void main() {
  setupFirebaseMocks();

  testWidgets('Vites2App builds and renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Vites2App());

    // Verify that our app starts.
    expect(find.byType(Vites2App), findsOneWidget);
  });
}
