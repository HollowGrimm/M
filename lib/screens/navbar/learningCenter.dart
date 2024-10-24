import 'package:flutter/material.dart';
import 'package:meilinflutterproject/services/lc_docs.dart';

import '../../services/singleton.dart';

class LearningCenterScreen extends StatefulWidget {
  const LearningCenterScreen({super.key});

  @override
  State<LearningCenterScreen> createState() => _LearningCenterScreenState();
}

class _LearningCenterScreenState extends State<LearningCenterScreen> {
  final singleton = Singleton();
  final lcd = LCDocs();
  // bool openSearch = false;
  List<String> docs = [];
  List<String?> intro = [];

  @override
  void initState() {
    super.initState();
    docs = LCDocs.indDocs.keys.toList();

    for (var i in docs) {
      intro.add(shortContent(LCDocs.indDocs[i]!["Introduction"]));
    }
  }

  String shortContent(String? body) {
    String tempSentence = "";
    int counter = 0;
    String tempChar = body![counter];

    while (counter < body.length - 1 &&
        (counter < 121 || tempChar[tempChar.length - 1] != " ")) {
      tempSentence += tempChar;
      counter++;
      tempChar = body[counter];
      if (tempChar[tempChar.length - 1] != " ") {
        tempChar.substring(0, tempChar.length - 1);
      }
    }

    return tempSentence;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              child: const Center(
                child: Text("Learning Center",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Quincento")),
              ),
            ),
            const SizedBox(height: 15),
            // Visibility(
            //     visible: !openSearch,
            //     child: IconButton(
            //         onPressed: () {
            //           setState(() {
            //             openSearch = true;
            //           });
            //         },
            //         iconSize: 25.0,
            //         icon: const Icon(
            //           Icons.search,
            //           color: Colors.black,
            //         ))),
            // Visibility(
            //   visible: openSearch,
            //   child: const Center(
            //     child: TextField(
            //       decoration: InputDecoration(
            //           icon: Icon(
            //         Icons.search,
            //         color: Colors.black,
            //       )),
            //       style: TextStyle(
            //           color: Colors.black, fontWeight: FontWeight.normal),
            //       onChanged: null,
            //     ),
            //   ),
            // ),
            // Visibility(
            //   visible: openSearch,
            //   child: Center(
            //     child: Text("${docs.length} Results Found",
            //         style: const TextStyle(
            //             color: Colors.black,
            //             fontSize: 15,
            //             fontWeight: FontWeight.normal)),
            //   ),
            // ),
            Expanded(
                child: ListView.separated(
              itemCount: docs.length,
              itemBuilder: (BuildContext context, int index) {
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
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(children: [
                              Text(docs[index],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 23,
                                      fontWeight: FontWeight.normal)),
                              Text(intro[index]!,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal)),
                            ]))),
                  ),
                  onTap: () async {
                    singleton.setDoc(docs[index]);
                    Navigator.popAndPushNamed(context, '/document');
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(),
            ))
          ],
        )));
  }
}
