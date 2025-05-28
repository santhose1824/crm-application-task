import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // Sign in user
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user?.uid;
    if (uid == null) throw Exception('Invalid user ID.');

    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (!userDoc.exists) throw Exception('User profile not found.');

    final role = userDoc['role'] as String?;
    if (role == null) throw Exception('User role not found.');

    return {
      'uid': uid,
      'role': role,
    };
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
