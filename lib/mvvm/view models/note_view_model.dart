import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_task_app/mvvm/repositories/note_repo.dart';
import 'package:notes_task_app/router/app_routes.dart';
import '../models/note_model.dart';

class NoteViewModel extends StateNotifier<AsyncValue<List<NoteModel>>> {
  final NoteRepository _noteRepository;

  NoteViewModel(this._noteRepository) : super(const AsyncValue.loading()) {
    fetchAllNotes();
  }

  Future<void> fetchAllNotes() async {
    try {
      state = const AsyncValue.loading(); // Set loading state
      final notes = await _noteRepository.fetchAllNotes();
      state = AsyncValue.data(notes); // Set data state
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Set error state
    }
  }

  Future<void> addNote(BuildContext context, NoteModel note) async {
    try {
      final currentNotes = state.asData?.value ?? [];
      state = const AsyncValue.loading(); // Set loading state
      await _noteRepository.addNote(note);
      state = AsyncValue.data([note, ...currentNotes]); // Add new note
      context.go(AppRoutes.homeScreen);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Set error state
    }
  }

  Future<void> deleteNoteById(String id) async {
    try {
      final currentNotes = state.asData?.value ?? [];
      state = const AsyncValue.loading(); // Set loading state
      await _noteRepository.deleteNoteById(id);
      state =
          AsyncValue.data(currentNotes.where((note) => note.id != id).toList());
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Set error state
    }
  }
}

// Riverpod provider for NoteViewModel
final noteViewModelProvider =
    StateNotifierProvider<NoteViewModel, AsyncValue<List<NoteModel>>>((ref) {
  return NoteViewModel(NoteRepository());
});
