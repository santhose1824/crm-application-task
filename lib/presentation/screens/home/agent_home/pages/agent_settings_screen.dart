import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_application/bloc/auth/auth_bloc.dart';
import 'package:crm_application/bloc/auth/auth_event.dart';
import 'package:crm_application/bloc/auth/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

class AgentSettingsScreen extends StatefulWidget {
  const AgentSettingsScreen({super.key});

  @override
  State<AgentSettingsScreen> createState() => _AgentSettingsScreenState();
}

class _AgentSettingsScreenState extends State<AgentSettingsScreen> {
  String? _name;
  String? _email;
  String _initials = 'A';

  @override
  void initState() {
    super.initState();
    _loadAgentData();
  }

  Future<void> _loadAgentData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        final name = data['name'] ?? 'Agent';
        final email = data['email'] ?? user.email ?? 'agent@crm.com';

        setState(() {
          _name = name;
          _email = email;
          _initials = name.isNotEmpty ? name[0].toUpperCase() : 'A';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.of(context, rootNavigator: true)
              .pushNamedAndRemoveUntil('/onboarding', (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("Settings", style: GoogleFonts.poppins(color: Colors.white)),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 👤 User Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.indigo.shade100,
                    child: Text(
                      _initials,
                      style: GoogleFonts.poppins(color: Colors.indigo, fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_name ?? "Loading...",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                        Text(_email ?? "Loading...",
                            style: GoogleFonts.poppins(color: Colors.grey.shade700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ⚙️ Settings Options
            _buildSettingsTile(
              icon: MaterialSymbols.person_outline,
              title: "Profile",
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: MaterialSymbols.notifications_active_rounded,
              title: "Notifications",
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: MaterialSymbols.lock_outline,
              title: "Change Password",
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: MaterialSymbols.help_outline,
              title: "Help & Support",
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: MaterialSymbols.logout,
              title: "Logout",
              isDestructive: true,
              onTap: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Iconify(icon, color: isDestructive ? Colors.redAccent : Colors.indigo, size: 24),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.redAccent : Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }
}
