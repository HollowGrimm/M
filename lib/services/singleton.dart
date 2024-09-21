import 'dart:math';

import 'package:flutter/material.dart';
//import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase/firebase_cloud.dart';

class Singleton extends ChangeNotifier {
  static final Singleton _instance = Singleton._internal();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // passes the instantiation to the _instance object
  factory Singleton() => _instance;

  void notifyListenersSafe() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListenersSafe();
    });
  }

  String generateUID() {
    return const Uuid().v4();
  }

  // initialize our variables
  Singleton._internal();

  Future<String> getUID() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('userID')!;
  }

  Future setUID() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('userID', generateUID());
  }

  List<String> adjective = [
    "Alive",
    "Better",
    "Careful",
    "Clever",
    "Famous",
    "Gifted",
    "Helpful",
    "Important",
    "Odd",
    "Powerful",
    "Shy",
    "Aggressive",
    "Agreeable",
    "Ambitious",
    "Brave",
    "Calm",
    "Delightful",
    "Eager",
    "Faithful",
    "Gentle",
    "Happy",
    "Jolly",
    "Kind",
    "Lively",
    "Nice"
  ];

  List<String> names = [
    "Drama",
    "Fable",
    "Fairy Tale",
    "Fantasy",
    "Fiction",
    "Fiction In Verse",
    "Folklore",
    "Historical Fiction",
    "Horror",
    "Humor",
    "Legend",
    "Mystery",
    "Mythology",
    "Poetry",
    "Realistic Fiction",
    "Science Fiction",
    "Short Story",
    "Tall Tale",
    "Biography/Autobiography",
    "Essay",
    "Narrative Nonfiction",
    "Nonfiction"
  ];

  List<String> profile = ["", "", "Bio/Description"];

  String randomName() {
    String name1 = adjective[Random().nextInt(adjective.length)];
    String name2 = names[Random().nextInt(names.length)];
    profile[1] = "$name1 $name2";
    return "$name1 $name2";
  }

  List<String> idea = [];
  List<String> published = [];

  String id = "";
  int navbarIndex = 0;

  Map<String, List<List<int>>> feedBackSurveyResults = {
    //"key" : [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]
  };

  List<String> userCommentIDs = [];
  List<String> userIdeasIDs = [];
  List<String> userpublishedIDs = [];

  void setUserCommentIDs(List<String> i) {
    userCommentIDs.clear();
    userCommentIDs.addAll(i);
    notifyListenersSafe();
  }

  void setUserIdeasIDs(List<String> i) {
    userIdeasIDs.clear();
    userIdeasIDs.addAll(i);
    notifyListenersSafe();
  }

  void setUserpublishedIDs(List<String> i) {
    userpublishedIDs.clear();
    userpublishedIDs.addAll(i);
    notifyListenersSafe();
  }

  void changenavbarIndex(i) {
    navbarIndex = i;
    notifyListenersSafe();
  }

  void updateProfile(image, name, bio) async {
    profile.clear();
    profile.addAll([image, name, bio]);
    await FirebaseCloud().updateUser(await getUID(), name, bio, image);
    notifyListenersSafe();
  }

  Future<void> saveIdea(String title, String author, String date, String body,
      String feedback, bool publishCheck) async {
    FirebaseCloud()
        .createWriting(feedback, date, publishCheck, body, title, author);
    setUserIdeasIDs(await FirebaseCloud().getList('ideasList'));
  }

  Future<void> updateIdea(String draftID, String title, String author,
      String date, String body, String feedback) async {
    bool publishCheck = userpublishedIDs.contains(draftID);
    FirebaseCloud()
        .updateWriting(draftID, feedback, date, publishCheck, body, title);
    setUserIdeasIDs(await FirebaseCloud().getList('ideasList'));
  }

  Future<void> publishIdea(draftID, title, author, date, body, feedback) async {
    userpublishedIDs.add(draftID);
    if (userIdeasIDs.contains(draftID)) {
      updateIdea(draftID, title, author, date, body, feedback);
    } else {
      saveIdea(title, author, date, body, feedback, true);
    }
    setUserpublishedIDs(await FirebaseCloud().getList('publishedList'));
  }

  void tallyFeedbackResults(key, yes, no) {
    List<List<int>> tempList = [
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0]
    ];

    if (feedBackSurveyResults.containsKey(key)) {
      tempList = feedBackSurveyResults[key]!;
    }

    for (int i = 0; i < 6; i++) {
      if (yes[i][0]) {
        tempList[i][0] += 1;
      }
      if (no[i][0]) {
        tempList[i][1] += 1;
      }
    }
    feedBackSurveyResults.addAll({key: tempList});
  }

  void setID(draftID) {
    id = draftID;
    notifyListenersSafe();
  }

  void setIdea(List<String> i) {
    idea.clear();
    idea.addAll(i);
    notifyListenersSafe();
  }

  void setPublished(List<String> p) {
    published.clear();
    published.addAll(p);
    notifyListenersSafe();
  }

  List<String> commentIDs = [];

  void setCommentIDs(List<String> c) {
    commentIDs.clear();
    commentIDs.addAll(c);
    notifyListenersSafe();
  }

  Future<void> deleteAccount() async {
    for (var i in userIdeasIDs) {
      await FirebaseCloud().deleteDocument("ideas_published", i);
    }

    for (var i in userpublishedIDs) {
      await FirebaseCloud().deleteDocument("ideas_published", i);
    }

    for (var i in userCommentIDs) {
      await FirebaseCloud().deleteDocument("comments", i);
    }

    await FirebaseCloud().deleteDocument("user", await getUID());

    await SharedPreferences.getInstance().then((prefs) async {
      await prefs.clear();
    });
  }
}
