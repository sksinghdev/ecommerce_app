import 'package:authentication/presentation/widgets/socail_signin_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SocialSignInButton Widget Test', () {
    testWidgets('renders correct text and icon', (WidgetTester tester) async {
      const buttonText = 'Sign in with Google';
      const buttonIcon = Icons.g_mobiledata;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSignInButton(
              text: buttonText,
              icon: buttonIcon,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text(buttonText), findsOneWidget);
      expect(find.byIcon(buttonIcon), findsOneWidget);
    });
  });
}
