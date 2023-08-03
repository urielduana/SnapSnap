import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapsnap/screens/gallery/gallery_selector.dart';
import 'package:snapsnap/screens/Post/post.dart';
import 'dart:io';

class FloatingActionButtonCamera extends StatelessWidget {
  const FloatingActionButtonCamera({Key? key}) : super(key: key);

  Future<void> _pickImage(BuildContext context) async {
    File? selectedImage = await Navigator.push<File?>(
      context,
      MaterialPageRoute(
        builder: (context) => const GallerySelectorScreen(
          selectedImages: [],
        ),
      ),
    );

    if (selectedImage != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Post(selectedImage: selectedImage),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF381E72),
      onPressed: () {
        _pickImage(context);
      },
      child: const Icon(
        CupertinoIcons.add,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
