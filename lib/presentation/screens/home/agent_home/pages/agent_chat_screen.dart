import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_application/presentation/screens/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class AgentChatScreen extends StatelessWidget {
  const AgentChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('users').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return  const Center(
                      child: Image(
                        image: AssetImage(
                            'assets/users_loader.gif'
                        ),
                        height: 200,
                        width: 200,
                      )
                  );
                }

                final allUsers = snapshot.data!.docs;
                final admins = allUsers
                    .where((doc) => doc['role'] == 'admin')
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();

                final myCustomers = allUsers
                    .where((doc) =>
                doc['role'] == 'customer' &&
                    doc['agentUid'] == currentUserId)
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (admins.isNotEmpty) ...[
                      _buildSectionHeader('Admins'),
                      ...admins.map((user) =>
                          _buildUserTile(context, user, currentUserId)),
                      const SizedBox(height: 20),
                    ],
                    if (myCustomers.isNotEmpty) ...[
                      _buildSectionHeader('My Customers'),
                      ...myCustomers.map((user) =>
                          _buildUserTile(context, user, currentUserId)),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3F51B5), Color(0xFF7986CB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Text(
            'Chat List',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8, top: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
    );
  }

  Widget _buildUserTile(
      BuildContext context, Map<String, dynamic> user, String currentUserId) {
    final uid = user['uid'];
    final name = user['name'] ?? '';
    final email = user['email'] ?? '';
    final phone = user['phone'] ?? '';

    final stripColor = Colors.indigo;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 80,
            decoration: BoxDecoration(
              color: stripColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.indigo.shade100,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: GoogleFonts.poppins(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Iconify(Tabler.message_dots,
                            color: Colors.indigo.shade200),
                        onPressed: () {
                          FirebaseAuth _auth = FirebaseAuth.instance;
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            withNavBar: false,
                            screen: ChatScreen(
                              currentUserId: _auth.currentUser!.uid,
                              peerId: uid,
                              peerName: name,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Text(
                    email,
                    style: GoogleFonts.poppins(color: Colors.grey.shade700),
                  ),
                  Text(
                    phone,
                    style: GoogleFonts.poppins(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
