import 'package:flutter/material.dart';
import 'package:notes_task_app/mvvm/models/note_model.dart';

import '../constants/colors.dart';

class NoteDetailScreen extends StatelessWidget {
  final NoteModel note;
  const NoteDetailScreen({super.key, required this.note});

  Widget _buildUserInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          child: const Icon(Icons.account_circle_outlined),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.userName,
              style: _textStyle(
                  color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              note.userEmail,
              style: _textStyle(
                  color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNoteDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          note.title,
          style: _textStyle(
              color: yellowColor, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          note.noteContent,
          style: _textStyle(
              color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  TextStyle _textStyle(
      {required Color color,
      required double fontSize,
      FontWeight? fontWeight}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(),
            const SizedBox(height: 24),
            _buildNoteDetails(),
          ],
        ),
      ),
    );
  }
}
