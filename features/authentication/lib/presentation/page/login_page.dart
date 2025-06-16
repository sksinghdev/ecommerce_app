import 'package:common/presentation/bloc/auth_cubit.dart';
import 'package:common/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:common/common.dart';
import 'package:ecommerce_app/src/application/di/injection_container.dart';

import 'package:product_listing/core/injection/product_router.gr.dart';
import '../widgets/auth_input_field_widget.dart';
import '../widgets/divider_with_text_widget.dart';
import '../widgets/primarty_button_widget.dart';
import '../widgets/socail_signin_button_widget.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injector<AuthCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login..')),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: _authStateListener,
          builder: (context, state) {
            return Stack(
              children: [
                _buildLoginForm(context),
                if (state is AuthLoading) ...[
                  const Opacity(
                    opacity: 0.5,
                    child:
                        ModalBarrier(dismissible: false, color: Colors.black),
                  ),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  void _authStateListener(BuildContext context, AuthState state) {
    if (state is Unauthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message ?? 'Error in Unauthenticated')),
      );
    }
    if (state is Authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful')),
      );
      context.replaceRoute(const ProductsRoute());
    }
  }

  Widget _buildLoginForm(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 40),
            _buildEmailField(emailController),
            const SizedBox(height: 16),
            _buildPasswordField(passwordController),
            _buildForgotPasswordButton(),
            const SizedBox(height: 8),
            _buildLoginButton(context, emailController, passwordController),
            const SizedBox(height: 24),
            const DividerWithText(text: 'or sign in with'),
            const SizedBox(height: 24),
            _buildGoogleSignInButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Welcome Back!',
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildEmailField(TextEditingController controller) {
    return AuthInputField(
      labelText: 'Email',
      icon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      controller: controller,
    );
  }

  Widget _buildPasswordField(TextEditingController controller) {
    return AuthInputField(
      labelText: 'Password',
      icon: Icons.lock,
      obscureText: true,
      controller: controller,
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {}, // No change to logic
        child: const Text('Forgot Password?'),
      ),
    );
  }

  Widget _buildLoginButton(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController) {
    return PrimaryButton(
      text: 'Login',
      onPressed: () {
        _callEmailLogin(context, emailController.text, passwordController.text);
      },
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return SocialSignInButton(
      text: 'Sign in with Google',
      onPressed: () => context.read<AuthCubit>().loginWithGoogle(),
      icon: Icons.g_mobiledata,
    );
  }

  void _callEmailLogin(BuildContext context, String email, String password) {
    context.read<AuthCubit>().loginWithEmail(email, password);
  }
}
