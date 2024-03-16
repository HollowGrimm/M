import 'package:flutter/material.dart';

class LearningCenterScreen extends StatefulWidget {
  const LearningCenterScreen({super.key});

  @override
  State<LearningCenterScreen> createState() => _LearningCenterScreenState();
}

class _LearningCenterScreenState extends State<LearningCenterScreen> {
  bool openSearch = false;
  List<Widget> posts = [
    const Text("Title",
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal),
        textAlign: TextAlign.center),
    const Text(
        "Lorem ipsum dolor sit amet,onsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        style: TextStyle(
            color: Colors.black, fontSize: 10, fontWeight: FontWeight.normal),
        textAlign: TextAlign.center),
    const Text("Author", textAlign: TextAlign.center),
  ];

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
              child: Text("Learning Center",
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
                child: Center(
              child: ListView(
                children: [
                  const SizedBox(height: 80),
                  posts[0],
                  const Icon(Icons.photo, size: 100),
                  posts[1],
                  posts[2],
                  const SizedBox(height: 80),
                  posts[0],
                  const Icon(Icons.photo, size: 100),
                  posts[1],
                  posts[2],
                  const SizedBox(height: 80),
                  posts[0],
                  const Icon(Icons.photo, size: 100),
                  posts[1],
                  posts[2]
                ],
              ),
            ))
          ],
        )));
  }
}
