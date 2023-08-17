import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapsnap/screens/bottom_navigation_bar_screen.dart';
import 'package:snapsnap/screens/feed_screen.dart';
import 'package:snapsnap/screens/floating_action_button_camera.dart';
import 'package:snapsnap/screens/notifications_screen.dart';
import 'package:snapsnap/screens/profile/profile_screen.dart';
import 'package:snapsnap/screens/search/search_screen.dart';
import 'package:snapsnap/services/auth.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  List<Widget> tabs = [
    FeedScreen(),
    SearchScreen(),
    ProfileScreen(),
    // Center(child: Text("Profile", style: TextStyle(color: Colors.white))),
    const NotificationScreen(),
    const Center(
        child: Text("Add item", style: TextStyle(color: Colors.white))),
  ];

  int currentPage = 0;

  setPage(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('SnapSnap'),
      // ),
      body: tabs[currentPage],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentPage: currentPage,
        setPage: setPage,
      ),
      floatingActionButton: const FloatingActionButtonCamera(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
