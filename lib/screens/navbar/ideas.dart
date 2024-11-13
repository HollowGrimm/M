import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meilinflutterproject/services/singleton.dart';

import '../../firebase/firebase_cloud.dart';

class IdeasScreen extends StatefulWidget {
  const IdeasScreen({super.key});

  @override
  State<IdeasScreen> createState() => _IdeasScreenState();
}

class _IdeasScreenState extends State<IdeasScreen> {
  final singleton = Singleton();
  List<List<String>> idea = [];

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
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage(
            "assets/images/B5DD5EF3-56DE-481E-A964-5D4ACE04D0A0.png"),
        fit: BoxFit.cover,
      )),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("My Ideas",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Quincento")),
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
                    final filteredDocuments = documents
                        .where((doc) => singleton.userIdeasIDs.contains(doc.id))
                        .toList();

                    return Expanded(
                        child: filteredDocuments
                                .isEmpty // Check if the data source is empty
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Create An Idea",
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
                                                Text(itemData['title'],
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                const SizedBox(height: 10),
                                                Text(itemData['modifiedDate'],
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                const SizedBox(height: 10),
                                                Text(
                                                    shortContent(
                                                        itemData['story']),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                              ],
                                            ),
                                          )),
                                    ),
                                    onTap: () async {
                                      singleton.setID(itemData.id);
                                      await FirebaseCloud()
                                          .getWriting(itemData.id, false);
                                      Navigator.popAndPushNamed(
                                          context, '/draft');
                                    },
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                              ));
                  })
            ]),
      ),
    );
  }
}
