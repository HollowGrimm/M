import 'package:flutter/material.dart';
import 'package:meilinflutterproject/screens/navbar/ai.dart';
import 'package:meilinflutterproject/screens/navbar/ideas.dart';
import 'package:meilinflutterproject/screens/navbar/learningCenter.dart';
import 'package:meilinflutterproject/screens/navbar/story.dart';
import 'package:meilinflutterproject/services/singleton.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  final singleton = Singleton();
  int currentIndex = 0;
  bool onIdeaTab = false;

  final List<Widget> tabs = const [
    StoryScreen(),
    IdeasScreen(),
    AIScreen(),
    LearningCenterScreen()
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = singleton.navbarIndex;
  }

  List<Widget> bgFinder() {
    List<Widget> W = [];
    if (currentIndex == 2) {
      W.add(Container(
        color: const Color.fromARGB(135, 202, 255, 204),
      ));
    } else if (currentIndex == 3) {
      W.add(Container(
        color: Colors.black,
      ));
    }
    W.add(tabs[currentIndex]);
    return W;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Community Editor",
            style: TextStyle(
                color: Colors.black,
                fontSize: 35,
                fontWeight: FontWeight.bold,
                fontFamily: "Quincento")),
        leadingWidth: 180,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/profile');
              },
              iconSize: 50.0,
              icon: const Icon(
                Icons.person,
                color: Colors.black,
              ))
        ],
      ),
      body: Stack(children: bgFinder()),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 89, 135, 90),
        unselectedItemColor: Colors.black,
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Story'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Ideas'),
          BottomNavigationBarItem(icon: Icon(Icons.smart_screen), label: 'AI'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'LC'),
        ],
        showUnselectedLabels: true,
      ),
      floatingActionButton: Visibility(
        visible: currentIndex == 1,
        child: FloatingActionButton(
          onPressed: () {
            singleton.setID("");
            Navigator.popAndPushNamed(context, '/draft');
          },
          backgroundColor: Colors.grey,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
