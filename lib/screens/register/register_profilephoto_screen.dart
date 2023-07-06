import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapsnap/components/register_appbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapsnap/services/reg.dart';
import 'package:snapsnap/services/upImg.dart';

class RegisterProfilePhotoScreen extends StatefulWidget {
  const RegisterProfilePhotoScreen({super.key});

  @override
  State<RegisterProfilePhotoScreen> createState() =>
      _RegisterProfilePhotoScreenState();
}

class _RegisterProfilePhotoScreenState
    extends State<RegisterProfilePhotoScreen> {
  File? _selectedImage;
  //subir imagen a el controlador
  final TextEditingController _imageController = TextEditingController();

  Future<void> _selectAndUpImage() async {
    final picker = ImagePicker();

    // Seleccionar imagen de la galeria o tomar una foto
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Camera'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        _selectedImage = File(pickedFile.path);
                        _imageController.text = _selectedImage!.path;
                      });
                      //obtner la ruta de la imagen
                      String filePath = _selectedImage!.path;

                      //Subir la img al servidor
                      Map<String, dynamic> data = {'image': filePath};
                      UpImg _UpImg = UpImg();
                      _UpImg.uploadAvatar(data, context);
                    }
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  child: const Text('Gallery'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        _selectedImage = File(pickedFile.path);
                      });
                      //obtener la ruta
                      String filePath = _selectedImage!.path;

                      //subir la img al servidor
                      Map<String, dynamic> data = {'image': filePath};
                      UpImg _UpImg = UpImg();
                      _UpImg.uploadAvatar(data, context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterAppBar(),
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
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
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
                                    )),
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
                        //Button to upload a photo with width of 150
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 50, right: 50),
                          child: TextButton(
                            onPressed: () {
                              _selectAndUpImage();
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
                                onPressed: () {},
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
                                  "Finish",
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
            )
          ],
        ),
      ),
    );
  }
}
