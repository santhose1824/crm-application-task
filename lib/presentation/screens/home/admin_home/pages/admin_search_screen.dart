import 'package:crm_application/bloc/agent/agent_bloc.dart';
import 'package:crm_application/bloc/agent/agent_state.dart';
import 'package:crm_application/bloc/customer/customer_bloc.dart';
import 'package:crm_application/bloc/customer/customer_state.dart';
import 'package:crm_application/data/model/agent_model.dart';
import 'package:crm_application/data/model/customer_model.dart';
import 'package:crm_application/presentation/screens/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchRole = 'agent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // 🟣 Custom AppBar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3F51B5), Color(0xFF7986CB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Search',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name, email or phone',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilterChip(
                      label: const Text('Agents'),
                      selected: _searchRole == 'agent',
                      onSelected: (selected) {
                        setState(() => _searchRole = 'agent');
                      },
                      backgroundColor: Colors.white,
                      selectedColor: Colors.indigo.shade100,
                    ),
                    const SizedBox(width: 10),
                    FilterChip(
                      label: const Text('Customers'),
                      selected: _searchRole == 'customer',
                      onSelected: (selected) {
                        setState(() => _searchRole = 'customer');
                      },
                      backgroundColor: Colors.white,
                      selectedColor: Colors.indigo.shade100,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 🟣 Search Results
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _searchRole == 'agent'
                  ? BlocBuilder<AgentBloc, AgentState>(
                builder: (context, state) {
                  if (state is AgentLoaded) {
                    final query = _searchController.text.toLowerCase();
                    final results = state.agents.where((agent) =>
                    agent.name.toLowerCase().contains(query) ||
                        agent.email.toLowerCase().contains(query) ||
                        agent.phone.contains(query)).toList();

                    if (results.isEmpty) {
                      return const Center(child: Text('No agents found.'));
                    }

                    return _buildSearchResults(results);
                  }
                  return const Center(
                      child: Image(
                        image: AssetImage(
                            'assets/users_loader.gif'
                        ),
                        height: 200,
                        width: 200,
                      )
                  );
                },
              )
                  : BlocBuilder<CustomerBloc, CustomerState>(
                builder: (context, state) {
                  if (state is CustomerLoaded) {
                    final query = _searchController.text.toLowerCase();
                    final results = state.customers.where((customer) =>
                    customer.name.toLowerCase().contains(query) ||
                        customer.email.toLowerCase().contains(query) ||
                        customer.phone.contains(query)).toList();

                    if (results.isEmpty) {
                      return const Center(child: Text('No customers found.'));
                    }

                    return _buildSearchResults(results);
                  }
                  return const Center(
                      child: Image(
                        image: AssetImage(
                            'assets/users_loader.gif'
                        ),
                        height: 200,
                        width: 200,
                      )
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<dynamic> results) {
    final isAgent = _searchRole == 'agent';

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, index) {
        final item = results[index];
        final name = item.name;
        final email = item.email;
        final phone = item.phone;
        final uid = item.uid; // Works because both AgentModel and CustomerModel have .uid

        final List<Color> stripColors = [
          Colors.indigo,
          Colors.indigoAccent,
          Colors.deepPurple,
        ];
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
                            icon: Iconify(Ic.outline_phone_android, color: Colors.indigo.shade200),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Iconify(Tabler.message_dots, color: Colors.indigo.shade200),
                            onPressed: () {
                              final currentUserId = FirebaseAuth.instance.currentUser!.uid;

                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: ChatScreen(
                                  currentUserId: currentUserId,
                                  peerId: uid,
                                  peerName:name,
                                ),
                                withNavBar: false,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            },
                          ),
                        ],
                      ),
                      Text(email, style: GoogleFonts.poppins(color: Colors.grey.shade700)),
                      Text(phone, style: GoogleFonts.poppins(color: Colors.grey.shade700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
