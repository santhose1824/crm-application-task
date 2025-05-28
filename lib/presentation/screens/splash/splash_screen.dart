import 'package:crm_application/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserSession();
  }


  Future<void> _checkUserSession() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = Preferences();
    final role = await prefs.getUserRole();

    if (role == 'admin') {
      Navigator.pushReplacementNamed(context, '/admin_home');
    } else if (role == 'agent') {
      Navigator.pushReplacementNamed(context, '/agent_home');
    } else {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Responsive logo size
                Image.asset(
                  'assets/logo.png',
                  height: size.height * 0.08, // 8% of screen height
                ),
                SizedBox(height: size.height * 0.03),
                Text(
                  "TaskZen",
                  style: GoogleFonts.poppins(
                    fontSize: size.width * 0.07, // Scales with screen width
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: size.height * 0.015),
                Text(
                  "Your Intelligent CRM\nAnalytics Solutions.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: size.width * 0.04,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
