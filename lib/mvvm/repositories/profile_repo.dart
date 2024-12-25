import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_task_app/mvvm/models/user_model.dart';

class ProfileRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<User?> authStateChanges() => _auth.authStateChanges();
  Future<UserModel?> fetchUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final snapshot = await _firestore.collection('users').doc(user.uid).get();
      if (!snapshot.exists) return null;

      return UserModel.fromMap(snapshot.data()!);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
