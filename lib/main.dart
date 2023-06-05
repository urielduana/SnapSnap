import 'package:flutter/material.dart';
import 'color_schemes.dart';

import 'package:snapsnap/screens/home_screen.dart';
import 'package:snapsnap/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      title: 'MyApp',
      home: const LoginScreen(),
    );
  }
}
