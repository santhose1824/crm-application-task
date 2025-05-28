import 'package:crm_application/bloc/auth/auth_bloc.dart';
import 'package:crm_application/bloc/customer/customer_bloc.dart';
import 'package:crm_application/bloc/customer/customer_event.dart';
import 'package:crm_application/data/repository/customer_repository.dart';
import 'package:crm_application/firebase_options.dart';
import 'package:crm_application/presentation/screens/admin/agent/agent_list_screen.dart';
import 'package:crm_application/presentation/screens/admin/customer/customer_list_screen.dart';
import 'package:crm_application/presentation/screens/home/admin_home/admin_home_screen.dart';
import 'package:crm_application/presentation/screens/home/agent_home/agent_home_screen.dart';
import 'package:crm_application/presentation/screens/login/login_screen.dart';
import 'package:crm_application/presentation/screens/onboard/onboard_screen.dart';
import 'package:crm_application/presentation/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'bloc/agent/agent_bloc.dart';
import 'bloc/agent/agent_event.dart';
import 'bloc/chat/chat_bloc.dart';
import 'data/repository/agent_repository.dart';
import 'data/repository/auth_repository.dart';
import 'data/repository/chat_repository.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔧 Firebase Initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  ZegoUIKitPrebuiltCallInvitationService()
      .useSystemCallingUI([ZegoUIKitSignalingPlugin()]);
  runApp(MyApp(navigatorKey: navigatorKey));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepository: AuthRepository()),
        ),
        BlocProvider<AgentBloc>(
          create: (_) => AgentBloc(repository: AgentRepository())..add(LoadAgents()),
        ),
        BlocProvider<CustomerBloc>(
          create: (_) => CustomerBloc(repository: CustomerRepository())..add(LoadCustomers()),
        ),
        BlocProvider<ChatBloc>(
          create: (_) => ChatBloc(chatRepository: ChatRepository()),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'TaskZen CRM',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.indigo,
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/admin_home': (context) => const AdminHomeScreen(),
          '/agent_home': (context) => const AgentHomeScreen(),
          '/add_agent': (context) => const AgentListScreen(),
          '/add_customer': (context) => const CustomerListScreen(),
        },
      ),
    );
  }
}
