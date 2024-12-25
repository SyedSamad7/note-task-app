import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../components/input_text_field.dart';
import '../components/primary_button.dart';
import '../constants/colors.dart';
import '../extensions/input_validator_extensions.dart';
import '../mvvm/view models/auth_view_model.dart';
import '../router/app_routes.dart';

class SignUpScreen extends ConsumerWidget {
  SignUpScreen({super.key});

  final signUpKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassworkController =
      TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.watch(authViewModelProvider.notifier);
    final authState = ref.watch(authViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Un'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: signUpKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: whiteColor),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    InputTextField(
                      controller: userNameController,
                      hintText: 'Name',
                      validator: (value) =>
                          InputValidator.validateInputField(value),
                    ),
                    const SizedBox(
                      height: 20,
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
                      height: 20,
                    ),
                    InputTextField(
                        controller: confirmPassworkController,
                        hintText: 'Confirm Password',
                        isPasswordObscure: true,
                        validator: (value) =>
                            InputValidator.validatePassword(value)),
                    const SizedBox(
                      height: 48,
                    ),
                    authState.when(
                      data: (_) => PrimaryButton(
                        onTap: () async {
                          if (signUpKey.currentState!.validate()) {
                            await authViewModel.registerUser(
                              context: context,
                              userName: userNameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              confirmPassword: confirmPassworkController.text,
                            );
                          }
                        },
                        width: double.infinity,
                        label: 'Sign Un',
                        backGroundColor: yellowColor,
                        alignment: Alignment.center,
                        borderRadius: 30,
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (error, _) => Column(
                        children: [
                          Text(
                            'Something went wrong! try again',
                            style: const TextStyle(color: Colors.red),
                          ),
                          PrimaryButton(
                            onTap: () async {
                              if (signUpKey.currentState!.validate()) {
                                await authViewModel.registerUser(
                                  context: context,
                                  userName: userNameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  confirmPassword:
                                      confirmPassworkController.text,
                                );
                              }
                            },
                            width: double.infinity,
                            label: 'Sign Up',
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
                          "Already have an account?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: lightGreyColor,
                          ),
                        ),
                        InkWell(
                          onTap: () => context.go(AppRoutes.signInScreen),
                          child: Container(
                            height: 30,
                            width: 70,
                            alignment: Alignment.center,
                            child: const Text(
                              "Sign In",
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
