import 'package:flutter/material.dart';
import 'package:meilinflutterproject/ideas/draft.dart';
import 'package:meilinflutterproject/navbar/ai.dart';
import 'package:meilinflutterproject/navbar/ideas.dart';
import 'package:meilinflutterproject/navbar/learningCenter.dart';
import 'package:meilinflutterproject/navbar/story.dart';
import 'package:meilinflutterproject/profile.dart';

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Community Editor",
            style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        leadingWidth: 180,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ));
              },
              iconSize: 50.0,
              icon: const Icon(
                Icons.person,
                color: Colors.black,
              ))
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
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const DraftScreen(),
            ));
          },
          backgroundColor: Colors.grey,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
