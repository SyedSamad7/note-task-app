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

  final loginKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: loginKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sign In',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: whiteColor),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    InputTextField(
                      controller: emailController,
                      hintText: 'Email',
                      validator: (value) => InputValidator.validateEmail(value),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        isPasswordObscure: true,
                        validator: (value) =>
                            InputValidator.validatePassword(value)),
                    const SizedBox(
                      height: 48,
                    ),
                    authState.when(
                      data: (data) => PrimaryButton(
                        onTap: () async {
                          if (loginKey.currentState!.validate()) {
                            await authViewModel.loginUser(
                                context: context,
                                email: emailController.text.trim(),
                                password: passwordController.text.trim());
                          }
                        },
                        width: double.infinity,
                        label: 'Sign In',
                        backGroundColor: yellowColor,
                        alignment: Alignment.center,
                        borderRadius: 30,
                      ),
                      loading: () => CircularProgressIndicator(),
                      error: (error, stackTrace) => Column(
                        children: [
                          Text(
                            'Something went wrong! try again',
                            style: const TextStyle(color: Colors.red),
                          ),
                          PrimaryButton(
                            onTap: () async {
                              if (loginKey.currentState!.validate()) {
                                await authViewModel.loginUser(
                                    context: context,
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim());
                              }
                            },
                            width: double.infinity,
                            label: 'Sign In',
                            backGroundColor: yellowColor,
                            alignment: Alignment.center,
                            borderRadius: 30,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
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
                    ),
                  ]),
            )),
      ),
    );
  }
}
