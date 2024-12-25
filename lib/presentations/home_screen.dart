import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_task_app/router/app_routes.dart';
import '../constants/colors.dart';
import '../mvvm/view models/note_view_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesState = ref.watch(noteViewModelProvider);
    final noteViewModel = ref.read(noteViewModelProvider.notifier);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: yellowColor,
        title: Text(
          'Notes App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: whiteColor,
          ),
        ),
        actions: [
          InkWell(
            onTap: () => context.push(AppRoutes.creatNoteScreen),
            child: SizedBox(
              width: 43,
              child: Icon(
                Icons.add,
                color: darkGreyColor,
                size: 36,
              ),
            ),
          ),
          InkWell(
            onTap: () => context.push(AppRoutes.profileScreen),
            child: SizedBox(
              width: 43,
              child: Icon(
                Icons.account_circle_rounded,
                color: darkGreyColor,
                size: 36,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: notesState.when(
            data: (notes) => notes.isEmpty
                ? const Center(
                    child: Text(
                    'No notes found',
                    style: TextStyle(color: whiteColor),
                  ))
                : ListView.separated(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return InkWell(
                        onTap: () => context.push(AppRoutes.noteDetailScreen,
                            extra: note),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note.title,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: whiteColor,
                                      ),
                                    ),
                                    Text(
                                      note.noteContent,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: lightGreyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: note.userId == currentUserId,
                                child: InkWell(
                                  onTap: () async {
                                    noteViewModel.deleteNoteById(note.id);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: whiteColor,
                                    size: 36,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Divider(
                        height: 1,
                        color: greyColor,
                      ),
                    ),
                  ),
            loading: () => Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    'Failed to load notes. ${error.toString()}',
                    style: TextStyle(color: whiteColor),
                  ),
                  TextButton(
                    onPressed: () => noteViewModel.fetchAllNotes(),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: whiteColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
