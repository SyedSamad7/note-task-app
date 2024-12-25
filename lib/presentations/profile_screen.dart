import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_task_app/mvvm/view%20models/auth_view_model.dart';
import 'package:notes_task_app/mvvm/view%20models/profile_view_model.dart';
import '../constants/colors.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.watch(authViewModelProvider.notifier);
    final profileViewModel = ref.watch(userViewModelProvider);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              spacing: 12,
              children: [
                CircleAvatar(
                  maxRadius: 40,
                  backgroundColor: yellowColor,
                  child: Icon(
                    Icons.account_circle_outlined,
                    color: darkGreyColor,
                    size: 40,
                  ),
                ),
                profileViewModel.when(
                  data: (user) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.userName ?? "Unknow",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: whiteColor),
                      ),
                      Text(
                        user?.email ?? 'useremail@gmail.com',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 215, 216, 219)),
                      ),
                    ],
                  ),
                  loading: () => Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stackTrace) => Text('Fiald to fetch user'),
                ),
              ],
            ),
            const Spacer(),
            InkWell(
                onTap: () async {
                  await authViewModel.logoutUser(context: context);
                },
                child: CircleAvatar(
                  radius: 30,
                  child: Icon(
                    Icons.logout,
                    color: darkGreyColor,
                    size: 24,
                  ),
                )),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    ));
  }
}
