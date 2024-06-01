import 'package:flutter/material.dart';
import 'package:meilinflutterproject/published/publishedworks.dart';
import 'package:meilinflutterproject/singleton.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final singleton = Singleton();
  bool openSearch = false;
  List<List<String>> posts = [];

  //TODO: Create Search Algorithm

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

    if (singleton.published.isNotEmpty && singleton.publishedKeys.isNotEmpty) {
      for (int i = 0; i < singleton.publishedKeys.length; i++) {
        posts.add(singleton.published[singleton.publishedKeys[i]]!);
      }
    }
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
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
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
              child: const Center(
                child: TextField(
                  decoration: InputDecoration(
                      icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  )),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  onChanged: null,
                ),
              ),
            ),
            Visibility(
              visible: openSearch,
              child: const Center(
                child: Text("80 Results Found",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.normal)),
              ),
            ),
            Expanded(
                child: posts.isEmpty // Check if the data source is empty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Publish An Idea",
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
                        itemCount: posts.length,
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
                                      Text(posts[index][0], //Title
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 23,
                                              fontWeight: FontWeight.normal)),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 150,
                                            child: Text(
                                                shortContent(posts[index]
                                                    [3]), //Description
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ),
                                          ClipRect(
                                              child: Image.asset(
                                            'assets/images/Screenshot 2024-05-04 at 8.53.45 AM.png',
                                            width: 100,
                                            height: 100,
                                          )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("By ${posts[index][1]}", //Author
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 10),
                                          Text(posts[index][2], //Date
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                            onTap: () {
                              singleton.setKey(singleton.publishedKeys[index]);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const PublishedWork(),
                              ));
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ))
          ],
        )));
  }
}
