import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_task_app/constants/colors.dart';
import 'package:notes_task_app/mvvm/repositories/auth_repo.dart';
import 'package:notes_task_app/router/app_routes.dart';

import '../models/user_model.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<void>>(
  (ref) => AuthViewModel(AuthRepository()),
);

class AuthViewModel extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository) : super(const AsyncValue.data(null));

  Future<void> registerUser(
      {required BuildContext context,
      required String userName,
      required String email,
      required String password,
      required String confirmPassword}) async {
    if (password != confirmPassword) {
      _showSnackbar(context, 'Password do not match');
      return;
    }
    state = const AsyncValue.loading();
    try {
      UserModel user = UserModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userName: userName,
          email: email,
          password: password);
      await _authRepository.registerUser(user);
      state = const AsyncValue.data(null);
      _showSnackbar(context, 'Registration successful. Please log in.');

      context.go(AppRoutes.signInScreen);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
      log('Error registering user: $e');
    }
  }

  Future<void> loginUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.loginUser(email, password);
      state = const AsyncValue.data(null);
      _showSnackbar(context, 'Login successful');
      context.go(AppRoutes.homeScreen);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
      log('Error logging in user: $e');
    }
  }

  Future<void> logoutUser({required BuildContext context}) async {
    state = const AsyncValue.loading();
    try {
      await FirebaseAuth.instance.signOut();
      state = const AsyncValue.data(null);
      _showSnackbar(context, "You'r log out");
      context.go(AppRoutes.signInScreen);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      log('Error logOut user: $e');
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: yellowColor,
          content: Text(
            message,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: darkGreyColor),
          )),
    );
  }
}
