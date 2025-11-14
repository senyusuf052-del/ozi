import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vites2/main.dart';

void main() {
  // Bu temel test, uygulamanın ana widget'ının (Vites2App)
  // bir hata fırlatmadan oluşturulup oluşturulamadığını kontrol eder.
  // Bu, Firebase başlatma karmaşıklığı olmadan bir "smoke test" görevi görür.
  testWidgets('Vites2App builds without crashing', (WidgetTester tester) async {
    // Firebase başlatma sorunlarını önlemek için,
    // doğrudan Vites2App'i test ediyoruz, main() fonksiyonunu değil.
    // Gerçek bir uygulamada, bu widget'ı sahte (mock) verilerle sarmalamak gerekir.

    // Uygulama widget'ını oluştur.
    await tester.pumpWidget(const Vites2App());

    // Uygulamanın bir MaterialApp içerdiğini doğrula.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
