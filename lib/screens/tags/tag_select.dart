import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:snapsnap/services/upTags.dart';

class TagSelectScreen extends StatefulWidget {
  @override
  _TagSelectScreenState createState() => _TagSelectScreenState();
}

class _TagSelectScreenState extends State<TagSelectScreen> {
  final List<Map<String, dynamic>> tags = [
    {
      'id': 1,
      'name': 'nature',
      'icon': Icons.nature,
    },
    {
      'id': 2,
      'name': 'food',
      'icon': Icons.fastfood,
    },
    {
      'id': 3,
      'name': 'travel',
      'icon': Icons.flight_takeoff,
    },
    {
      'id': 4,
      'name': 'fashion',
      'icon': Icons.shopping_bag,
    },
    {
      'id': 5,
      'name': 'fitness',
      'icon': Icons.fitness_center,
    },
    {
      'id': 6,
      'name': 'art',
      'icon': Icons.palette,
    },
    {
      'id': 7,
      'name': 'music',
      'icon': Icons.music_note,
    },
    {
      'id': 8,
      'name': 'photography',
      'icon': Icons.camera_alt,
    },
    {
      'id': 9,
      'name': 'technology',
      'icon': Icons.computer,
    },
    {
      'id': 10,
      'name': 'sports',
      'icon': Icons.sports_soccer,
    },
    {
      'id': 11,
      'name': 'movies',
      'icon': Icons.movie,
    },
    {
      'id': 12,
      'name': 'books',
      'icon': Icons.book,
    },
    {
      'id': 13,
      'name': 'health',
      'icon': Icons.favorite,
    },
    {
      'id': 14,
      'name': 'quotes',
      'icon': Icons.format_quote,
    },
    {
      'id': 15,
      'name': 'cars',
      'icon': Icons.directions_car,
    },
    {
      'id': 16,
      'name': 'beauty',
      'icon': Icons.face,
    },
    {
      'id': 17,
      'name': 'business',
      'icon': Icons.business,
    },
    {
      'id': 18,
      'name': 'humor',
      'icon': Icons.emoji_emotions,
    },
    {
      'id': 19,
      'name': 'education',
      'icon': Icons.school,
    },
    {
      'id': 20,
      'name': 'animals',
      'icon': Icons.tag_faces,
    }
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
        selectedTags.add({
          'name': tag['name'],
          'id': tag['id'],
        });
      }
    });
  }

  void SelectedTags() {
    updateTags(selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Tags'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: SelectedTags,
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
                          return Colors
                              .deepPurpleAccent; // Color cuando se presiona el botón
                        }
                        return isSelected
                            ? const Color.fromARGB(255, 43, 38,
                                53) // Color cuando está seleccionado
                            : const Color(
                                0xFF381E72); // Color cuando no está seleccionado
                      },
                    ),
                  ),
                  child: Text(isSelected ? 'Unfollow' : 'Follow'),
                ),
              ],
            ),
            onTap: () {
              toggleTagSelection(tag);
            },
          );
        },
      ),
    );
  }
}
