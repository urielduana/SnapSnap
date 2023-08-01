import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:snapsnap/main.dart';
import 'package:snapsnap/services/dio.dart';
import 'package:snapsnap/services/reg.dart';

class TagSelectScreen extends StatefulWidget {
  const TagSelectScreen({super.key});

  @override
  State<TagSelectScreen> createState() => _TagSelectScreenState();
}

class _TagSelectScreenState extends State<TagSelectScreen> {
  final storage = new FlutterSecureStorage();
  late Future<List<Map<String, dynamic>>> indexedTagsFuture;
  List<Map<String, dynamic>> selectedTags = [];

  @override
  void initState() {
    super.initState();
    indexedTagsFuture = indexTags();
  }

  // Function that makes a Dio request to index all tags in the database
  Future<List<Map<String, dynamic>>> indexTags() async {
    var token = await storage.read(key: 'token') ?? '';
    Dio.Response response = await dio().get('/favorite_tags/create',
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
    return List<Map<String, dynamic>>.from(response.data);
  }

  void addIdToSelectedTags(int id) {
    selectedTags.add({'id': id});
    print(selectedTags);
    print(selectedTags.isEmpty);
  }

  void removeIdSelectedTags(int id) {
    selectedTags.removeWhere((element) => element['id'] == id);
    print(selectedTags);
    print(selectedTags.isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final register = context.watch<Register>();
    // Verifies if the tags have been indexed
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Favorite Tags'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
            child: const Text('Skip', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: indexedTagsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the request is being processed, show a loading indicator
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // If there was an error with the request, show an error message
              return Center(
                child: Text('Error fetching tags: ${snapshot.error}'),
              );
            } else {
              // If the request completed successfully, build the list with the data
              List<Map<String, dynamic>> indexedTags = snapshot.data ?? [];
              return ListView.builder(
                itemCount: indexedTags.length,
                itemBuilder: (BuildContext context, int index) {
                  final tag = indexedTags[index];
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(tag['tag_name']),
                        ),
                        // Change button between add and remove if the tag is selected from the array of objects
                        // Background color purple if the tag is not selected
                        if (selectedTags
                            .any((element) => element['id'] == tag['id']))
                          TextButton(
                              onPressed: () {
                                removeIdSelectedTags(tag['id']);
                                setState(() {});
                              },
                              child: const Text('Remove'))
                        else
                          TextButton(
                              onPressed: () {
                                addIdToSelectedTags(tag['id']);
                                setState(() {});
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF381E72),
                              ),
                              child: const Text('Add',
                                  style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: selectedTags.isEmpty == false
          ? FloatingActionButton.extended(
              onPressed: () {
                // Send data to provider
                // Map data only saves the id of the tags
                Map data = {
                  'favorite_tags': selectedTags,
                };

                Provider.of<Register>(context, listen: false)
                    .uploadFavoriteTags(data, context);
              },
              label: const Text('Save'),
              icon: const Icon(CupertinoIcons.checkmark_alt),
              backgroundColor: const Color(0xFF381E72),
            )
          : null,
    );
  }
}
