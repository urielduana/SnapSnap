import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snapsnap/models/collocation.dart';
import 'package:provider/provider.dart';
import 'package:snapsnap/services/auth.dart';
import 'package:snapsnap/screens/profile/photos_screen.dart';
import 'package:snapsnap/services/dio.dart';
import 'package:snapsnap/screens/gallery/gallery_selector.dart';
import 'package:snapsnap/screens/tags/tag_select.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

List<Collocation> collocationList = [
  Collocation(
    name: "astetic",
    thumbnail:
        'https://images.unsplash.com/photo-1500305614571-ae5b6592e65d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1176&q=80', // Reemplaza con la ruta correcta de la imagen
    tags: ["Tag 1", "Tag 2"],
    posts: [], // Debes proporcionar una lista de objetos Post si es necesario
  ),
  Collocation(
    name: "dogs",
    thumbnail:
        'https://images.unsplash.com/photo-1510771463146-e89e6e86560e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1362&q=80', // Reemplaza con la ruta correcta de la imagen
    tags: ["Tag 3", "Tag 4"],
    posts: [], // Debes proporcionar una lista de objetos Post si es necesario
  ),
  // Agrega más objetos Collocation según sea necesario
];

class _ProfileScreenState extends State<ProfileScreen> {
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
    var user = await storage.read(key: 'user');
    var userMap = jsonDecode(user!);

    Dio.Response response = await dio().get('/profile/${userMap['id']}',
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
              return Center(
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
                        Text(profileData['favorite_tags'][0]['tag']
                            .runtimeType
                            .toString()),
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
                      // makeColloction(profileData['favorite_tags'], context),
                      Text(profileData['favorite_tags'].toString()),
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

Widget makeColloction(Map<String, dynamic> collocation, BuildContext context) {
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
              return GestureDetector(
                  onTap: () {
                    // Llama a la función de navegación con el nombre del tag
                    navigateToPhotosScreen(context, collocation[index].name);
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
                                          collocation[index].thumbnail),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Stack(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10, sigmaY: 10),
                                        child: Container(
                                            height: 90,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  collocation[index].name,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "${collocation[index].tags.length} photos",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                )
                                              ],
                                            )),
                                      ),
                                    ),
                                  ])),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ));
            },
          ),
        )
      ],
    ),
  );
}

void navigateToPhotosScreen(BuildContext context, String tagName) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PhotosScreen(tagName: tagName),
    ),
  );
}

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
                    MaterialPageRoute(builder: (context) => TagSelectScreen()),
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
