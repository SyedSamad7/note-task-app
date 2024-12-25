import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_task_app/presentations/creat_note_screen.dart';
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
          builder: (context, state) => CreatNoteScreen(),
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
        // GoRoute(
        //   path: AppRoutes.profileIdScreen,
        //   builder: (context, state) {
        //     final profileId = state.params['id']!;
        //     return ProfileScreen(profileId: profileId);
        //   },
        // ),
      ],
      errorBuilder: (context, state) => ErrorPage(),
      redirect: (context, state) {
        final isLoggedIn = authState.asData?.value != null;
        final isLoggingIn = state.uri.toString() == AppRoutes.signInScreen ||
            state.uri.toString() == AppRoutes.signUpScreen;

        if (!isLoggedIn && !isLoggingIn) {
          return AppRoutes.signInScreen; // Not logged in, redirect to login
        }
        if (isLoggedIn && isLoggingIn) {
          return AppRoutes.homeScreen; // Logged in, redirect to home
        }

        return null; // No redirection needed
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

/// Centralized App Router
// class AppRouter {
//   static final GoRouter router = GoRouter(
//     routes: [
//       GoRoute(
//         path: AppRoutes.homeScreen,
//         name: 'Home',
//         builder: (context, state) => HomeScreen(),
//       ),
//       GoRoute(
//           path: AppRoutes.signUpScreen,
//           name: 'Sign Up',
//           builder: (context, state) => SignUpScreen()),
//       GoRoute(
//           path: AppRoutes.signInScreen,
//           name: 'Sign In',
//           builder: (context, state) => SignInScreen()),
//       GoRoute(
//         path: AppRoutes.creatNoteScreen,
//         name: 'creatNote',
//         builder: (context, state) => CreatNoteScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.profileScreen,
//         name: 'profile',
//         builder: (context, state) => ProfileScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.noteDetailScreen,
//         name: 'noteDetail',
//         builder: (context, state) => NoteDetailScreen(),
//       )
//     ],
//     errorBuilder: (context, state) => ErrorPage(),
//   );
// }

// GoRoute(
//   path: AppRoutes.profile,
//   name: 'Profile',
//   builder: (context, state) {
//     final id = state.params['id']; // Extract dynamic parameter
//     return ProfilePage(id: id!);
//   },
// ),

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
