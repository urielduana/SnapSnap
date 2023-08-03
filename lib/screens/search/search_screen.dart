import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  final List<String> profileImgUrls = [
    'https://images.unsplash.com/photo-1524250502761-1ac6f2e30d43?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1888&q=80 ',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80',
  ];

  final List<String> users = ['Ana', 'Diana', 'Anastacia'];
  final List<String> usernames = ['@ana', '@diana', '@anastacia'];
  final List<bool> isFollowing = [false, true, false];

  @override

  //  function to follow or unfollow a user
  void followUser(int index) {
    print('Follow user $index');
  }

  void unfollowUser(int index) {
    print('Unfollow user $index');
  }

  void openProfile(int index) {
    print('Open profile $index');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(CupertinoIcons.search),
                      hintText: 'Search user',
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF381E72),
                  ),
                  onPressed: () {
                    // Lógica de búsqueda
                    FocusScope.of(context).unfocus();
                  },
                  icon: const Icon(CupertinoIcons.search,
                      color: Colors.white, size: 17),
                  label: const Text(
                    'Search',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: profileImgUrls.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(profileImgUrls[index]),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      users[index],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          usernames[index],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (isFollowing[index])
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(120, 30),
                            ),
                            onPressed: () {
                              unfollowUser(index);
                            },
                            icon: const Icon(
                              CupertinoIcons.checkmark_alt,
                              size: 15,
                            ),
                            label: const Text(
                              'Following',
                              style: TextStyle(fontSize: 12),
                            ))
                      else
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(120, 30),
                              backgroundColor: const Color(0xFF381E72),
                            ),
                            onPressed: () {
                              followUser(index);
                            },
                            icon: const Icon(CupertinoIcons.add,
                                size: 15, color: Colors.white),
                            label: const Text('Follow',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)))
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
