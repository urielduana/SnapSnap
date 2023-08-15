import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapSnap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FeedScreen(),
    );
  }
}

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Dio _dio = Dio();
  List<Map<String, dynamic>> posts = [];
  List<bool> showComments = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  void _showCommentsModal(BuildContext context, List<dynamic> comments) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Comentarios',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: comments.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return ListTile(
                  title: Text(
                    comment['text'] ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                  leading: Icon(Icons.comment),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cerrar',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchPosts() async {
    try {
      final storage = FlutterSecureStorage();
      final authToken = await storage.read(key: 'token');

      final response = await _dio.get(
        'http://18.119.140.226:8000/api/feed',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );
      if (response.statusCode == 200) {
        setState(() {
          posts = List<Map<String, dynamic>>.from(response.data);
        });
      } else {}
    } catch (error) {}
  }

  Future<void> toggleLike(int postIndex) async {
    final post = posts[postIndex];
    final newLikedState = !(post['liked'] ?? false);

    try {
      final storage = FlutterSecureStorage();
      final authToken = await storage.read(key: 'token');

      final response = await _dio.post(
        'http://18.119.140.226:8000/api/posts/${post['id']}/like',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
        data: {'liked': newLikedState},
      );

      if (response.statusCode == 200) {
        setState(() {
          post['liked'] = newLikedState;

          if (newLikedState) {
            post['likes'] = (post['likes'] ?? 0) + 1;
          } else {
            post['likes'] = (post['likes'] ?? 0) - 1;
          }
        });
      } else {}
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SnapSnap'),
      ),
      body: Column(
        children: [
          Filtros(),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final comments = post['comments'] as List<dynamic>;

                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJGD4o3OwM7OxLiwmYUwfZJuykW5cHKp4AfjKa8AB3EjwCr4mGc1C3pDcHZ5DC2xhLHXs"),
                          radius: 24,
                        ),
                        title: Text(
                          post['username'] ?? 'Unassigned',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Tag: ${post['tag_name'] ?? 'No tag'}'),
                      ),
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(post['url']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['description'] ?? '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () async {
                                    await toggleLike(index);
                                  },
                                  icon: Icon(
                                    post['liked']
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: post['liked']
                                        ? Color(0xFF381E72)
                                        : Colors.grey,
                                  ),
                                  label: Text(
                                    '${post['likes'] ?? 0}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                TextButton.icon(
                                  onPressed: () {
                                    _showCommentsModal(context, comments);
                                  },
                                  icon: Icon(Icons.comment),
                                  label: Text(
                                    'Comentarios (${comments.length})',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Filtros extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            8,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: EtiquetaFiltro(),
            ),
          ),
        ),
      ),
    );
  }
}

class EtiquetaFiltro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.purple,
                width: 3,
              ),
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1770&q=80',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Comida',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
