import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapsnap/components/infocard_sidebar_menu.dart';
import 'package:snapsnap/components/tile_sidebar_menu.dart';

import '../services/auth.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        //invert colors between primary light and primary dark mode
        color: colorScheme.inversePrimary,
        child: SafeArea(
          child: Column(
            children: [
              InfoCard(auth: auth, colorScheme: colorScheme),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Browse".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: colorScheme.onSurface),
                ),
              ),
              SideMenuTile(colorScheme: colorScheme),
            ],
          ),
        ),
      ),
    );
  }
}
