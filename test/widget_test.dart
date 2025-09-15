import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/home.dart';

void main() {
  testWidgets('Testa a interface inicial', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Home()));

    expect(find.text('Climate Mobile'), findsOneWidget);
    expect(find.text('Enter your address and press enter'), findsOneWidget);
  });

  testWidgets('Testa entrada de cidade, estado e país',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Home()));

    await tester.enterText(find.byType(TextField).at(0), 'Sorocaba');
    await tester.enterText(find.byType(TextField).at(1), 'SP');
    await tester.enterText(find.byType(TextField).at(2), 'Brasil');
  });
}
