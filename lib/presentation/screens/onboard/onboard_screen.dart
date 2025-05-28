import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20),

              // Top Icon
              Image.asset(
                'assets/logo.png',
                height: size.height * 0.06,
              ),

              // Title
              Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome to the ultimate ',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                         TextSpan(
                          text: 'TaskZen',
                          style: GoogleFonts.poppins(
                            color: Colors.deepPurple,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your intelligent CRM analytics companion\nfor everyone, anywhere.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[700],
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),

              // Illustration
              Image.asset(
                'assets/onboard.png',
                height: size.height * 0.35,
              ),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.indigo,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Get Started", style: GoogleFonts.poppins(fontSize: 16,color: Colors.white)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),

              // Sign in Link
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: RichText(
                    text:  TextSpan(
                      text: "Already have an account? ",
                      style: GoogleFonts.poppins(color: Colors.black87),
                      children: [
                        TextSpan(
                          text: "Sign in.",
                          style: GoogleFonts.poppins(
                            color: Colors.indigo,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
