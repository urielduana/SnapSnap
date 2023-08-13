import 'dart:convert';

import '../models/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  List<dynamic> notifications = [];

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/notifications.json');
    final data = await json.decode(response);

    setState(() {
      notifications = data['notifications']
          .map((data) => InstagramNotification.fromJson(data))
          .toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            "Activity",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
        ),
        body: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: notificationItem(notifications[index]),
                secondaryActions: <Widget>[
                  Container(
                      height: 60,
                      color: Colors.grey.shade500,
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      )),
                  Container(
                      height: 60,
                      color: Colors.red,
                      child: Icon(
                        Icons.delete_outline_sharp,
                        color: Colors.white,
                      )),
                ],
              );
            }));
  }

  notificationItem(InstagramNotification notification) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(notification.profilePic)),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: notification.name,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: notification.content,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface)),
                    TextSpan(
                      text: notification.timeAgo,
                      style: TextStyle(color: Colors.grey.shade500),
                    )
                  ])),
                )
              ],
            ),
          ),
          notification.postImage != ''
              ? Container(
                  width: 50,
                  height: 50,
                  child:
                      ClipRRect(child: Image.network(notification.postImage)),
                )
              : Container(
                  height: 35,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Color(0xFF21005D),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                      child: Text('Follow',
                          style: TextStyle(color: Colors.white)))),
        ],
      ),
    );
  }
}
