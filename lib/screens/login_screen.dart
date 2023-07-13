import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapsnap/screens/register/register_email_screen.dart';
import 'package:snapsnap/services/auth.dart';

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
    _emailController.text = "admin@admin.com";
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
    final auth = context.watch<Auth>();
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                "Hello, \nWelcome Back",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 25),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.4),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _emailController,
                                    validator: (value) => value!.isEmpty
                                        ? 'Enter your email'
                                        : null,
                                    decoration: const InputDecoration(
                                      hintText: "Email",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.4),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: TextFormField(
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    controller: _passwordController,
                                    validator: (value) => value!.isEmpty
                                        ? 'Enter your password'
                                        : null,
                                    decoration: const InputDecoration(
                                      hintText: "Password",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Visibility(
                                    visible: auth.authDenied,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, top: 10),
                                      child: Text(
                                        "Invalid email or password",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    )),
                                // Container(
                                //   margin: const EdgeInsets.only(
                                //       top: 20, bottom: 20),
                                //   child: Text(
                                //     "Forgot Password?",
                                //     style:
                                //         Theme.of(context).textTheme.bodyLarge,
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: TextButton(
                                    onPressed: () {
                                      Map credentials = {
                                        "email": _emailController.text,
                                        "password": _passwordController.text,
                                        "device_name": "mobile"
                                      };
                                      if (_formKey.currentState!.validate()) {
                                        Provider.of<Auth>(context,
                                                listen: false)
                                            .login(credentials);
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      minimumSize: const Size.fromHeight(50),
                                      backgroundColor: const Color(0xFF381E72),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 50,
                                        vertical: 20,
                                      ),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const RegisterEmailScreen()));
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .dividerColor
                                          .withOpacity(0.2),
                                      minimumSize: const Size.fromHeight(50),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 50,
                                        vertical: 20,
                                      ),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                    child: const Text("Sign Up"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
