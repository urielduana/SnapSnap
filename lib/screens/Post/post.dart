import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snapsnap/services/post_service.dart';
import 'package:snapsnap/screens/gallery/gallery_selector.dart';
import 'package:snapsnap/screens/home_screen.dart';

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
  final TextEditingController _descriptionController = TextEditingController();
  bool _isPublishButtonEnabled = false;
  final List<_Tag> _availableTags = [
    _Tag(2, 'Private'),
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

  _Tag? _selectedTag;

  @override
  void initState() {
    super.initState();
    if (widget.selectedImage != null) {
      _selectedImages.add(widget.selectedImage!);
    }
    _selectedTag = null;
  }

  @override
  Widget build(BuildContext context) {
    bool hasDescription = _descriptionController.text.trim().isNotEmpty;
    bool hasImages = _selectedImages.isNotEmpty;

    _updatePublishButtonState(hasDescription, hasImages);

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
                          SizedBox(
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
                              icon: const Icon(Icons.close),
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
                onPressed: () async {
                  File? selectedImage = await Navigator.push<File?>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GallerySelectorScreen(
                        selectedImages: [],
                      ),
                    ),
                  );

                  if (selectedImage != null) {
                    setState(() {
                      _selectedImages.add(selectedImage);
                    });
                  }
                },
                child: const Text('Add Images'),
              ),
              const SizedBox(height: 16),
              DropdownButton<_Tag>(
                value: _selectedTag,
                onChanged: (tag) {
                  setState(() {
                    _selectedTag = tag;
                  });
                },
                hint: const Text('Tags'),
                items: [
                  DropdownMenuItem<_Tag>(
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
                children: _selectedTag != null
                    ? [
                        Chip(
                          label: Text(_selectedTag!.name),
                          onDeleted: () {
                            setState(() {
                              _selectedTag = null;
                            });
                          },
                        ),
                      ]
                    : [],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                onChanged: (text) {
                  setState(() {
                    _isPublishButtonEnabled = text.trim().isNotEmpty;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isPublishButtonEnabled ? _uploadDataToServer : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Publish'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updatePublishButtonState(bool hasDescription, bool hasImages) {
    setState(() {
      _isPublishButtonEnabled = hasDescription && hasImages;
    });
  }

  Future<void> _uploadDataToServer() async {
    try {
      // Mostrar el diálogo de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Publishing..."),
              ],
            ),
          );
        },
      );

      // Obtener los id's de los tags seleccionados
      List<int> tagIds = _selectedTag != null
          ? [_selectedTag!.id]
          : [1]; // Usar [1] por defecto si _selectedTag es nulo

      // Obtener el token de autenticación desde el almacenamiento seguro
      final storage = FlutterSecureStorage();
      String? authToken = await storage.read(key: 'token');

      if (authToken != null) {
        // Configurar el token de autenticación en el servicio PostService
        PostService.setAuthToken(authToken);

        // Imprimir los datos que se enviarán al servidor
        print('Enviando datos al servidor:');
        print('Description: ${_descriptionController.text}');
        print('Tags: $tagIds');
        print('Imágenes: $_selectedImages');

        // Llamar al método uploadPost del servicio PostService
        await PostService.uploadPost(
          description: _descriptionController.text,
          tags: tagIds,
          images: _selectedImages,
        );

        print('Datos enviados exitosamente al servidor.');

        // Cerrar el diálogo de carga
        Navigator.of(context, rootNavigator: true).pop();

        // Navegar a la página HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MyHomeScreen(), // Reemplaza MyHomeScreen con el nombre correcto
          ),
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
