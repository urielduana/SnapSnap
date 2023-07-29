import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snapsnap/services/dio.dart';

class TagSelectScreen extends StatefulWidget {
  const TagSelectScreen({super.key});

  @override
  State<TagSelectScreen> createState() => _TagSelectScreenState();
}

class _TagSelectScreenState extends State<TagSelectScreen> {
  final storage = new FlutterSecureStorage();
  List<Map<String, dynamic>> indexedTags = [];
  List<Map<String, dynamic>> selectedTags = [];
  @override
  void initState() {
    super.initState();
    indexTags();
  }

  @override
  // Funtion that makes a Dio request to index all tags in the database
  void indexTags() async {
    var token = await storage.read(key: 'token') ?? '';
    Dio.Response response = await dio().get('/tags',
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
    indexedTags = List<Map<String, dynamic>>.from(response.data);
    print(indexedTags);
  }

  @override
  Widget build(BuildContext context) {
    // Verifies if the tags have been indexed
    if (indexedTags == [] || selectedTags == []) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
          body: SafeArea(
        // Generates a list with all the content of the indexed tags request
        child: ListView.builder(
          itemCount: indexedTags.length,
          itemBuilder: (BuildContext context, int index) {
            final tag = indexedTags[index];
            return ListTile(
              title: Row(children: [
                Expanded(
                  child: Container(
                    child: Text(tag['tag_name']),
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Select')),
              ]),
            );
          },
        ),
      ));
    }
  }
}
