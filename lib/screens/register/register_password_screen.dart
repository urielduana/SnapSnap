import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapsnap/components/register_appbar.dart';
import 'package:snapsnap/services/reg.dart';

class RegisterPasswordScreen extends StatefulWidget {
  const RegisterPasswordScreen({super.key});

  @override
  State<RegisterPasswordScreen> createState() => _RegisterPasswordScreenState();
}

class _RegisterPasswordScreenState extends State<RegisterPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _passwordController.text = "password";
    _confirmPasswordController.text = "password";
  }

  @override
  Widget build(BuildContext context) {
    final register = context.watch<Register>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const RegisterAppBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "Create a secure password",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "Your password must be at least 8 characters long",
                              style: TextStyle(
                                fontSize: 15,
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
                                  controller: _confirmPasswordController,
                                  validator: (value) => value!.isEmpty
                                      ? 'Enter your password'
                                      : null,
                                  decoration: const InputDecoration(
                                    hintText: "Confirm Password",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Visibility(
                                  visible: register.passwordStatus,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10, top: 10),
                                    child: Text(
                                      "Password does not match, please try again",
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  )),
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
                                    if (_formKey.currentState!.validate()) {
                                      Map data = {
                                        "password": _passwordController.text,
                                        "confirmPassword":
                                            _confirmPasswordController.text,
                                      };
                                      Provider.of<Register>(context,
                                              listen: false)
                                          .verifyPassword(data, context);
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
                                    "Next",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
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
                                  child: const Text("Back"),
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
      ),
    );
  }
}
