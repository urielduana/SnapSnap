import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:snapsnap/screens/profile/profile_screen_search.dart';
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
    return List<Map<String, dynamic>>.from(response.data);
  }

  void followUser(int index) async {
    print('Follow user $index');
    var token = await storage.read(key: 'token') ?? '';
    Dio.Response response = await dio().post('/users/follow',
        data: {'user_id': searchResults[index]['id']},
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
    _performSearch(_searchController.text);
  }

  void unfollowUser(int index) async {
    print('Unfollow user $index');
    var token = await storage.read(key: 'token') ?? '';
    Dio.Response response = await dio().post('/users/unfollow',
        data: {'user_id': searchResults[index]['id']},
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
    _performSearch(_searchController.text);
  }

  void openProfile(int index) {
    print('Open profile $index');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreenSearch(
          userId: searchResults[index]['id'],
        ),
      ),
    );
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
      setState(() {
        searchResults = results;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [],
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
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      openProfile(index);
                    },
                    child: Container(
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
                                      backgroundImage: NetworkImage(searchResults[
                                              index]['profile_photo'] ??
                                          'https://ui-avatars.com/api/?name=${searchResults[index]['username']}&background=random&length=1&bold=true'),
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          searchResults[index]['name'] ??
                                              '[ Name unasigned ]',
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
                                              (searchResults[index]
                                                          ['username'] !=
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
                          if (searchResults[index]['is_following'])
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(120, 30),
                                ),
                                onPressed: () {
                                  unfollowUser(index);
                                },
                                icon: const Icon(
                                  CupertinoIcons.checkmark_alt,
                                  size: 15,
                                ),
                                label: const Text(
                                  'Following',
                                  style: TextStyle(fontSize: 12),
                                ))
                          else
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(120, 30),
                                  backgroundColor: const Color(0xFF381E72),
                                ),
                                onPressed: () {
                                  followUser(index);
                                },
                                icon: const Icon(CupertinoIcons.add,
                                    size: 15, color: Colors.white),
                                label: const Text('Follow',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12)))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
