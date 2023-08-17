import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MaterialApp(
    home: CommentScreen(postId: 18),
  ));
}

class CommentScreen extends StatefulWidget {
  final int postId;

  CommentScreen({required this.postId});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  Dio _dio = Dio();
  List<Map<String, dynamic>> comments = [];
  TextEditingController commentController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    try {
      final response = await _dio.get(
        'http://18.119.140.226:8000/api/posts/${widget.postId}/comments',
      );

      setState(() {
        comments = List<Map<String, dynamic>>.from(response.data);
        isLoading = false;
      });
    } catch (error) {
      isLoading = false;
    }
  }

  Future<void> postComment(String newComment) async {
    try {
      final storage = FlutterSecureStorage();
      String? authToken = await storage.read(key: 'token');

      if (authToken == null) {
        print('Token not found');
        return;
      }

      final response = await _dio.post(
        'http://18.119.140.226:8000/api/posts/${widget.postId}/comments',
        data: {'comment': newComment},
        options: Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      fetchComments();

      commentController.clear();
    } catch (error) {
      print('Error posting comment: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              const Text(
                'Comments:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (BuildContext context, int index) {
                        final comment = comments[index];
                        final userComment = comment['user_comment'];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              userComment['avatar'] ??
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJGD4o3OwM7OxLiwmYUwfZJuykW5cHKp4AfjKa8AB3EjwCr4mGc1C3pDcHZ5DC2xhLHXs',
                            ),
                          ),
                          title: Text(comment['comment']),
                          subtitle: Text(
                              'By: ${userComment['username'] ?? 'Unknown'}'),
                        );
                      },
                    ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String newComment = commentController.text;
                      postComment(newComment);
                    },
                    child: const Text('Comment'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
