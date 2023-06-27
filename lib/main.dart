import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:snapsnap/components/sidebar_menu.dart';
import 'package:snapsnap/screens/login_screen.dart';
import 'package:snapsnap/services/auth.dart';
import 'color_schemes.dart';
import 'package:snapsnap/screens/home_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Auth()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      title: 'SnapSnap',
      home: const AuthenticationWrapper(),
      routes: {
        'login': (_) => const LoginScreen(),
        'home': (_) => const MyHomeScreen(),
      },
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  final storage = new FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    readToken();
  }

  void readToken() async {
    String? token = await storage.read(key: 'token');
    Provider.of<Auth>(context, listen: false).tryToken(token: token);
    // print(token);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    if (!auth.authenticated) {
      return Navigator(
        pages: const [
          MaterialPage(
            child: LoginScreen(),
          ),
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    } else {
      return Navigator(
        pages: const [
          MaterialPage(key: ValueKey('HomeScreen'), child: SideBar()),
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    }
  }
}
