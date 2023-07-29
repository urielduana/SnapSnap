import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapsnap/services/post_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Post extends StatefulWidget {
  final File? selectedImage;
  const Post({Key? key, this.selectedImage}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _Tag {
  final int id;
  final String name;

  _Tag(this.id, this.name);
}

class _PostState extends State<Post> {
  final List<File> _selectedImages = [];
  final TextEditingController _captionController = TextEditingController();
  bool _isPublishButtonEnabled = false;
  final List<_Tag> _availableTags = [
    _Tag(3, 'Food'),
    _Tag(4, 'Travel'),
    _Tag(5, 'Fashion'),
    _Tag(6, 'Fitness'),
    _Tag(7, 'Art'),
    _Tag(8, 'Music'),
    _Tag(9, 'Photography'),
    _Tag(10, 'Technology'),
    _Tag(11, 'Sports'),
    _Tag(12, 'Movies'),
    _Tag(13, 'Books'),
    _Tag(14, 'Health'),
    _Tag(15, 'Quotes'),
    _Tag(16, 'Cars'),
    _Tag(17, 'Beauty'),
    _Tag(18, 'Business'),
    _Tag(19, 'Humor'),
    _Tag(20, 'Education'),
    _Tag(21, 'Animals'),
  ];

  _Tag? _selectedTag; // Tag seleccionado por el usuario
  final List<_Tag> _selectedTags =
      []; // Lista para mantener los tags seleccionados

  @override
  void initState() {
    super.initState();
    if (widget.selectedImage != null) {
      _selectedImages.add(widget.selectedImage!);
    }
    _selectedTag =
        null; // Asignar null para que aparezca "Tags" en el DropdownButton
  }

  @override
  Widget build(BuildContext context) {
    bool hasCaption = _captionController.text.trim().isNotEmpty;
    bool hasImages = _selectedImages.isNotEmpty;

    _updatePublishButtonState(hasCaption, hasImages);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
                            width: 150,
                            child: Image.file(
                              _selectedImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _selectedImages.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selectImagesFromGallery,
                child: const Text('Add Images'),
              ),
              const SizedBox(height: 16),
              DropdownButton<_Tag>(
                value: _selectedTag,
                onChanged: (tag) {
                  setState(() {
                    _selectedTag = tag;
                    if (_selectedTag != null) {
                      if (!_selectedTags.contains(_selectedTag!)) {
                        _selectedTags.add(_selectedTag!);
                      }
                      _selectedTag = null;
                    }
                  });
                },
                hint: const Text('Tags'),
                items: [
                  const DropdownMenuItem<_Tag>(
                    value: null,
                    child: Text('Tags'),
                  ),
                  ..._availableTags.map((tag) {
                    return DropdownMenuItem<_Tag>(
                      value: tag,
                      child: Text(tag.name),
                    );
                  }).toList(),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: _selectedTags.map((tag) {
                  return Chip(
                    label: Text(tag.name),
                    onDeleted: () {
                      setState(() {
                        _selectedTags.remove(tag);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _captionController,
                onChanged: (text) {
                  setState(() {
                    _isPublishButtonEnabled = text.trim().isNotEmpty;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Caption',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isPublishButtonEnabled ? _uploadDataToServer : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical:
                          16), // Ajustar el padding vertical según tus necesidades
                ),
                child: const Text('Publish'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updatePublishButtonState(bool hasCaption, bool hasImages) {
    setState(() {
      _isPublishButtonEnabled = hasCaption && hasImages;
    });
  }

  Future<void> _selectImagesFromGallery() async {
    final List<XFile> images = await ImagePicker().pickMultiImage();
    setState(() {
      _selectedImages.addAll(images.map((image) => File(image.path)));
    });
  }

  Future<void> _uploadDataToServer() async {
    try {
      // Obtener una lista de IDs de tags seleccionados
      List<int> tagIds = _selectedTags.map((tag) => tag.id).toList();

      if (tagIds.isEmpty) {
        // Si no se seleccionó ningún tag, agregar el tag por defecto con ID 1
        tagIds.add(1);
      }

      // Obtener el token de autenticación desde el almacenamiento seguro
      final storage = FlutterSecureStorage();
      String? authToken = await storage.read(key: 'token');

      if (authToken != null) {
        // Configurar el token de autenticación en el servicio PostService
        PostService.setAuthToken(authToken);

        // Llamar al método uploadPost del servicio PostService
        await PostService.uploadPost(
          caption: _captionController.text,
          tags: tagIds,
          images: _selectedImages,
        );
      } else {
        // Manejar el caso en que el token de autenticación sea nulo
        print('El token de autenticación es nulo');
      }
    } catch (e) {
      // Manejar errores si ocurre algún problema en la solicitud HTTP.
      print('Error al enviar los datos al servidor: $e');
      throw Exception('Error en la solicitud al servidor.');
    }
  }
}
