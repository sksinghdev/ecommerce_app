import 'package:common/presentation/bloc/auth_cubit.dart';
import 'package:common/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:common/common.dart';
import 'package:ecommerce_app/src/application/di/injection_container.dart';

import 'package:product_listing/core/injection/product_router.dart';
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
          listener: (context, state) {
            if (state is Unauthenticated) {
               ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message ?? 'Error in Unauthenticated')),
              );
            }
            if (state is Authenticated) {
 
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login Successful')),
              );

              context.replaceRoute(const ProductsRoute());
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                _getLoginView(context),
                if (state is AuthLoading)
                  const Opacity(
                    opacity: 0.5,
                    child:
                        ModalBarrier(dismissible: false, color: Colors.black),
                  ),
                if (state is AuthLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _getLoginView(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return SafeArea(
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
              AuthInputField(
                labelText: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              const SizedBox(height: 16),
              AuthInputField(
                labelText: 'Password',
                icon: Icons.lock,
                obscureText: true,
                controller: passwordController,
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
              PrimaryButton(
                  text: 'Login',
                  onPressed: () {
                    _callEmailLogin(
                        context, emailController.text, passwordController.text);
                  }),
              const SizedBox(height: 24),
              const DividerWithText(text: 'or sign in with'),
              const SizedBox(height: 24),
              SocialSignInButton(
                text: 'Sign in with Google',
                onPressed: () => context.read<AuthCubit>().loginWithGoogle(),
                icon: Icons.g_mobiledata,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _callEmailLogin(BuildContext context, String email, String password) {
    context.read<AuthCubit>().loginWithEmail(
          email,
          password,
        );
  }
}
