import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/agent_model.dart';


class AgentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addAgent(AgentModel agent, String password) async {
    final currentUser = _auth.currentUser;

    // Save admin credentials
    final adminEmail = currentUser?.email;
    final adminPassword = 'Password123'; // 🔒 Securely store this or use credential manager

    // Create agent (logs in as agent)
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: agent.email,
      password: password,
    );
    final uid = userCredential.user!.uid;

    // Save agent data to Firestore
    await _firestore.collection('users').doc(uid).set(
      agent.copyWith(uid: uid).toMap(),
    );

    // 🔁 Sign back in as admin
    if (adminEmail != null) {
      await _auth.signInWithEmailAndPassword(email: adminEmail, password: adminPassword);
    }
  }

  Future<List<AgentModel>> getAgents() async {
    final query = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'agent')
        .get();

    return query.docs.map((doc) => AgentModel.fromMap(doc.data())).toList();
  }

  Future<void> deleteAgent(String uid) async {
    await _auth.currentUser!.delete();
    await _firestore.collection('users').doc(uid).delete();
  }
}