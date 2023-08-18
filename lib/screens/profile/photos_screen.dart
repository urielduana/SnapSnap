// import 'package:flutter/material.dart';

// class PhotosScreen extends StatelessWidget {
//   final int tagId;
//   final int userId;

//   const PhotosScreen({required this.tagId, required this.userId, Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(tagName),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             PhotoWidget(
//                 imageUrl:
//                     'https://images.unsplash.com/photo-1500305614571-ae5b6592e65d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1176&q=80'),
//             PhotoWidget(
//                 imageUrl:
//                     'https://images.unsplash.com/photo-1510771463146-e89e6e86560e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1362&q=80'),
//             PhotoWidget(
//                 imageUrl:
//                     'https://images.unsplash.com/photo-1500305614571-ae5b6592e65d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1176&q=80'),
//             PhotoWidget(
//                 imageUrl:
//                     'https://images.unsplash.com/photo-1510771463146-e89e6e86560e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1362&q=80'),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Widget para mostrar cada foto
// class PhotoWidget extends StatelessWidget {
//   final String imageUrl;

//   const PhotoWidget({required this.imageUrl, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Image.network(imageUrl),
//           ),
//         ),
//         Divider(
//           color: Color(0xFF381E72),
//           thickness: 1,
//           indent: 18,
//           endIndent: 18,
//         ),
//       ],
//     );
//   }
// }
