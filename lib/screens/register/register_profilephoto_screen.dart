import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapsnap/components/register_appbar.dart';
import 'package:snapsnap/screens/bottom_navigation_bar_screen.dart';
import 'package:snapsnap/screens/gallery/gallery_selector.dart';
import 'package:snapsnap/screens/tags/tag_select.dart';
//import 'package:snapsnap/services/upImg.dart';
import 'package:snapsnap/services/reg.dart';

class RegisterProfilePhotoScreen extends StatefulWidget {
  const RegisterProfilePhotoScreen({Key? key}) : super(key: key);

  @override
  State<RegisterProfilePhotoScreen> createState() =>
      _RegisterProfilePhotoScreenState();
}

class _RegisterProfilePhotoScreenState
    extends State<RegisterProfilePhotoScreen> {
  File? _selectedImage;

  final Register upImgService = Register();

  void _uploadPhoto(BuildContext context) async {
    if (_selectedImage != null) {
      String fileName = _selectedImage!.path.split('/').last;
      FormData formData = FormData.fromMap({
        "profile_photo": await MultipartFile.fromFile(
          _selectedImage!.path,
          filename: fileName,
        ),
      });
      upImgService.uploadProfilePhoto(formData, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterAppBar(),
      // AppBar(
      //   title: const Text("Sign Up"),
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      // ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            child: _selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(
                                    CupertinoIcons.camera,
                                    size: 75,
                                  ),
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 25, right: 25),
                          child: Text(
                            "Add a profile photo so your friends know it's you",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 50, right: 50),
                          child: TextButton(
                            onPressed: () async {
                              File? selectedImage = await Navigator.push<File?>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const GallerySelectorScreen(),
                                ),
                              );
                              if (selectedImage != null) {
                                setState(() {
                                  _selectedImage = selectedImage;
                                });
                              }
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
                            if (_selectedImage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: TextButton(
                                  onPressed: () {
                                    _uploadPhoto(context);
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
                            if (_selectedImage == null)
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: TextButton(
                                  onPressed: () {
                                    // Navigate to the next screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TagSelectScreen()),
                                    );
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
                          ],
                        ),
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
