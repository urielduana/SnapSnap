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
  List<String> usernames = [];

  @override
  void initState() {
    super.initState();
    fetchUsernames();
  }

  Future<void> fetchUsernames() async {
    try {
      final storage = FlutterSecureStorage();
      final authToken = await storage.read(key: 'token');

      final response = await _dio.get(
        'http://18.119.140.226:8000/api/feed',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );
      if (response.statusCode == 200) {
        final posts = List<Map<String, dynamic>>.from(response.data);
        final List<String> tempUsernames = posts.map((post) => post['username'].toString()).toList();
        setState(() {
          usernames = tempUsernames;
        });
      } else {
        // Handle error
      }
    } catch (error) {
      // Handle error
    }
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
              itemCount: usernames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(usernames[index]),
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
