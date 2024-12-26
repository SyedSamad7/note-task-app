import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_task_app/extensions/input_validator_extensions.dart';
import 'package:notes_task_app/mvvm/view%20models/auth_view_model.dart';
import 'package:notes_task_app/router/app_routes.dart';

import '../components/input_text_field.dart';
import '../components/primary_button.dart';
import '../constants/colors.dart';

class SignInScreen extends ConsumerWidget {
  SignInScreen({super.key});

  final _loginKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Widget _buildTitle() {
    return Text(
      'Sign In',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: whiteColor,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    bool isPasswordObscure = false,
  }) {
    return InputTextField(
      controller: controller,
      hintText: hintText,
      isPasswordObscure: isPasswordObscure,
      validator: validator,
    );
  }

  Widget _buildAuthButton({
    required String label,
    required VoidCallback onTap,
    required Color backgroundColor,
  }) {
    return PrimaryButton(
      onTap: onTap,
      width: double.infinity,
      label: label,
      backGroundColor: backgroundColor,
      alignment: Alignment.center,
      borderRadius: 30,
    );
  }

  Widget _buildSignUpRedirect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: lightGreyColor,
          ),
        ),
        InkWell(
          onTap: () => context.go(AppRoutes.signUpScreen),
          child: Container(
            height: 30,
            width: 70,
            alignment: Alignment.center,
            child: const Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: yellowColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.watch(authViewModelProvider.notifier);
    final authState = ref.watch(authViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign In'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Form(
              key: _loginKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 24),
                  _buildInputField(
                    controller: _emailController,
                    hintText: 'Email',
                    validator: InputValidator.validateEmail,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    controller: _passwordController,
                    hintText: 'Password',
                    isPasswordObscure: true,
                    validator: InputValidator.validatePassword,
                  ),
                  const SizedBox(height: 48),
                  authState.when(
                    data: (_) => _buildAuthButton(
                      label: 'Sign In',
                      onTap: () async {
                        if (_loginKey.currentState!.validate()) {
                          await authViewModel.loginUser(
                            context: context,
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                        }
                      },
                      backgroundColor: yellowColor,
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, _) => Column(
                      children: [
                        const Text(
                          'Something went wrong! Try again.',
                          style: TextStyle(color: Colors.red),
                        ),
                        _buildAuthButton(
                          label: 'Sign In',
                          onTap: () async {
                            if (_loginKey.currentState!.validate()) {
                              await authViewModel.loginUser(
                                context: context,
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                            }
                          },
                          backgroundColor: yellowColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildSignUpRedirect(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
