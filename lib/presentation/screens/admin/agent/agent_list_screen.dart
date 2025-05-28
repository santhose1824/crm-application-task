import 'dart:convert';

import 'package:crm_application/app_constants.dart';
import 'package:crm_application/presentation/screens/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import '../../../../bloc/agent/agent_bloc.dart';
import '../../../../bloc/agent/agent_event.dart';
import '../../../../bloc/agent/agent_state.dart';
import 'add_agent_screen.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

class AgentListScreen extends StatefulWidget {
  const AgentListScreen({super.key});

  @override
  State<AgentListScreen> createState() => _AgentListScreenState();
}

class _AgentListScreenState extends State<AgentListScreen> {
  late final User me;
  @override
  void initState() {
    super.initState();
    me = FirebaseAuth.instance.currentUser!;

    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: AppConstants.APP_ID,
      appSign: AppConstants.APP_SIGN,
      userID: me.uid,
      userName: me.email ?? 'User',
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }
  @override
  void dispose() {
    ZegoUIKitPrebuiltCallInvitationService().uninit();
    super.dispose();
  }
  void _inviteCall(String peerUid, String peerName) {
    ZegoUIKitPrebuiltCallInvitationService().send(
      invitees: [ZegoCallUser(peerUid, peerName)],
      isVideoCall: false,
      timeoutSeconds: 60,
      customData: jsonEncode({
        'audioConfig': {
          'enableSpeaker': true,
          'enableMicrophone': true,
        }
      }),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ✅ Custom Indigo Gradient AppBar
          Stack(
            children: [
              Container(
                height: 140,
                width: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF3F51B5), Color(0xFF7986CB)], // Indigo to light indigo
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Agent List',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          // ✅ Agent List
          Expanded(
            child: BlocBuilder<AgentBloc, AgentState>(
              builder: (context, state) {
                if (state is AgentLoading) {
                  return const Center(
                      child: Image(
                        image: AssetImage(
                            'assets/users_loader.gif'
                        ),
                        height: 200,
                        width: 200,
                      )
                  );
                } else if (state is AgentLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.agents.length,
                    itemBuilder: (_, index) {
                      final agents = [...state.agents]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                      final agent = agents[index];
                      final List<Color> stripColors = [
                        Colors.indigo,
                        Colors.indigoAccent,
                        Colors.deepPurple,
                      ];
                      final stripColor = stripColors[index % stripColors.length];

                      return Dismissible(
                        key: Key(agent.uid),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Iconify(MaterialSymbols.delete_outline,color: Colors.white,),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Confirm Delete", style: GoogleFonts.poppins(color: Colors.black)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              content: Text("Are you sure you want to delete ${agent.name}?",
                                  style: GoogleFonts.poppins(color: Colors.black)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.indigo)),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text("Delete", style: GoogleFonts.poppins(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (_) {
                          context.read<AgentBloc>().add(DeleteAgent(agent.uid));
                        },
                        child: Container(
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
                                  agent.name.isNotEmpty ? agent.name[0].toUpperCase() : '?',
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
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            agent.name,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Spacer(),
                                          IconButton(
                                            icon: Iconify(Ic.outline_phone_android,color: Colors.indigo.shade200,) ,
                                            onPressed: () {
                                              // Initiate call to this agent
                                              _inviteCall(agent.uid, agent.name);
                                            },
                                          ),
                                          IconButton(
                                            icon:  Iconify(Tabler.message_dots,color: Colors.indigo.shade200,),
                                            onPressed: () {
                                              FirebaseAuth _auth = FirebaseAuth.instance;
                                              PersistentNavBarNavigator.pushNewScreen(
                                                context,
                                                screen: ChatScreen(
                                                  currentUserId: _auth.currentUser!.uid,
                                                  peerId: agent.uid,
                                                  peerName: agent.name,
                                                ),
                                                withNavBar: false,
                                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        agent.email,
                                        style: GoogleFonts.poppins(color: Colors.grey.shade700),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        agent.phone,
                                        style: GoogleFonts.poppins(color: Colors.grey.shade700),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is AgentError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        child: Icon(
          Icons.person_add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddAgentScreen()),
          );
        },
      ),
    );
  }
}