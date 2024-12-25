import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note_model.dart';

class NoteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNote(NoteModel note) async {
    await _firestore.collection('notes').doc(note.id).set(note.toMap());
  }

  Future<List<NoteModel>> fetchAllNotes() async {
    final querySnapshot = await _firestore.collection('notes').get();
    return querySnapshot.docs
        .map((doc) => NoteModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> deleteNoteById(String id) async {
    await _firestore.collection('notes').doc(id).delete();
  }
}
