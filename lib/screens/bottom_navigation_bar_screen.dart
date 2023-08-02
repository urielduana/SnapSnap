import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentPage;
  final Function(int) setPage;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentPage,
    required this.setPage,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey.shade900,
      shape: CircularNotchedRectangle(),
      child: Container(
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: widget.currentPage == 0 ? Colors.white : Colors.grey,
                size: 30,
              ),
              onPressed: () => widget.setPage(0),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: widget.currentPage == 1 ? Colors.white : Colors.grey,
                size: 30,
              ),
              onPressed: () => widget.setPage(1),
            ),
            SizedBox.shrink(),
            IconButton(
              icon: Icon(
                Icons.person,
                color: widget.currentPage == 2 ? Colors.white : Colors.grey,
                size: 30,
              ),
              onPressed: () => widget.setPage(2),
            ),
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: widget.currentPage == 3 ? Colors.white : Colors.grey,
                size: 30,
              ),
              onPressed: () => widget.setPage(3),
            ),
          ],
        ),
      ),
    );
  }
}
