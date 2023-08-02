import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloatingActionButtonCamera extends StatelessWidget {
  const FloatingActionButtonCamera({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF381E72),
      onPressed: () {
        // Upload post route
      },
      child: const Icon(
        CupertinoIcons.add,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
