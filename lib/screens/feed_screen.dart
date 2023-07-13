import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<String> imageUrls = [
    'https://images.unsplash.com/photo-1500305614571-ae5b6592e65d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1176&q=80',
    'https://images.unsplash.com/photo-1510771463146-e89e6e86560e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1362&q=80',
    'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1770&q=80',
    'https://images.unsplash.com/photo-1604430456280-43f652c497aa?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80',
    'https://images.unsplash.com/photo-1583674392771-2abf6be75965?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=467&q=80',
  ];
  final List<String> profileImgUrls = [
    'https://images.unsplash.com/photo-1524250502761-1ac6f2e30d43?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1888&q=80 ',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80',
    'https://images.unsplash.com/photo-1603415526960-f7e0328c63b1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80',
  ];
  final List<int> likesCount = [100, 50, 200, 80, 120]; // Lista de me gusta
  final List<int> commentsCount = [30, 20, 50, 10, 40]; // Lista de comentarios
  final List<String> users = [
    'Ana',
    'Diana',
    'Anastacia',
    'Roberto',
    'Alberto'
  ]; // Lista de usuarios
  final List<String> hashtags = [
    '#amazing',
    '#beautiful',
    '#cool',
    '#great',
    '#nice'
  ]; // Lista de hashtags
  final List<String> usernames = [
    '@anaa123',
    '@diana123',
    '@anastacia123',
    '@roberto123',
    '@alberto123'
  ]; // Lista de nombres de usuario
  final List<String> timeAgo = [
    '1 min ago',
    '2 min ago',
    '3 min ago',
    '4 min ago',
    '5 min ago'
  ]; // Lista de tiempo transcurrido

  void toggleLike(int index) {
    setState(() {
      if (likesCount[index] == likesCount[index]) {
        likesCount[index]++;
      } else {
        likesCount[index]--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SnapSnap'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    children: [
                      // Profile photo
                      CircleAvatar(
                        maxRadius: 28,
                        backgroundImage: NetworkImage(profileImgUrls[index]),
                      ),
                      // Columna con el nombre de usuario y el hashtag
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nombre de usuario
                            Text(
                              users[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  usernames[index],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  timeAgo[index],
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            // Hashtag with border
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    hashtags[index],
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Carrusel de imágenes o imagen principal
                imageUrls.length == 1
                    ? Image.network(
                        imageUrls[index],
                        width: 400,
                        height: 400,
                        fit: BoxFit.cover,
                      )
                    : CarouselSlider(
                        options: CarouselOptions(
                          height: 350,
                          autoPlay: false,
                          enlargeCenterPage: false,
                          aspectRatio: 1.0,
                          enableInfiniteScroll: false,
                        ),
                        items: imageUrls.map((url) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: 400,
                                height: 400,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                const SizedBox(height: 10),
                // Contador de Me gusta y comentarios
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            likesCount[index] > 100
                                ? Icons.favorite
                                : Icons.favorite_border_rounded,
                            color: likesCount[index] > 100
                                ? const Color(0xFF381E72)
                                : Theme.of(context).colorScheme.outline,
                          ),
                          onPressed: () => toggleLike(index),
                        ),
                        Text('${likesCount[index]} me gusta'),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.comment_outlined,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        Text('${commentsCount[index]} comentarios'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
