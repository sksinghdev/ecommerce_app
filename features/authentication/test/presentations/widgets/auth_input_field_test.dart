

import 'package:authentication/presentation/widgets/auth_input_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
 
void main() {
  group('AuthInputField Widget Test', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    testWidgets('renders correctly with label and icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthInputField(
              labelText: 'Email',
              icon: Icons.email,
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('shows validation error when empty', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AuthInputField(
                labelText: 'Email',
                icon: Icons.email,
                controller: controller,
              ),
            ),
          ),
        ),
      );

      // Trigger validation
      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Please enter your Email'), findsOneWidget);
    });

    testWidgets('shows email validation error when email is invalid', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      controller.text = 'invalidemail';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AuthInputField(
                labelText: 'Email',
                icon: Icons.email,
                controller: controller,
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('passes validation with valid email', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      controller.text = 'test@example.com';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AuthInputField(
                labelText: 'Email',
                icon: Icons.email,
                controller: controller,
              ),
            ),
          ),
        ),
      );

      final isValid = formKey.currentState!.validate();
      expect(isValid, isTrue);
    });
  });
}
