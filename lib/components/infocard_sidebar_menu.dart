import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapsnap/services/auth.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.auth,
    required this.colorScheme,
  });

  final Auth auth;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
          backgroundColor: Colors.white24,
          child: Icon(
            CupertinoIcons.person,
            color: Colors.white,
          )),
      title: Text(
        auth.user.name ?? '',
        style: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '@${auth.user.username ?? ''}',
        style: TextStyle(
            color: colorScheme.onSurface, fontStyle: FontStyle.italic),
      ),
    );
  }
}
