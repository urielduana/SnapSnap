import 'dart:convert';
import 'package:flutter/material.dart';

class TagSelectScreen extends StatefulWidget {
  @override
  _TagSelectScreenState createState() => _TagSelectScreenState();
}

class _TagSelectScreenState extends State<TagSelectScreen> {
  final List<Map<String, dynamic>> tags = [
    {
      'name': 'Animales',
      'icon': Icons.tag_faces,
    },
    {
      'name': 'Deporte',
      'icon': Icons.tag_faces,
    },
    {
      'name': 'Ciencia',
      'icon': Icons.tag_faces,
    },
    {
      'name': 'Estudio',
      'icon': Icons.tag_faces,
    },
    {
      'name': 'Hot',
      'icon': Icons.tag_faces,
    },
  ];

  List<Map<String, dynamic>> selectedTags = [];

  bool mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
    final nameEquals = a['name'] == b['name'];
    return nameEquals;
  }

  void toggleTagSelection(Map<String, dynamic> tag) {
    setState(() {
      if (selectedTags.any((element) => mapEquals(element, tag))) {
        selectedTags.removeWhere((element) => mapEquals(element, tag));
      } else {
        selectedTags.add(tag);
      }
    });
  }

  void showSelectedTagsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tags seleccionados'),
          content: SingleChildScrollView(
            child: ListBody(
              children: selectedTags
                  .map((tag) => Text(tag['name']))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Tags'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: showSelectedTagsDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tags.length,
        itemBuilder: (BuildContext context, int index) {
          final tag = tags[index];
          final isSelected =
              selectedTags.any((element) => mapEquals(element, tag));
          return ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Text(tag['name']),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    toggleTagSelection(tag);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.deepPurpleAccent; // Color cuando se presiona el botón
                        }
                        return isSelected
                            ? Color.fromARGB(255, 43, 38, 53) // Color cuando está seleccionado
                            : Color(0xFF381E72); // Color cuando no está seleccionado
                      },
                    ),
                  ),
                  child: Text(isSelected ? 'Unfollow' : 'Follow'),
                ),
              ],
            ),
            leading: Icon(tag['icon']),
            onTap: () {
              toggleTagSelection(tag);
            },
          );
        },
      ),
    );
  }
}
