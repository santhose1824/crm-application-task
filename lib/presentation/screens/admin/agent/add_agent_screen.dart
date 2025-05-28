import 'package:crm_application/data/model/agent_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../bloc/agent/agent_bloc.dart';
import '../../../../bloc/agent/agent_event.dart';

class AddAgentScreen extends StatefulWidget {
  const AddAgentScreen({super.key});

  @override
  State<AddAgentScreen> createState() => _AddAgentScreenState();
}

class _AddAgentScreenState extends State<AddAgentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(),
      prefixIcon: Icon(icon, color: Colors.indigo),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.indigo),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.indigo, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.white.withOpacity(0.7),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
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
                    'Add the New Agent',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20,),
                  // Name
                  TextFormField(
                    controller: _nameController,
                    cursorColor: Colors.indigo,
                    decoration: _inputDecoration('Name', Icons.person_outline),
                    validator: (val) => val!.isEmpty ? 'Enter name' : null,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.indigo,
                    decoration: _inputDecoration('Email', Icons.email_outlined),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Enter email';
                      if (!val.contains('@')) return 'Invalid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    cursorColor: Colors.indigo,
                    decoration: _inputDecoration('Phone', Icons.phone_outlined),
                    validator: (val) => val!.isEmpty ? 'Enter phone' : null,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    cursorColor: Colors.indigo,
                    decoration: _inputDecoration('Password', Icons.lock_outline),
                    validator: (val) => val!.length < 6 ? 'Min 6 characters' : null,
                  ),
                  const SizedBox(height: 24),

                  // Submit
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final agent = AgentModel(
                            uid: '',
                            name: _nameController.text.trim(),
                            email: _emailController.text.trim(),
                            phone: _phoneController.text.trim(),
                          );
                          context.read<AgentBloc>().add(
                            AddAgent(agent, _passwordController.text.trim()),
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Add Agent", style: TextStyle(color: Colors.white)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
