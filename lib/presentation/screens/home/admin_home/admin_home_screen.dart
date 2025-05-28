import 'package:crm_application/presentation/screens/admin/agent/agent_list_screen.dart';
import 'package:crm_application/presentation/screens/admin/customer/customer_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'pages/admin_dashboard_screen.dart';
import 'pages/admin_search_screen.dart';
import 'pages/admin_settings_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  late PersistentTabController _controller;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      const DashboardScreen(),
      const AgentListScreen(),
      const SearchScreen(),
      const CustomerListScreen(),
      const SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Iconify(MaterialSymbols.dashboard_rounded,color: Colors.white,),
        inactiveIcon: const Iconify(MaterialSymbols.dashboard_rounded,color: Colors.white70,),
        title: "Dashboard",
        textStyle: GoogleFonts.poppins(
          color: Colors.indigo,
          fontSize: 12,
        ),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        title: "Agents",
        textStyle: GoogleFonts.poppins(
          color: Colors.indigo,
          fontSize: 12,
        ),
        icon: const Iconify(Bi.person_workspace,color: Colors.white,),
        inactiveIcon: const Iconify(Bi.person_workspace,color: Colors.white70,),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        title: "Search",
        textStyle: GoogleFonts.poppins(
          color: Colors.indigo,
          fontSize: 12,
        ),
        icon: const Iconify(MaterialSymbols.search,color: Colors.white,),
        inactiveIcon: const Iconify(MaterialSymbols.search,color: Colors.white70,),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        title: "Customers",

        textStyle: GoogleFonts.poppins(
          color: Colors.indigo,
          fontSize: 12,
        ),
        icon: const Iconify(Bi.person_video2,color: Colors.white,) ,
        inactiveIcon: const Iconify(Bi.person_video2,color: Colors.white70,),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        title: "Settings",
        textStyle: GoogleFonts.poppins(
          color: Colors.indigo,
          fontSize: 12,
        ),
        icon: const Iconify(MaterialSymbols.settings_rounded,color: Colors.white,),
        inactiveIcon: const Iconify(MaterialSymbols.settings_rounded,color: Colors.white70,),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
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
      confineToSafeArea: true,
      backgroundColor: Colors.indigo, // Set Indigo background
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarHeight: 65,
      decoration: NavBarDecoration(
        colorBehindNavBar: Colors.indigo,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          )
        ],
      ),
      navBarStyle: NavBarStyle.style13
      , // Clean with text under icons
    );
  }
}
