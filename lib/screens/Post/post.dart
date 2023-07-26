import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Post extends StatefulWidget {
  final File? selectedImage;
  const Post({Key? key, this.selectedImage}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  final List<File> _selectedImages = [];
  final TextEditingController _captionController = TextEditingController();
  bool _isPublishButtonEnabled = false;
  final List<String> _availableTags = [
    'Food',
    'Travel',
    'Fashion',
    'Fitness',
    'Art',
    'Music',
    'Photography',
    'Technology',
    'Sports',
    'Movies',
    'Books',
    'Health',
    'Quotes',
    'Cars',
    'Beauty',
    'Business',
    'Humor',
    'Education',
    'Animals',
  ];

  String? _selectedTag; // Tag seleccionado por el usuario
  final List<String> _selectedTags = []; // Lista para mantener los tags seleccionados

  @override
  void initState() {
    super.initState();
    if (widget.selectedImage != null) {
      _selectedImages.add(widget.selectedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New post'),
      ),
      body: SingleChildScrollView( // Agregamos el SingleChildScrollView para permitir desplazamiento hacia abajo
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              SizedBox(
                height: 200, // Ajustar el alto de las imágenes en la previsualización
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Mostrar las imágenes en una fila horizontal
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 150, // Ancho fijo para cada imagen
                        child: Image.file(
                          _selectedImages[index],
                          fit: BoxFit.cover, // Ajustar la imagen para cubrir el contenedor
                        ),
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
              DropdownButton<String>(
                value: _selectedTag,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTag = newValue;
                    if (_selectedTag != null) {
                      if (!_selectedTags.contains(_selectedTag!)) {
                        _selectedTags.add(_selectedTag!);
                      }
                      _selectedTag = null;
                    }
                  });
                },
                hint: const Text('Tags'),
                items: _availableTags.map((String tag) {
                  return DropdownMenuItem<String>(
                    value: tag,
                    child: Text(tag),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: _selectedTags.map((tag) {
                  return Chip(
                    label: Text(tag),
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
                onPressed: _isPublishButtonEnabled
                    ? () {
                        //mensaje de dialogo de prueba para ver si funciona con el boton para cerrar el mensaje de dialogo
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Post published'),
                              content: const Text('Your post has been published'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    : null,
                child: const Text('Publish'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectImagesFromGallery() async {
    final List<XFile>? images = await ImagePicker().pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages.addAll(images.map((image) => File(image.path)));
      });
    }
  }
}
