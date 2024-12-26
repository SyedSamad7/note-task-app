import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_task_app/extensions/input_validator_extensions.dart';
import 'package:notes_task_app/mvvm/models/note_model.dart';
import '../components/input_text_field.dart';
import '../components/primary_button.dart';
import '../constants/colors.dart';
import '../mvvm/view models/note_view_model.dart';
import '../mvvm/view models/profile_view_model.dart';

class CreateNoteScreen extends ConsumerWidget {
  CreateNoteScreen({super.key});

  final _createNoteKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userViewModelProvider);
    final noteViewModel = ref.read(noteViewModelProvider.notifier);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Note'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _createNoteKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InputTextField(
                    controller: _titleController,
                    hintText: 'Note Title',
                    validator: (value) =>
                        InputValidator.validateInputField(value),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 200,
                    child: InputTextField(
                      controller: _contentController,
                      hintText: 'Note Content',
                      maxLines: null,
                      validator: (value) =>
                          InputValidator.validateInputField(value),
                    ),
                  ),
                  const SizedBox(height: 40),
                  userState.when(
                    data: (user) {
                      if (user == null) {
                        return const Text(
                          'Failed to fetch user data. Please try again later.',
                          style: TextStyle(color: Colors.red),
                        );
                      }
                      return PrimaryButton(
                        label: 'Save Note',
                        backGroundColor: yellowColor,
                        onTap: () async {
                          if (_createNoteKey.currentState!.validate()) {
                            final note = NoteModel(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              userId: currentUserId ?? "",
                              title: _titleController.text,
                              noteContent: _contentController.text,
                              userEmail: user.email,
                              userName: user.userName,
                              createdAt: DateTime.now(),
                            );
                            await noteViewModel.addNote(context, note);
                          }
                        },
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stackTrace) => Column(
                      children: [
                        const Text(
                          'Failed to create note.',
                          style: TextStyle(color: whiteColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
