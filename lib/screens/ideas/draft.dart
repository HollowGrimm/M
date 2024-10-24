import 'package:flutter/material.dart';
import 'package:meilinflutterproject/services/singleton.dart';

import 'package:intl/intl.dart';

class DraftScreen extends StatefulWidget {
  const DraftScreen({super.key});

  @override
  State<DraftScreen> createState() => _DraftScreenState();
}

class _DraftScreenState extends State<DraftScreen> {
  final singleton = Singleton();
  String title = "Draft";
  String author = "";
  late String date; //day, month, year
  String content = "Type something here.";
  String feedback = "I want feedback on...";
  bool titleVisible = true;
  bool contentVisible = true;
  bool minimize = true;
  bool feedbackVisible = true;
  double textBoxSize = 600;
  List<String> tempGenreList = [];
  List<Widget> genres = [];

  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController feedbackController;

  late String draftID;

  @override
  void initState() {
    super.initState();

    draftID = singleton.id;
    author = singleton.profile[1];

    if (draftID != "") {
      title = singleton.idea[0];
      content = singleton.idea[3];
      feedback = singleton.idea[4];
    }

    titleController = TextEditingController(text: title);
    contentController = TextEditingController(text: content);
    feedbackController = TextEditingController(text: feedback);

    tempGenreList = singleton.allGenres;
  }

  void addGenre(String genre) {
    setState(() {
      genres.add(ElevatedButton(
          onPressed: () {
            setState(() {
              tempGenreList.add(genre);
              genres.removeAt(genres.length);
            });
          },
          child: Text(genre)));
    });
  }

  //TODO: Remove minize variable
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              singleton.changenavbarIndex(1);
              Navigator.popAndPushNamed(context, '/navbar');
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Visibility(
                        visible: titleVisible && minimize,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              titleVisible = false;
                            });
                          },
                          child: Text(title,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Visibility(
                        visible: !titleVisible && minimize,
                        child: TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 45,
                              fontWeight: FontWeight.bold),
                          onSubmitted: (text) {
                            setState(() {
                              title = titleController.text;
                              titleVisible = true;
                            });
                          },
                          onTapOutside: (event) {
                            setState(() {
                              title = titleController.text;
                              titleVisible = true;
                            });
                          },
                        ),
                      ),
                      Visibility(
                          visible: minimize,
                          child: Text("By: $author",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal))),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          DropdownButton<String>(
                            value: tempGenreList[
                                0], // Initially selected item (can be null)
                            onChanged: (String? newValue) {
                              setState(() {
                                addGenre(newValue!);
                                tempGenreList.remove(newValue);
                              });
                            },
                            items: tempGenreList
                                .map<DropdownMenuItem<String>>((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                          ),
                          Row(
                            children: genres,
                          )
                        ],
                      ),
                      Visibility(
                          visible: minimize, child: const SizedBox(height: 28)),
                      Visibility(
                        visible: contentVisible && minimize,
                        child: SizedBox(
                            height: textBoxSize,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  contentVisible = false;
                                });
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)),
                                  constraints:
                                      BoxConstraints(maxHeight: textBoxSize),
                                  child: SingleChildScrollView(
                                    child: Text(content,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal)),
                                  )),
                            )),
                      ),
                      Visibility(
                        visible: !contentVisible && minimize,
                        child: SizedBox(
                          height: textBoxSize,
                          child: TextField(
                            controller: contentController,
                            maxLines: null,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.0),
                            )),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                            onSubmitted: (text) {
                              setState(() {
                                content = contentController.text;
                                contentVisible = true;
                              });
                            },
                            onTapOutside: (event) {
                              setState(() {
                                content = contentController.text;
                                contentVisible = true;
                              });
                            },
                          ),
                        ),
                      ),
                      Visibility(
                          visible: minimize,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    date = DateFormat.yMMMMd('en_US')
                                        .format(DateTime.now());
                                  });
                                  if (singleton.userIdeasIDs
                                      .contains(draftID)) {
                                    singleton.updateIdea(draftID, title, author,
                                        date, content, feedback);
                                  } else {
                                    singleton.saveIdea(
                                      title,
                                      author,
                                      date,
                                      content,
                                      feedback,
                                      singleton.userpublishedIDs
                                          .contains(draftID),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    date = DateFormat.yMMMMd('en_US')
                                        .format(DateTime.now());
                                  });
                                  singleton.publishIdea(draftID, title, author,
                                      date, content, feedback);
                                },
                                child: const Text(
                                  'Publish',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Visibility(
                                  visible: minimize,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        title = "Draft";
                                        content = "Type something...";
                                        feedback = "I want feedback on...";
                                        titleController =
                                            TextEditingController(text: title);
                                        contentController =
                                            TextEditingController(
                                                text: content);
                                        feedbackController =
                                            TextEditingController(
                                                text: feedback);
                                      });
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              Visibility(
                                  visible: minimize,
                                  child: Center(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        showDialog<String>(
                                            context: context,
                                            builder: (BuildContext c) =>
                                                AlertDialog(
                                                  content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextField(
                                                          controller:
                                                              feedbackController,
                                                          decoration:
                                                              const InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder()),
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ]),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          feedback =
                                                              feedbackController
                                                                  .text;
                                                        });
                                                        Navigator.pop(c, 'Ok');
                                                      },
                                                      child: const Text('Ok'),
                                                    ),
                                                  ],
                                                ));
                                      },
                                      child: const Text(
                                        'Feedback',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            ],
                          )),
                    ]))),
          ),
        ));
  }
}
