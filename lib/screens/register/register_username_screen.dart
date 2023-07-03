import 'package:flutter/material.dart';
import 'package:snapsnap/components/register_appbar.dart';

class RegisterUsernameScreen extends StatefulWidget {
  const RegisterUsernameScreen({super.key});

  @override
  State<RegisterUsernameScreen> createState() => _RegisterUsernameScreenState();
}

class _RegisterUsernameScreenState extends State<RegisterUsernameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterAppBar(),
    );
  }
}
