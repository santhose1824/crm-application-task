import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_application/presentation/screens/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class AgentCustomerScreen extends StatefulWidget {
  const AgentCustomerScreen({super.key});

  @override
  State<AgentCustomerScreen> createState() => _AgentCustomerScreenState();
}

class _AgentCustomerScreenState extends State<AgentCustomerScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(),
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.indigo,
              labelColor: Colors.indigo,
              unselectedLabelColor: Colors.grey,
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Customers'),
                Tab(text: 'Call Logs'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCustomerTab(),
                _buildCallLogsTab(),
              ],
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
            'My Customers',
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

  Widget _buildCustomerTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'customer')
          .where('agentUid', isEqualTo: currentUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final customers = snapshot.data!.docs;

        if (customers.isEmpty) {
          return  const Center(
              child: Image(
                image: AssetImage(
                    'assets/users_loader.gif'
                ),
                height: 200,
                width: 200,
              )
          );;
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: customers.length,
          itemBuilder: (context, index) {
            final data = customers[index].data() as Map<String, dynamic>;
            final uid = data['uid'];
            final name = data['name'] ?? '';
            final email = data['email'] ?? '';
            final phone = data['phone'] ?? '';

            final stripColors = [Colors.indigo, Colors.deepPurple, Colors.green];
            final stripColor = stripColors[index % stripColors.length];

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
                                icon: Iconify(Ic.outline_phone_android,
                                    color: Colors.indigo.shade200),
                                onPressed: () {
                                  // Future feature: Call via Agora
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      shape: BeveledRectangleBorder(),
                                      backgroundColor: Colors.indigo.shade300,
                                      content: Text(
                                        'There is no call functionality for the customer because they are mocked Data in firebase',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: Colors.white
                                        ),
                                      ),
                                    )
                                  );
                                },
                              ),
                              IconButton(
                                icon: Iconify(Tabler.message_dots,
                                    color: Colors.indigo.shade200),
                                onPressed: () {
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    withNavBar: false,
                                    screen: ChatScreen(
                                      currentUserId: currentUserId,
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
          },
        );
      },
    );
  }

  Widget _buildCallLogsTab() {
    return Center(
      child: Text(
        'Call Logs (Coming Soon)',
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700),
      ),
    );
  }
}
