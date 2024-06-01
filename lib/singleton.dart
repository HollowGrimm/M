import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Singleton extends ChangeNotifier {
  static final Singleton _instance = Singleton._internal();

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
  Map<String, List<String>> ideas = {
    //["title", "author", 'date', 'body', 'feedback']
  };
  List<String> ideaKeys = [];

  Map<String, List<String>> published = {
    //["title", "author", 'date', 'body', 'feedback', 'image']
  };
  List<String> publishedKeys = [];

  Map<String, QuillController> contentIdea = {};
  Map<String, QuillController> contentPublished = {};
  String key = "";

  void saveIdea(draftKey, title, author, date, body, feedback) {
    List<String> tempList = [
      title,
      author,
      date,
      body.document.toPlainText(),
      feedback
    ];
    ideaKeys.add(draftKey);
    contentIdea.addAll({draftKey: body});
    ideas.addAll({draftKey: tempList});
    setWriting();
    notifyListenersSafe();
  }

  void updateIdea(draftKey, title, author, date, body, feedback) {
    List<String> tempList = [
      title,
      author,
      date,
      body.document.toPlainText(),
      feedback
    ];
    contentIdea[draftKey] = body;
    ideas[draftKey] = tempList;
    setWriting();
    notifyListenersSafe();
  }

  void publishIdea(draftKey, title, author, date, body, feedback) {
    if (publishedKeys.contains(draftKey)) {
      //Already published
      updateIdea(draftKey, title, author, date, body, feedback);
      published[draftKey] = ideas[draftKey]!;
      contentPublished[draftKey] = body;
    } else if (ideaKeys.contains(draftKey)) {
      //Idea exists
      updateIdea(draftKey, title, author, date, body, feedback);
      publishedKeys.add(draftKey);
      published.addAll({draftKey: ideas[draftKey]!});
      contentPublished.addAll({draftKey: body});
    } else {
      // No idea or published
      draftKey = generateUID();
      saveIdea(draftKey, title, author, date, body, feedback);
      publishedKeys.add(draftKey);
      published.addAll({draftKey: ideas[draftKey]!});
      contentPublished.addAll({draftKey: body});
    }
    //TODO: Update firebase
  }

  void setKey(draftKey) {
    key = draftKey;
    notifyListenersSafe();
  }

  void setWriting() async {
    await SharedPreferences.getInstance().then((prefs) async {
      if (ideaKeys.isNotEmpty) {
        await prefs.setStringList('saved idea', ideaKeys);
        for (int i = 0; i < ideaKeys.length; i++) {
          await prefs.setStringList(ideaKeys[i], ideas[ideaKeys[i]]!);
        }
      }
    });
  }

  void getWriting() async {
    await SharedPreferences.getInstance().then((prefs) async {
      if (prefs.containsKey('saved idea')) {
        ideaKeys = prefs.getStringList('saved idea')!;
        for (int i = 0; i < ideaKeys.length; i++) {
          ideas.addAll({ideaKeys[i]: prefs.getStringList(ideaKeys[i])!});
        }
      }
    });
  }
}
