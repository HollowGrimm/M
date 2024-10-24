import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meilinflutterproject/firebase/firebase_cloud.dart';
import 'package:meilinflutterproject/services/singleton.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final singleton = Singleton();
  bool openSearch = false;
  String searchText = "";
  int results = 0;

  List search(fullList) {
    final tempList = [];
    if (searchText != '') {
      for (int i = 0; i < fullList.length; i++) {
        bool titleName = fullList[i]['title']
            .toLowerCase()
            .contains(searchText.toLowerCase());
        bool authorName = fullList[i]['username']
            .toLowerCase()
            .contains(searchText.toLowerCase());
        bool storyWord = fullList[i]['story']
            .toLowerCase()
            .contains(searchText.toLowerCase());
        if (titleName || authorName || storyWord) {
          tempList.add(fullList[i]);
        }
      }
    } else {
      return fullList;
    }
    return tempList;
  }

  String shortContent(String body) {
    String tempSentence = "";
    int counter = 0;
    String tempChar = body[counter];

    while (counter < body.length - 1 && counter < 121) {
      tempSentence += tempChar;
      counter++;
      tempChar = body[counter];
    }

    return tempSentence;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text("Published Posts",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Quincento")),
            ),
            Visibility(
                visible: !openSearch,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        openSearch = true;
                      });
                    },
                    iconSize: 25.0,
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ))),
            Visibility(
              visible: openSearch,
              child: Center(
                child: TextField(
                  decoration: const InputDecoration(
                      icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  )),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  onChanged: (text) {
                    setState(() {
                      searchText = text;
                    });
                  },
                  onTapOutside: (event) {
                    setState(() {
                      if (searchText == "") {
                        openSearch = false;
                      }
                    });
                  },
                ),
              ),
            ),
            Visibility(
              visible: openSearch,
              child: Center(
                child: Text('$results results found',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.normal)),
              ),
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('ideas_published')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                      documents = snapshot.data!.docs;
                  final filteredDocuments = search(
                      documents.where((doc) => doc['published']).toList());

                  if (filteredDocuments.length != results) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        results = filteredDocuments.length;
                      });
                    });
                  }

                  return Expanded(
                      child: filteredDocuments
                              .isEmpty // Check if the data source is empty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    searchText == ''
                                        ? "Publish An Idea"
                                        : "No search results",
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 50),
                                ],
                              ),
                            )
                          : ListView.separated(
                              scrollDirection: Axis.vertical,
                              itemCount: filteredDocuments.length,
                              itemBuilder: (BuildContext context, int index) {
                                final itemData = filteredDocuments[index];
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
                                                BorderRadius.circular(12)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              Text(itemData['title'], //Title
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 150,
                                                    child: Text(
                                                        shortContent(itemData[
                                                            'story']), //Description
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal)),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  ClipRect(
                                                      child: Image.asset(
                                                    singleton.randomImage(),
                                                    width: 150,
                                                    height: 150,
                                                  )),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      "By ${itemData['username']}", //Author
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                      itemData[
                                                          'modifiedDate'], //Date
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                  onTap: () async {
                                    singleton.setID(itemData.id);
                                    await FirebaseCloud()
                                        .getWriting(itemData.id, true);
                                    Navigator.popAndPushNamed(
                                        context, '/publishedWork');
                                  },
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                            ));
                })
          ],
        )));
  }
}
