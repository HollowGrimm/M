import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:meilinflutterproject/singleton.dart';

import 'package:intl/intl.dart';

class DraftScreen extends StatefulWidget {
  const DraftScreen({super.key});

  @override
  State<DraftScreen> createState() => _DraftScreenState();
}

class _DraftScreenState extends State<DraftScreen> {
  final singleton = Singleton();
  String title = "Draft";
  String author = "Meilin S.";
  late String date; //day, month, year
  String content = "Type something here by pressing on the quill.";
  String feedback = "I want feedback on...";
  bool titleVisible = true;
  bool minimize = true;
  bool feedbackVisible = true;

  late TextEditingController titleController;
  QuillController contentController = QuillController.basic();
  late TextEditingController feedbackController;

  late String draftKey;

  @override
  void initState() {
    super.initState();
    draftKey = singleton.key;
    if (draftKey != "") {
      title = singleton.ideas[draftKey]![0];
      author = singleton.ideas[draftKey]![1];
      contentController = singleton.contentIdea[draftKey]!;
      feedback = singleton.ideas[draftKey]![4];
    }
    titleController = TextEditingController(text: title);
    feedbackController = TextEditingController(text: feedback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
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
                              fontSize: 28,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                  Visibility(
                    visible: !titleVisible && minimize,
                    child: TextField(
                      controller: titleController,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.normal),
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
                  Visibility(
                      visible: minimize, child: const SizedBox(height: 28)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          minimize = !minimize;
                        });
                      },
                      iconSize: 25.0,
                      icon: const Icon(
                        RpgAwesome.quill_ink,
                        color: Colors.black,
                      )),
                  Visibility(
                      visible: !minimize,
                      child: Container(
                        color: const Color.fromARGB(255, 223, 220, 220),
                        child: QuillToolbar.simple(
                          configurations: QuillSimpleToolbarConfigurations(
                              controller: contentController),
                        ),
                      )),
                  //TODO: Figure out how to keep text on QuillEditor
                  Expanded(
                    child: QuillEditor.basic(
                      configurations: QuillEditorConfigurations(
                          controller: contentController,
                          readOnly: minimize,
                          placeholder: content,
                          showCursor: !minimize),
                    ),
                  ),
                  Visibility(
                      visible: minimize,
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                date = DateFormat.yMMMMd('en_US')
                                    .format(DateTime.now());
                              });
                              if (singleton.ideaKeys.contains(draftKey)) {
                                singleton.updateIdea(draftKey, title, author,
                                    date, contentController, feedback);
                              } else {
                                draftKey = singleton.generateUID();
                                singleton.saveIdea(draftKey, title, author,
                                    date, contentController, feedback);
                              }
                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                date = DateFormat.yMMMMd('en_US')
                                    .format(DateTime.now());
                              });
                              singleton.publishIdea(draftKey, title, author,
                                  date, contentController, feedback);
                            },
                            child: const Text(
                              'Publish',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )),
                  //TODO: Clears text
                  Visibility(
                      visible: minimize,
                      child: ElevatedButton(
                        onPressed: () async {},
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  Visibility(
                      visible: minimize,
                      child: ElevatedButton(
                        onPressed: () async {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext c) => AlertDialog(
                                    content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: feedbackController,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder()),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ]),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            feedback = feedbackController.text;
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ]))));
  }
}
