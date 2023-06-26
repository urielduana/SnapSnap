import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapsnap/screens/register_screen.dart';

import '../services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController.text = "mohr.tania@example.net";
    _passwordController.text = "password";
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Hello, \nWelcome Back",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 50),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: TextFormField(
                          controller: _emailController,
                          // validator: (value) =>
                          //     value!.isEmpty ? 'Enter your email' : null,
                          decoration: const InputDecoration(
                              hintText: "Email", border: InputBorder.none),
                        )),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: TextFormField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: _passwordController,
                          // validator: (value) =>
                          //     value!.isEmpty ? 'Enter your password' : null,
                          decoration: const InputDecoration(
                              hintText: "Password", border: InputBorder.none),
                        )),
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        "Forgot Password?",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            Map credentials = {
                              "email": _emailController.text,
                              "password": _passwordController.text,
                              "device_name": "mobile"
                            };
                            if (_formKey.currentState!.validate()) {
                              Provider.of<Auth>(context, listen: false)
                                  .login(credentials);
                            }
                          },
                          style: TextButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: const Color(0xFF381E72),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                          child: const Text("Login",
                              style: TextStyle(color: Colors.white))),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const RegisterScreen()));
                          },
                          style: TextButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                          child: const Text("Create account")),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
