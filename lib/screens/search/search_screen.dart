import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:snapsnap/services/auth.dart';
import 'package:snapsnap/services/dio.dart';
import 'package:dio/dio.dart' as Dio;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  final List<String> profileImgUrls = [
    'https://images.unsplash.com/photo-1524250502761-1ac6f2e30d43?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1888&q=80 ',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80',
  ];

  final List<String> users = ['Ana', 'Diana', 'Anastacia'];
  final List<String> usernames = ['@ana', '@diana', '@anastacia'];
  final List<bool> isFollowing = [false, true, false];

  final storage = new FlutterSecureStorage();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> indexTags(String searchString) async {
    var token = await storage.read(key: 'token') ?? '';
    Dio.Response response = await dio().post('/users/search',
        data: {'search': searchString},
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
    print(response.data);
    return List<Map<String, dynamic>>.from(response.data);
  }

  void followUser(int index) {
    print('Follow user $index');
  }

  void unfollowUser(int index) {
    print('Unfollow user $index');
  }

  void openProfile(int index) {
    print('Open profile $index');
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }
    try {
      List<Map<String, dynamic>> results = await indexTags(query);
      print("-----------------");
      print(results);
      setState(() {
        searchResults = results;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Provider.of<Auth>(context, listen: false).logout();
            },
            child: const Text('Logout'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _performSearch,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(CupertinoIcons.search),
                      hintText: 'Search user',
                    ),
                  ),
                ),
                // Puedes eliminar el ElevatedButton aquí
              ],
            ),
            const SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: searchResults.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(profileImgUrls[index]),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      searchResults[index]['name'] ??
                                          'Name unasigned',
                                      style: TextStyle(
                                        // fontWeight: FontWeight.w700,
                                        fontWeight: searchResults[index]
                                                    ['username'] !=
                                                null
                                            ? FontWeight.w200
                                            : FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          (searchResults[index]['username'] !=
                                                  null
                                              ? '@${searchResults[index]['username']}'
                                              : 'Username unasigned'),
                                          style: TextStyle(
                                            fontWeight: searchResults[index]
                                                        ['username'] !=
                                                    null
                                                ? FontWeight.w400
                                                : FontWeight.w200,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Resto del código para seguir o dejar de seguir
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
