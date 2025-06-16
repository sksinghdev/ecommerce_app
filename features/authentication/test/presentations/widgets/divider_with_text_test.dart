import 'package:authentication/presentation/widgets/divider_with_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DividerWithText Widget Test', () {
    testWidgets('renders text and dividers correctly',
        (WidgetTester tester) async {
      const testText = 'OR';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DividerWithText(text: testText),
          ),
        ),
      );

      // Expect the text is found
      expect(find.text(testText), findsOneWidget);

      // Expect two Divider widgets
      expect(find.byType(Divider), findsNWidgets(2));

      // Expect one Row
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('text has correct style', (WidgetTester tester) async {
      const testText = 'OR';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DividerWithText(text: testText),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text(testText));
      expect(textWidget.style?.color, Colors.grey);
    });
  });
}
