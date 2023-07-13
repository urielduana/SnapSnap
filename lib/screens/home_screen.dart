import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapsnap/models/post.dart';
import 'package:snapsnap/screens/bottom_navigation_bar_screen.dart';
import 'package:snapsnap/screens/feed_screen.dart';
import 'package:snapsnap/screens/notifications_screen.dart';
import 'package:snapsnap/screens/profile/profile_screen.dart';
import '../services/auth.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('SnapSnap'),
        ),
        body: const Center(
          child: Text('Welcome to SnapSnap'),
        ),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.deepPurpleAccent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(auth.user.avatar ?? ''),
                      radius: 30,
                    ),
                    const Text(
                      'SnapSnap',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    const Text(
                      'snap your moments',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontStyle: FontStyle.italic),
                    ),
                    // Welcome User text
                    Text(
                      'Welcome ${auth.user.name}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                )),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(CupertinoIcons.square_arrow_left),
              onTap: () {
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
            ListTile(
              title: const Text('Feed'),
              leading: const Icon(CupertinoIcons.news),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Profile'),
              leading: const Icon(CupertinoIcons.profile_circled),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Navigation Bar'),
              leading: const Icon(CupertinoIcons.profile_circled),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomBottomNavigationBar()),
                );
              },
            ),
            ListTile(
              title: const Text('Notifications'),
              leading: const Icon(CupertinoIcons.news),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationScreen()),
                );
              },
            ),
          ],
        )),
        bottomNavigationBar: BottomNavigationBar(items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            // go to feed screen
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt), label: 'Camera'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ]));
  }
}
