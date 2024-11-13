import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meilinflutterproject/firebase/firebase_cloud.dart';

import '../../services/singleton.dart';

class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({super.key});

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  final singleton = Singleton();
  String postKey = '';
  // List<List<IconData>> iconList = [];
  // List<List<bool>> likes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/publishedWork');
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
              "assets/images/D0FA5531-D9DD-4205-89A0-6E30AFAF493E.png"),
          fit: BoxFit.cover,
        )),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  const Text(
                    'Discussion Board',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Quincento"),
                  ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('comments')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Error');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                            documents = snapshot.data!.docs;
                        final filteredDocuments = documents
                            .where(
                                (doc) => singleton.commentIDs.contains(doc.id))
                            .toList();

                        return Expanded(
                            child: filteredDocuments
                                    .isEmpty // Check if the data source is empty
                                ? const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Share your thoughts...",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 50),
                                      ],
                                    ),
                                  )
                                : ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    itemCount: filteredDocuments.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final itemData = filteredDocuments[index];
                                      // if (filteredDocuments.length >
                                      //     iconList.length) {
                                      //   WidgetsBinding.instance
                                      //       .addPostFrameCallback((_) {
                                      //     setState(() {
                                      //       for (int i = 0;
                                      //           i < filteredDocuments.length;
                                      //           i++) {
                                      //         iconList.add([
                                      //           Icons.favorite_border,
                                      //           Icons.favorite
                                      //         ]);
                                      //         likes.add([false]);
                                      //       }
                                      //     });
                                      //   });
                                      // }
                                      return ListTile(
                                        title: Card(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.white70,
                                                      offset: Offset(
                                                        5.0,
                                                        5.0,
                                                      ),
                                                      blurRadius: 2.5,
                                                      spreadRadius: 2.0,
                                                    ), //BoxShadow
                                                    BoxShadow(
                                                      color: Colors.white,
                                                      offset: Offset(0.0, 0.0),
                                                      blurRadius: 0.0,
                                                      spreadRadius: 0.0,
                                                    ), //BoxShadow
                                                  ],
                                                  color: Colors.white70,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                        itemData[
                                                            'comment'], //Comment
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 23,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal)),
                                                    // Row(
                                                    //   mainAxisAlignment:
                                                    //       MainAxisAlignment.end,
                                                    //   children: [
                                                    //     ToggleButtons(
                                                    //       renderBorder: false,
                                                    //       isSelected:
                                                    //           likes[index],
                                                    //       onPressed: (n) {
                                                    //         setState(() {
                                                    //           likes[index][0] =
                                                    //               !likes[index]
                                                    //                   [0];
                                                    //         });
                                                    //         // TODO: Check if liked or not
                                                    //         // FirebaseCloud()
                                                    //         //     .updateLikes(
                                                    //         //         itemData.id,
                                                    //         //         itemData[
                                                    //         //             'likes']);
                                                    //       },
                                                    //       children: [
                                                    //         Icon(iconList[index][
                                                    //             likes[index][0] ==
                                                    //                     false
                                                    //                 ? 0
                                                    //                 : 1])
                                                    //       ],
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(),
                                  ));
                      })
                ]))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String comment = "";
          showDialog<String>(
              context: context,
              builder: (BuildContext c) => AlertDialog(
                    content: TextField(
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                      onChanged: (text) {
                        setState(() {
                          comment = text;
                        });
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          // setState(() {
                          //   iconList
                          //       .add([Icons.favorite_border, Icons.favorite]);
                          //   likes.add([false]);
                          // });
                          FirebaseCloud().createComment(singleton.id, comment);
                          FirebaseCloud().getWriting(singleton.id, true);
                          Navigator.pop(c, 'Submit');
                        },
                        child: const Text('Submit'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(c, 'Cancel');
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ));
        },
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add),
      ),
    );
  }
}
