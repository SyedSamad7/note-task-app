class NoteModel {
  final String id;
  final String userId;
  final String title;
  final String noteContent;
  final String userEmail;
  final String userName;
  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.noteContent,
    required this.userEmail,
    required this.userName,
    required this.createdAt,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as String? ?? 'Unknown ID',
      userId: map['userId'] as String? ?? 'unkown id',
      title: map['title'] as String? ?? 'Untitled Note',
      noteContent: map['noteContent'] as String? ?? "noContent",
      userEmail: map['userEmail'] as String? ?? 'Unknown Email',
      userName: map['userName'] as String? ?? 'Unknown User',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'noteContent': noteContent,
      'userEmail': userEmail,
      'userName': userName,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
