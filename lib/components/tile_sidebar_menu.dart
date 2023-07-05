import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideMenuTile extends StatelessWidget {
  const SideMenuTile({
    super.key,
    required this.colorScheme,
  });
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Divider(
            color: colorScheme.onSurface.withOpacity(0.4),
            height: 1,
          ),
        ),
        ListTile(
          // onTap: () {},
          leading: SizedBox(
            height: 34,
            width: 34,
            child: Icon(
              CupertinoIcons.home,
              color: colorScheme.onSurface,
            ),
          ),
          title: Text(
            'Home',
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
