import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:snapsnap/services/auth.dart';
import 'package:snapsnap/screens/profile/photos_screen.dart';
import 'package:snapsnap/services/dio.dart';
import 'package:snapsnap/screens/gallery/gallery_selector.dart';
import 'package:snapsnap/screens/tags/tag_select.dart';

class ProfileScreenSearch extends StatefulWidget {
  final int userId;
  const ProfileScreenSearch({required int userId, Key? key})
      : userId = userId,
        super(key: key);
  @override
  State<ProfileScreenSearch> createState() => _ProfileScreenSearchState();
}

class _ProfileScreenSearchState extends State<ProfileScreenSearch> {
  File? _selectedImage;
  late Future<Map<String, dynamic>> indexedProfile;

  final storage = new FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    indexedProfile = indexProfile();
  }

  Future<Map<String, dynamic>> indexProfile() async {
    var token = await storage.read(key: 'token');

    Dio.Response response = await dio().get('/profile/${widget.userId}',
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));

    return Map<String, dynamic>.from(response.data);
  }

  void onTapProfileImage() async {
    File? selectedImage = await Navigator.push<File?>(
      context,
      MaterialPageRoute(
        builder: (context) => const GallerySelectorScreen(selectedImages: []),
      ),
    );
    if (selectedImage != null) {
      setState(() {
        _selectedImage = selectedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = new FlutterSecureStorage();
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
      appBar: AppBar(
        elevation: 0,
        actions: [
          ElevatedButton(
            onPressed: () {
              Provider.of<Auth>(context, listen: false).logout();
            },
            child: const Text('Logout'),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: indexedProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the request is being processed, show a loading indicator
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // If there was an error with the request, show an error message
              return Center(
                child: Text('Error fetching tags: ${snapshot.error}'),
              );
            } else {
              Map<String, dynamic> profileData = snapshot.data!;
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                        color: Theme.of(context).colorScheme.background),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: onTapProfileImage,
                          child: const CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://t3.ftcdn.net/jpg/04/67/63/68/360_F_467636853_Hs8fMr0TucvHVkvO2q0sbksdKU4pdOSQ.jpg',
                            ),
                            maxRadius: 50,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          // Usar request aqui
                          (profileData['name'] != null
                              ? profileData['name']
                              : '[ Name Unassigned ]'),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: profileData['name'] != null
                                  ? FontWeight.w600
                                  : FontWeight.w100),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          (profileData['favorite'] != null
                              ? '@${profileData['username']}'
                              : ''),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: profileData['username'] != null
                                  ? FontWeight.w600
                                  : FontWeight.w100,
                              fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            makeFollowWidget(
                                count: profileData['followers_count'],
                                name: "Followers"),
                            Container(
                              width: 2,
                              height: 15,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                            ),
                            makeFollowWidget(
                                count: profileData['following_count'],
                                name: "Following"),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        makeTagsButton(context),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.2))),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Tags",
                                  style: TextStyle(
                                      // color:Theme.of(context).colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Container(
                                  width: 50,
                                  padding: const EdgeInsets.only(bottom: 10),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color(0xFF381E72),
                                              width: 2))),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      makeCollection(profileData['favorite_tags'], context,
                          profileData['id']),
                    ]),
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

Widget makeCollection(
    List<dynamic> collocation, BuildContext context, int userId) {
  return Container(
    child: Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 20),
          height: 325,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: collocation.length,
            itemBuilder: (context, index) {
              var tag = collocation[index]['tag'];
              return GestureDetector(
                onTap: () {
                  // navigateToPhotosScreen(context, tag['id'], userId);
                },
                child: AspectRatio(
                  aspectRatio: 1.2 / 1,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                tag['posts'].isEmpty
                                    ? 'https://source.unsplash.com/random?' // URL por defecto si no hay posts
                                    : tag['posts'][0]['url'],
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Container(
                                    height: 90,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          tag['tag_name'].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

// void navigateToPhotosScreen(BuildContext context, int tagId, int userId) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => PhotosScreen(tagId: tagId, userId: userId),
//     ),
//   );
// }

Widget makeFollowWidget({count, name}) {
  return Row(
    children: <Widget>[
      Text(
        count.toString(),
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        name,
        style: const TextStyle(fontSize: 15),
      ),
    ],
  );
}

//Botton de follow para perfil de terceros
Widget makeActionButtons(context) {
  return Transform.translate(
    offset: const Offset(0, 20),
    child: Container(
      height: 65,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.background,
                blurRadius: 15,
                offset: const Offset(0, 10))
          ]),
      child: Row(
        children: <Widget>[
          Expanded(
            child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                height: double.infinity,
                elevation: 0,
                onPressed: () {},
                color: const Color(0xFF381E72),
                child: const Text(
                  "Follow",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
          ),
        ],
      ),
    ),
  );
}

//Botton de tags para perfil propio
Widget makeTagsButton(context) {
  return Transform.translate(
    offset: const Offset(0, 20),
    child: Container(
      height: 65,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.background,
                blurRadius: 15,
                offset: const Offset(0, 10))
          ]),
      child: Row(
        children: <Widget>[
          Expanded(
            child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                height: double.infinity,
                elevation: 0,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TagSelectScreen()),
                  );
                },
                color: const Color(0xFF381E72),
                child: const Text(
                  "Add New Tags",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
          ),
        ],
      ),
    ),
  );
}
