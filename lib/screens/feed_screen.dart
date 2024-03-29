import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:snapsnap/screens/comment_screen.dart';

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

  void _showCommentsModal(BuildContext context, int postId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentScreen(postId: postId),
      ),
    );
  }

  Future<void> fetchPosts() async {
    try {
      const storage = FlutterSecureStorage();
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
      const storage = FlutterSecureStorage();
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
          //Filtros(),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final comments = post['comments'] as List<dynamic>;

                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJGD4o3OwM7OxLiwmYUwfZJuykW5cHKp4AfjKa8AB3EjwCr4mGc1C3pDcHZ5DC2xhLHXs"),
                          radius: 24,
                        ),
                        title: Text(
                          post['username'] ?? 'Unassigned',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  right:
                                      8.0), // Agregamos un margen a la derecha
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '#${post['tag_name'] ?? 'No tag'}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future:
                            precacheImage(NetworkImage(post['url']), context),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Container(
                              height: 300,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(post['url']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 300,
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['description'] ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 1.0),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                          ? const Color(0xFF381E72)
                                          : Colors.grey,
                                    ),
                                    label: Text(
                                      '${post['likes'] ?? 0} likes',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  TextButton.icon(
                                    onPressed: () {
                                      _showCommentsModal(context, post['id']);
                                    },
                                    icon: const Icon(Icons.comment),
                                    label: Text(
                                      'Comments (${comments.length})',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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

/* class Filtros extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            8,
            (index) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: EtiquetaFiltro(),
            ),
          ),
        ),
      ),
    );
  }
} */

class EtiquetaFiltro extends StatelessWidget {
  const EtiquetaFiltro({super.key});
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
              image: const DecorationImage(
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
