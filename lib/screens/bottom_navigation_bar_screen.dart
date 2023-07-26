// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:snapsnap/screens/gallery/gallery_selector.dart';
import 'package:snapsnap/screens/notifications_screen.dart';
import 'feed_screen.dart';
import 'search_screen.dart';
import 'package:snapsnap/screens/Post/post.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  List<Widget> tabs = [
    FeedScreen(),
    SearchScreen(),
    const Center(child: Text("Profile", style: TextStyle(color: Colors.white))),
    const NotificationScreen(),
    const Post(),
  ];

  int currentPage = 0;

  setPage(index) {
    if (index == 4) {
      _pickImage();
    } else {
      setState(() {
        currentPage = index;
      });
    }
  }

  Future<void> _pickImage() async {
    File? selectedImage = await Navigator.push<File?>(
      context,
      MaterialPageRoute(
        builder: (context) => const GallerySelectorScreen(selectedImages: [],),
      ),
    );

    if (selectedImage != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Post(selectedImage: selectedImage),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: tabs[currentPage],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade400,
        onPressed: () => setPage(4),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          color: Colors.grey.shade900,
          shape: const CircularNotchedRectangle(),
          child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: currentPage == 0 ? Colors.white : Colors.grey,
                      size: 30,
                    ),
                    onPressed: () => setPage(0),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: currentPage == 0 ? Colors.white : Colors.grey,
                      size: 30,
                    ),
                    onPressed: () => setPage(1),
                  ),
                  const SizedBox.shrink(),
                  IconButton(
                    icon: Icon(
                      Icons.person,
                      color: currentPage == 0 ? Colors.white : Colors.grey,
                      size: 30,
                    ),
                    onPressed: () => setPage(2),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: currentPage == 0 ? Colors.white : Colors.grey,
                      size: 30,
                    ),
                    onPressed: () => setPage(3),
                  )
                ],
              ))),
    );
  }
}
