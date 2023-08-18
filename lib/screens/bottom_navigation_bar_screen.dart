import 'package:flutter/cupertino.dart';
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
      color: Theme.of(context).colorScheme.background,
      shape: CircularNotchedRectangle(),
      child: Container(
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                CupertinoIcons.home,
                color: widget.currentPage == 0
                    ? Color(0xFF381E72)
                    : Theme.of(context).colorScheme.inverseSurface,
                size: 27,
              ),
              onPressed: () => widget.setPage(0),
            ),
            IconButton(
              icon: Icon(
                CupertinoIcons.search,
                color: widget.currentPage == 1
                    ? Color(0xFF381E72)
                    : Theme.of(context).colorScheme.inverseSurface,
                size: 27,
              ),
              onPressed: () => widget.setPage(1),
            ),
            SizedBox.shrink(),
            IconButton(
              icon: Icon(
                CupertinoIcons.person,
                color: widget.currentPage == 2
                    ? Color(0xFF381E72)
                    : Theme.of(context).colorScheme.inverseSurface,
                size: 27,
              ),
              onPressed: () => widget.setPage(2),
            ),
            IconButton(
                icon: Icon(
                  CupertinoIcons.bell,
                  color: widget.currentPage == 3
                      ? Color(0xFF381E72)
                      : Theme.of(context).colorScheme.inverseSurface,
                  size: 27,
                ),
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
