import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapsnap/models/file.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';

class GallerySelectorScreen extends StatefulWidget {
  const GallerySelectorScreen({super.key});

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
    if (files != null && files.isNotEmpty) {
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
                    onPressed: () {},
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
            Container(
                height: MediaQuery.of(context).size.height * 0.45,
                child: image != null
                    ? Image.file(
                        File(image!),
                        height: MediaQuery.of(context).size.height * 0.45,
                        width: MediaQuery.of(context).size.width,
                      )
                    : Container()),
            const Divider(),
            selectedModel == null && selectedModel!.files.isEmpty
                ? Container()
                : Container(
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
      );
    }
  }

  List<DropdownMenuItem<FileModel>> getItems() {
    return files
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.folder),
                ))
            .toList() ??
        [];
  }
}
