import 'package:flutter/material.dart';
import 'package:snapsnap/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentIndex = 0;

  void navigateToNextScreen() {
    print("Next");
    if (_currentIndex < _screens.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void navigateToPreviousScreen() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  late List<Widget> _screens;
  @override
  void initState() {
    super.initState();
    _screens = [
      RegisterEmailScreen(
        onNext: navigateToNextScreen,
        onPrevious: navigateToPreviousScreen,
      ),
      UserNameRegisterScreen(
        onNext: navigateToNextScreen,
        onPrevious: navigateToPreviousScreen,
      ),
      PasswordRegisterScreen(
        onNext: navigateToNextScreen,
        onPrevious: navigateToPreviousScreen,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
    );
  }
}

class RegisterEmailScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const RegisterEmailScreen({
    Key? key,
    required this.onPrevious,
    required this.onNext,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                "Welcome to \nSnapSnap",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Verify your email to continue",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: const TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Email"),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              Center(
                child: Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          onNext();
                        },
                        style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: const Color(0xFF381E72),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                        child: const Text("Next",
                            style: TextStyle(color: Colors.white))),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                        child: const Text("Cancel")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserNameRegisterScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const UserNameRegisterScreen({
    Key? key,
    required this.onPrevious,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                "Choose your \nusername",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "You can always change it later",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: const TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Username"),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              Center(
                child: Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          onNext();
                        },
                        style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: const Color(0xFF381E72),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                        child: const Text("Next",
                            style: TextStyle(color: Colors.white))),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          onPrevious();
                        },
                        style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                        child: const Text("Cancel")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordRegisterScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const PasswordRegisterScreen({
    Key? key,
    required this.onPrevious,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                "Create a \npassword",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "For your security, your password must be 8 or more characters",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 30,
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: const TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Password"),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: const TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Confirm password"),
                    ),
                  ),
                ],
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: TextButton(
                          onPressed: () {
                            onNext();
                          },
                          style: TextButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: const Color(0xFF381E72),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                          child: const Text("Next",
                              style: TextStyle(color: Colors.white))),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: TextButton(
                          onPressed: () {
                            onPrevious();
                          },
                          style: TextButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                          child: const Text("Cancel")),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserData {
  String? email;
  String? username;
  String? password;
  String? name;
  String? phone;
  String? profileImage;

  UserData({
    this.email,
    this.username,
    this.password,
    this.name,
    this.phone,
    this.profileImage,
  });
}
