import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CommentScreen extends StatelessWidget {
  // Haz el request desde aqui con una funcion async
  // Solo pasa el id del post
  // El request debe obtener los datos del post, sus comentarios y datos del usuario que comentaron

  final String imageUrl;
  final String user;
  final String profileImgUrl;
  final String hashtag;
  final int imagesCount;
  final int likesCount;
  final int commentsCount;

  CommentScreen(
      {required this.imageUrl,
      required this.user,
      required this.profileImgUrl,
      required this.hashtag,
      required this.imagesCount,
      required this.likesCount,
      required this.commentsCount});

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
  final List<String> comments = [
    'Beutiful!',
    'I love your dog!',
    'That looks delicious!',
    'What an amazing place!',
    'You are handsome!',
  ];
  TextEditingController commentController = TextEditingController();

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
                Row(
                  children: [
                    // Imagen perfil
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(profileImgUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    // Columna con el nombre de usuario y el hashtag
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre de usuario
                        Text(
                          user,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        // Hashtag
                        Text(
                          hashtag,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Carrusel de imágenes o imagen principal
                imagesCount == 1
                    ? Image.network(
                        imageUrl,
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
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border_rounded),
                    Text('${likesCount} me gusta'),
                    SizedBox(width: 8.0),
                    Icon(Icons.comment_outlined),
                    SizedBox(width: 4.0),
                    Text('${commentsCount} comentarios'),
                  ],
                ),
                SizedBox(height: 8.0),
                Text(
                  'Comments:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(profileImgUrls[index]),
                      ),
                      title: Text(comments[index]),
                    );
                  },
                ),
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
                        // Aquí puedes realizar alguna acción con el nuevo comentario,
                        // como enviarlo a una base de datos, actualizar la lista de comentarios, etc.
                        // También puedes cerrar la pantalla de comentarios si lo deseas.
                      },
                      child: Text('Comment'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
