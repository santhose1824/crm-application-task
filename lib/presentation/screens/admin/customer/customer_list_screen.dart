import 'package:crm_application/presentation/screens/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:iconify_flutter/icons/icomoon_free.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../../../../bloc/customer/customer_bloc.dart';
import '../../../../bloc/customer/customer_event.dart';
import '../../../../bloc/customer/customer_state.dart';
import 'add_edit_customer_screen.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // 🟣 Indigo Header
          Stack(
            children: [
              Container(
                height: 140,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3F51B5), Color(0xFF7986CB)],
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
                      'Customer List',
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

          // 🟣 Customer List
          Expanded(
            child: BlocBuilder<CustomerBloc, CustomerState>(
              builder: (context, state) {
                if (state is CustomerLoading) {
                  return Center(
                    child: Image(
                      image: AssetImage(
                        'assets/users_loader.gif',
                      ),
                      height: 200,
                      width: 200,
                    ),
                  );
                } else if (state is CustomerLoaded) {
                  final customers = [...state.customers]
                    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: customers.length,
                    itemBuilder: (_, index) {
                      final customer = customers[index];
                      final List<Color> stripColors = [
                        Colors.indigo,
                        Colors.indigoAccent,
                        Colors.deepPurple,
                      ];
                      final stripColor = stripColors[index % stripColors.length];

                      return Dismissible(
                        key: Key(customer.uid),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Iconify(MaterialSymbols.delete_outline, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Confirm Delete", style: GoogleFonts.poppins()),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              content: Text("Delete ${customer.name}?", style: GoogleFonts.poppins()),
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
                          context.read<CustomerBloc>().add(DeleteCustomer(customer.uid));
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
                                radius: 30,
                                backgroundColor: Colors.indigo.shade100,
                                child: Text(
                                  customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                                  style: GoogleFonts.poppins(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              customer.name,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Iconify(Ic.outline_phone_android,color: Colors.indigo.shade200,) ,
                                            onPressed: () {
                                              // Future feature: launch dialer
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
                                            icon:  Iconify(Tabler.message_dots,color: Colors.indigo.shade200,),
                                            onPressed: () {
                                              FirebaseAuth _auth = FirebaseAuth.instance;
                                              PersistentNavBarNavigator.pushNewScreen(
                                                context,
                                                screen: ChatScreen(
                                                  currentUserId: _auth.currentUser!.uid,
                                                  peerId: customer.uid,
                                                  peerName: customer.name,
                                                ),
                                                withNavBar: false,
                                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Iconify(IcomoonFree.profile,color: Colors.indigo.shade200,) ,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => AddEditCustomerScreen(
                                                    isEdit: true,
                                                    customer: customer,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(customer.email, style: GoogleFonts.poppins(color: Colors.grey.shade700)),
                                      const SizedBox(height: 4),
                                      Text(customer.phone, style: GoogleFonts.poppins(color: Colors.grey.shade700)),
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
                } else if (state is CustomerError) {
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
        child: const Icon(Icons.person_add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditCustomerScreen(isEdit: false),
            ),
          );
        },
      ),
    );
  }
}
