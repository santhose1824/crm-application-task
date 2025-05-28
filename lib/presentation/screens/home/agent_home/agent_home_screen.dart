import 'package:crm_application/presentation/screens/home/agent_home/pages/agent_chat_screen.dart';
import 'package:crm_application/presentation/screens/home/agent_home/pages/agent_customer_screen.dart';
import 'package:crm_application/presentation/screens/home/agent_home/pages/agent_dashboard_screen.dart';
import 'package:crm_application/presentation/screens/home/agent_home/pages/agent_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ic.dart';


class AgentHomeScreen extends StatefulWidget {
  const AgentHomeScreen({super.key});

  @override
  State<AgentHomeScreen> createState() => _AgentHomeScreenState();
}

class _AgentHomeScreenState extends State<AgentHomeScreen> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return const [
      AgentDashboardScreen(),
      AgentChatScreen(),
      AgentCustomerScreen(),
      AgentSettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Iconify(MaterialSymbols.dashboard, color: Colors.white),
        inactiveIcon: const Iconify(MaterialSymbols.dashboard, color: Colors.white70),
        title: "Dashboard",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
        textStyle: GoogleFonts.poppins(),
      ),
      PersistentBottomNavBarItem(
        icon: const Iconify(Mdi.chat, color: Colors.white),
        inactiveIcon: const Iconify(Mdi.chat, color: Colors.white70),
        title: "Chats",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
        textStyle: GoogleFonts.poppins(),
      ),
      PersistentBottomNavBarItem(
        icon: const Iconify(Ic.baseline_people, color: Colors.white),
        inactiveIcon: const Iconify(Ic.baseline_people, color: Colors.white70),
        title: "Customers",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
        textStyle: GoogleFonts.poppins(),
      ),
      PersistentBottomNavBarItem(
        icon: const Iconify(MaterialSymbols.settings, color: Colors.white),
        inactiveIcon: const Iconify(MaterialSymbols.settings, color: Colors.white70),
        title: "Settings",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
        textStyle: GoogleFonts.poppins(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      backgroundColor: Colors.indigo,
      navBarStyle: NavBarStyle.style13,
      handleAndroidBackButtonPress: true,
      confineToSafeArea: true,
      stateManagement: true,
      resizeToAvoidBottomInset: true,
      navBarHeight: 65,
      decoration: NavBarDecoration(
        colorBehindNavBar: Colors.indigo,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
    );
  }
}
