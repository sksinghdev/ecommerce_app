import 'package:authentication/presentation/widgets/primarty_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PrimaryButton Widget Test', () {
    testWidgets('renders with correct text', (WidgetTester tester) async {
      const buttonText = 'Continue';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: buttonText,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify the text is displayed
      expect(find.text(buttonText), findsOneWidget);

      // Verify it's an ElevatedButton
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Tap Me',
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(wasPressed, isTrue);
    });

    testWidgets('has correct styling', (WidgetTester tester) async {
      const buttonText = 'Styled';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: buttonText,
              onPressed: () {},
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final style = button.style;

      // Style assertions (optional and may need tweaking)
      expect(style?.backgroundColor?.resolve({}), Colors.blue);
      expect(style?.foregroundColor?.resolve({}), Colors.white);
    });
  });
}
