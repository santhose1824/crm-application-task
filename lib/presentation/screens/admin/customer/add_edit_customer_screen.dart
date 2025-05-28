import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../bloc/customer/customer_bloc.dart';
import '../../../../bloc/customer/customer_event.dart';
import '../../../../data/model/customer_model.dart';
import '../../../../data/model/agent_model.dart';

class AddEditCustomerScreen extends StatefulWidget {
  final bool isEdit;
  final CustomerModel? customer;

  const AddEditCustomerScreen({
    super.key,
    required this.isEdit,
    this.customer,
  });

  @override
  State<AddEditCustomerScreen> createState() => _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  String? _selectedAgentId;
  List<AgentModel> _agents = [];

  @override
  void initState() {
    super.initState();
    _loadAgents();

    if (widget.isEdit && widget.customer != null) {
      _name.text = widget.customer!.name;
      _email.text = widget.customer!.email;
      _phone.text = widget.customer!.phone;
      _selectedAgentId = widget.customer!.agentUid;
    }
  }

  Future<void> _loadAgents() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'agent')
        .get();

    setState(() {
      _agents = snapshot.docs.map((doc) => AgentModel.fromMap(doc.data())).toList();
    });
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.indigo),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.indigo),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white.withOpacity(0.7),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  'assets/add_image.gif', // optional
                  height: size.height * 0.25,
                  width: size.width*2,
                ),
                const SizedBox(height: 20),
                Text(
                  'Add the New Customer',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _name,
                  decoration: _inputStyle('Name', Icons.person_outline),
                  validator: (val) => val!.isEmpty ? 'Enter name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _email,
                  decoration: _inputStyle('Email', Icons.email_outlined),
                  validator: (val) => val!.isEmpty ? 'Enter email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phone,
                  decoration: _inputStyle('Phone', Icons.phone_outlined),
                  validator: (val) => val!.isEmpty ? 'Enter phone' : null,
                ),
                const SizedBox(height: 16),
      
                // 🔽 Agent Dropdown
              DropdownButtonFormField<String>(
                value: _selectedAgentId,
                items: _agents.map((agent) {
                  return DropdownMenuItem<String>(
                    value: agent.uid,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
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
                          const SizedBox(width: 12),
                          Text(
                            agent.name,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                selectedItemBuilder: (context) {
                  return _agents.map((agent) {
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.indigo.shade100,
                          child: Text(
                            agent.name.isNotEmpty ? agent.name[0].toUpperCase() : '?',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          agent.name,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
                decoration: InputDecoration(
                  labelText: 'Assign to Agent',
                  prefixIcon: const Icon(Icons.person_search, color: Colors.indigo),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.indigo, width: 1.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                dropdownColor: Colors.white,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.indigo),
                onChanged: (value) {
                  setState(() {
                    _selectedAgentId = value;
                  });
                },
                validator: (val) => val == null ? 'Please select an agent' : null,
              ),
              const SizedBox(height: 24),
      
                // ✅ Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final customer = CustomerModel(
                          uid: widget.isEdit ? widget.customer!.uid : '',
                          name: _name.text.trim(),
                          email: _email.text.trim(),
                          phone: _phone.text.trim(),
                          agentUid: _selectedAgentId!,
                        );
      
                        final bloc = context.read<CustomerBloc>();
                        if (widget.isEdit) {
                          bloc.add(UpdateCustomer(customer));
                        } else {
                          bloc.add(AddCustomer(customer));
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      widget.isEdit ? 'Update Customer' : 'Add Customer',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
