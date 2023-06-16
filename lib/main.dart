import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapsnap/services/auth.dart';
import 'color_schemes.dart';

import 'package:snapsnap/screens/home_screen.dart';
// import 'package:snapsnap/screens/login_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Auth()),
    ],
    child: MyApp(),
  ));
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
      home: const MyHomeScreen(),
    );
  }
}
