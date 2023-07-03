import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapsnap/components/register_appbar.dart';

class RegisterProfilePhotoScreen extends StatefulWidget {
  const RegisterProfilePhotoScreen({super.key});

  @override
  State<RegisterProfilePhotoScreen> createState() =>
      _RegisterProfilePhotoScreenState();
}

class _RegisterProfilePhotoScreenState
    extends State<RegisterProfilePhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const RegisterAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Add a profile picture",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Circle with a cupertino icon in the middle of a camera in the center of the screen
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      CupertinoIcons.camera,
                      size: 75,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 25, right: 25),
                  child: Text(
                    "Add a profile photo so your friends know it's you",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                //Button to upload a photo with width of 150
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
                  child: TextButton(
                    onPressed: () {
                      // Open gallery
                    },
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                      backgroundColor: const Color(0xFF381E72),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Upload Photo",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterProfilePhotoScreen()));
                          // if (_formKey.currentState!.validate()) {
                          //   Map data = {
                          //     "email": _emailController.text,
                          //   };
                          //   Provider.of<Register>(context, listen: false)
                          //       .verifyEmail(data, context);
                          // }
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
                          "Skip",
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
                          backgroundColor:
                              Theme.of(context).dividerColor.withOpacity(0.2),
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
    );
  }
}
