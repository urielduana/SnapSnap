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
  List<String> _selectedTags = []; // Lista para mantener los tags seleccionados

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Image.file(
                        _selectedImages[index],
                        width: null,
                        height: null,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: null,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedTags.add(newValue);
                  });
                }
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
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Post publicado'),
                          content:
                              const Text('Tu post ha sido publicado con éxito'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('Aceptar'),
                            ),
                          ],
                        ),
                      );
                    }
                  : null,
              child: const Text('Publish'),
            ),
          ],
        ),
      ),
    );
  }
}
