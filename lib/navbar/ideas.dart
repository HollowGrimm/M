import 'package:flutter/material.dart';
import 'package:meilinflutterproject/ideas/draft.dart';
import 'package:meilinflutterproject/singleton.dart';

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
  void initState() {
    super.initState();

    if (singleton.ideas.isNotEmpty && singleton.ideaKeys.isNotEmpty) {
      for (int i = 0; i < singleton.ideaKeys.length; i++) {
        idea.add(singleton.ideas[singleton.ideaKeys[i]]!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("My Ideas",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.normal)),
            Expanded(
                child: idea.isEmpty // Check if the data source is empty
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
                        itemCount: idea.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Container(
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
                                  child: Column(
                                    children: [
                                      Text(idea[index][0],
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.normal)),
                                      const SizedBox(height: 10),
                                      Text(idea[index][2],
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.normal)),
                                      const SizedBox(height: 10),
                                      Text(shortContent(idea[index][3]),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                )),
                            onTap: () {
                              singleton.setKey(singleton.ideaKeys[index]);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const DraftScreen(),
                              ));
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ))
          ]),
    );
  }
}
