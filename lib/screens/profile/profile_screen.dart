import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snapsnap/models/collocation.dart';
import 'package:snapsnap/models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final storage = new FlutterSecureStorage();
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        appBar: AppBar(
          elevation: 0,
          actions: [
            IconButton(
                iconSize: 25,
                onPressed: () {},
                icon: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(CupertinoIcons.ellipsis),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  color: Theme.of(context).colorScheme.background),
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://t3.ftcdn.net/jpg/04/67/63/68/360_F_467636853_Hs8fMr0TucvHVkvO2q0sbksdKU4pdOSQ.jpg'),
                    maxRadius: 50,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Bill Macmillan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "@annehathaway",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      makeFollowWidget(count: 120, name: "Followers"),
                      Container(
                        width: 2,
                        height: 15,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      makeFollowWidget(count: 1520, name: "Following"),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  makeActionButtons(context),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.2))),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Collotion",
                            style: TextStyle(
                                // color:Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          Container(
                            width: 50,
                            padding: const EdgeInsets.only(bottom: 10),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color(0xFF381E72), width: 3))),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Likes",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
                // makeColloction(widget.user!.collocation)
              ]),
            ),
            const SizedBox(
              height: 200,
            ),
          ]),
        ));
  }
}

// Widget makeColloction(List<Collocation> collocation) {
//   return Container(
//     child: Column(
//       children: <Widget>[
//         Container(
//           padding: const EdgeInsets.only(top: 20),
//           height: 320,
//           child: ListView.builder(
//             shrinkWrap: true,
//             scrollDirection: Axis.horizontal,
//             itemCount: collocation.length,
//             itemBuilder: (context, index) {
//               return AspectRatio(
//                 aspectRatio: 1.2 / 1,
//                 child: Column(
//                   children: <Widget>[
//                     Expanded(
//                       child: Container(
//                           margin: const EdgeInsets.only(right: 20),
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                                   image:
//                                       AssetImage(collocation[index].thumbnail),
//                                   fit: BoxFit.cover),
//                               borderRadius: BorderRadius.circular(20),
//                               color: Colors.orange),
//                           child: Stack(
//                               alignment: AlignmentDirectional.bottomCenter,
//                               children: <Widget>[
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(20),
//                                   child: BackdropFilter(
//                                     filter: ImageFilter.blur(
//                                         sigmaX: 10, sigmaY: 10),
//                                     child: Container(
//                                         height: 90,
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 20),
//                                         width: double.infinity,
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(24),
//                                         ),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: <Widget>[
//                                             Text(
//                                               collocation[index].name,
//                                               style: const TextStyle(
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.w600,
//                                                   fontSize: 15),
//                                             ),
//                                             const SizedBox(
//                                               height: 5,
//                                             ),
//                                             Text(
//                                               "${collocation[index].tags.length} photos",
//                                               style: const TextStyle(
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.w300),
//                                             )
//                                           ],
//                                         )),
//                                   ),
//                                 ),
//                               ])),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Container(
//                       height: 32,
//                       margin: const EdgeInsets.only(right: 20),
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: collocation[index].tags.length,
//                         itemBuilder: (context, tagIndex) => Container(
//                           margin: const EdgeInsets.only(right: 10),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 25, vertical: 5),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             // color: Colorsys.grey300
//                           ),
//                           child: Center(
//                             child: Text(
//                               collocation[index].tags[tagIndex],
//                               style: const TextStyle(),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         )
//       ],
//     ),
//   );
// }

Widget makeFollowWidget({count, name}) {
  return Row(
    children: <Widget>[
      Text(
        count.toString(),
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        name,
        style: const TextStyle(fontSize: 15),
      ),
    ],
  );
}

Widget makeActionButtons(context) {
  return Transform.translate(
    offset: const Offset(0, 20),
    child: Container(
      height: 65,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.background,
                blurRadius: 15,
                offset: const Offset(0, 10))
          ]),
      child: Row(
        children: <Widget>[
          Expanded(
            child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                height: double.infinity,
                elevation: 0,
                onPressed: () {},
                color: const Color(0xFF381E72),
                child: const Text(
                  "Follow",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                height: double.infinity,
                elevation: 0,
                onPressed: () {},
                color: Colors.transparent,
                child: const Text(
                  "Message",
                  style: TextStyle(fontWeight: FontWeight.w400),
                )),
          )
        ],
      ),
    ),
  );
}
