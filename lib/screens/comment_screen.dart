import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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
  bool isLoading = true; // Indicador de carga

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
        isLoading = false; // La carga ha finalizado
      });
    } catch (error) {
      print('Error fetching comments: $error');
      isLoading = false; // La carga ha finalizado (incluso en caso de error)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Text(
                'Comments:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              isLoading
                  ? Center(child: CircularProgressIndicator()) // Mostrar indicador de carga
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
                          subtitle:
                              Text('By: ${userComment['username'] ?? 'Unknown'}'),
                        );
                      },
                    ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String newComment = commentController.text;
                      // Perform action with the new comment here, e.g., send it to a database
                      // You can also close the comment screen if desired
                    },
                    child: Text('Comment'),
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
