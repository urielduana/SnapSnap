import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Column(
        children: [
          const Text('Error'),
          const Text('Something went wrong'),
        ],
      ),
    );
  }
}
