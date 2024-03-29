import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapsnap/models/file.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';

class GallerySelectorScreen extends StatefulWidget {
  final List<File> selectedImages;

  const GallerySelectorScreen({Key? key, required this.selectedImages})
      : super(key: key);

  @override
  State<GallerySelectorScreen> createState() => _GallerySelectorScreenState();
}

class _GallerySelectorScreenState extends State<GallerySelectorScreen> {
  List<FileModel> files = [];
  FileModel? selectedModel;
  String? image;

  @override
  void initState() {
    super.initState();
    getImagesPath();
  }

  getImagesPath() async {
    var imagePath = await StoragePath.imagesPath;
    var images = jsonDecode(imagePath!) as List;
    files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
    if (files.isNotEmpty) {
      setState(() {
        selectedModel = files[0];
        image = files[0].files[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedModel == null || image == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        body: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(CupertinoIcons.clear)),
                    const SizedBox(
                      width: 10,
                    ),
                    DropdownButtonHideUnderline(
                        child: DropdownButton<FileModel>(
                      items: getItems(),
                      value: selectedModel,
                      onChanged: (FileModel? d) {
                        assert(d!.files.isNotEmpty);
                        image = d!.files[0];
                        setState(() {
                          selectedModel = d;
                        });
                      },
                    ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton(
                    onPressed: () {
                      // Return image in File type
                      Navigator.of(context).pop(File(image!));
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: image != null
                  ? Image.file(
                      File(image!),
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: MediaQuery.of(context).size.width,
                    )
                  : Container(),
            ),
            const Divider(),
            selectedModel == null && selectedModel!.files.isEmpty
                ? Container()
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.37,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4),
                      itemBuilder: (_, i) {
                        var file = selectedModel!.files[i];
                        return GestureDetector(
                          child: Image.file(
                            File(file),
                            fit: BoxFit.cover,
                          ),
                          onTap: () {
                            setState(() {
                              image = file;
                            });
                          },
                        );
                      },
                      itemCount: selectedModel!.files.length,
                    ),
                  )
          ]),
        ),
        // Open the camera and take a picture
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Open camera and add image to the carousel
            openCameraAndAddToCarousel();
          },
          shape: const CircleBorder(),
          child: const Icon(CupertinoIcons.camera),
        ),
      );
    }
  }

  List<DropdownMenuItem<FileModel>> getItems() {
    return files
        .map((e) => DropdownMenuItem(
              value: e,
              child: Text(e.folder),
            ))
        .toList();
  }

  void openCameraAndAddToCarousel() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      widget.selectedImages.add(File(image.path));
      setState(() {
        this.image = image.path;
      });
    }
  }
}
