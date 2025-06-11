import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/auth_input_field_widget.dart';
import '../widgets/divider_with_text_widget.dart';
import '../widgets/primarty_button_widget.dart';
import '../widgets/socail_signin_button_widget.dart';



@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                const AuthInputField(
                  labelText: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                const AuthInputField(
                  labelText: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 8),
                const PrimaryButton(text: 'Login'),
                const SizedBox(height: 24),
                const DividerWithText(text: 'or sign in with'),
                const SizedBox(height: 24),
                const SocialSignInButton(
                  text: 'Sign in with Google',
                  icon: Icons.g_mobiledata,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}