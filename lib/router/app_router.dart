import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_task_app/presentations/create_note_screen.dart';
import 'package:notes_task_app/presentations/home_screen.dart';
import 'package:notes_task_app/presentations/note_detail_screen.dart';
import 'package:notes_task_app/presentations/profile_screen.dart';
import 'package:notes_task_app/presentations/sign_up_screen.dart';
import 'package:notes_task_app/router/app_routes.dart';
import '../mvvm/models/note_model.dart';
import '../presentations/sign_in_screen.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class AppRouter {
  static GoRouter createRouter(WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return GoRouter(
      initialLocation: AppRoutes.signInScreen,
      routes: [
        GoRoute(
          path: AppRoutes.homeScreen,
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.signUpScreen,
          builder: (context, state) => SignUpScreen(),
        ),
        GoRoute(
          path: AppRoutes.signInScreen,
          builder: (context, state) => SignInScreen(),
        ),
        GoRoute(
          path: AppRoutes.creatNoteScreen,
          builder: (context, state) => CreateNoteScreen(),
        ),
        GoRoute(
            path: AppRoutes.noteDetailScreen,
            builder: (context, state) {
              final note = state.extra as NoteModel;
              return NoteDetailScreen(
                note: note,
              );
            }),
        GoRoute(
          path: AppRoutes.profileScreen,
          builder: (context, state) => ProfileScreen(),
        ),
      ],
      errorBuilder: (context, state) => ErrorPage(),
      redirect: (context, state) {
        final isLoggedIn = authState.asData?.value != null;
        final isOnSignInScreen = state.uri.toString() == AppRoutes.signInScreen;
        final isOnSignUpScreen = state.uri.toString() == AppRoutes.signUpScreen;

        if (!isLoggedIn && !isOnSignInScreen && !isOnSignUpScreen) {
          return AppRoutes.signInScreen;
        }

        if (isLoggedIn && (isOnSignInScreen || isOnSignUpScreen)) {
          return AppRoutes.homeScreen;
        }
        return null;
      },
      refreshListenable:
          GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<User?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<User?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Text('Error Page'),
      ),
    );
  }
}



// final isLoggingIn = state.uri.toString() == AppRoutes.signInScreen ||
        //     state.uri.toString() == AppRoutes.signUpScreen;

        // if (!isLoggedIn && !isLoggingIn) {
        //   return AppRoutes.signInScreen; // Not logged in, redirect to login
        // }
        // if (isLoggedIn && isLoggingIn) {
        //   return AppRoutes.homeScreen; // Logged in, redirect to home
        // }