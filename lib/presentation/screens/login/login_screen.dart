import 'package:crm_application/bloc/auth/auth_bloc.dart';
import 'package:crm_application/bloc/auth/auth_event.dart';
import 'package:crm_application/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool obscurePassword = true;

  InputDecoration customInputDecoration(String label, Icon prefixIcon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.indigo, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (state.role == 'admin') {
            Navigator.pushReplacementNamed(context, '/admin_home');
          } else if (state.role == 'agent') {
            Navigator.pushReplacementNamed(context, '/agent_home');
          }
        } else if (state is AuthFailure) {
          print(state.error);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Image.asset(
                          'assets/login.png',
                          height: size.height * 0.3,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Sign In To TaskZen',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.indigo,
                          decoration: customInputDecoration(
                            "Email Address",
                            const Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: obscurePassword,
                          cursorColor: Colors.indigo,
                          decoration: customInputDecoration(
                            "Password",
                            const Icon(Icons.lock_outline),
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final email = _emailController.text.trim();
                                final password =
                                _passwordController.text.trim();
                                context.read<AuthBloc>().add(
                                  LoginRequested(
                                    email: email,
                                    password: password,
                                  ),
                                );
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Sign In",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward,
                                    color: Colors.white),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don’t have an account? ",
                                style: GoogleFonts.poppins()),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Forgot Password",
                            style: GoogleFonts.poppins(
                              color: Colors.indigo,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Loader Overlay
            if (state is AuthLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: Image.asset('assets/login_loader.gif'),
                  ),
                ),
              ),

          ],
        );
      },
    );
  }
}
