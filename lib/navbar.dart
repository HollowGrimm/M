import 'package:flutter/material.dart';
import 'package:mayflutterproject/ideas/draft.dart';
import 'package:mayflutterproject/navbar/ai.dart';
import 'package:mayflutterproject/navbar/ideas.dart';
import 'package:mayflutterproject/navbar/learningCenter.dart';
import 'package:mayflutterproject/navbar/story.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int currentIndex = 0;
  bool onIdeaTab = false;

  final List<Widget> tabs = const [
    StoryScreen(),
    IdeasScreen(),
    AIScreen(),
    LearningCenterScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Text("Community Editor",
            style: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold)),
        leadingWidth: 180,
        actions: const [
          IconButton(onPressed: null, iconSize: 50.0, icon: Icon(Icons.person))
        ],
      ),
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
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
        child: Ink(
          decoration:
              const ShapeDecoration(color: Colors.grey, shape: CircleBorder()),
          child: IconButton(
            iconSize: 35,
            icon: const Icon(Icons.add),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const DraftScreen(),
              ));
            },
          ),
        ),
      ),
    );
  }
}
