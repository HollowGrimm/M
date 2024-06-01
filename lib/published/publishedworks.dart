import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:meilinflutterproject/singleton.dart';

import 'feedbacksurvey.dart';
import 'feedbackview.dart';

class PublishedWork extends StatefulWidget {
  const PublishedWork({super.key});

  @override
  State<PublishedWork> createState() => _PublishedWorkState();
}

class _PublishedWorkState extends State<PublishedWork> {
  final singleton = Singleton();
  String title = "Draft";
  String author = "Meilin S.";
  late String date; //day, month, year

  late QuillController contentController;

  late String draftKey;

  @override
  void initState() {
    super.initState();
    draftKey = singleton.key;
    if (draftKey != "") {
      title = singleton.published[draftKey]![0];
      author = singleton.published[draftKey]![1];
      date = singleton.published[draftKey]![2];
      contentController = singleton.contentPublished[draftKey]!;
    }
    print(singleton.contentIdea);
    print(singleton.contentPublished);
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
                  Text(title,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.normal)),
                  Text("By: $author",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.normal)),
                  Text(date,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.normal)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: QuillEditor.basic(
                      configurations: QuillEditorConfigurations(
                          controller: contentController,
                          readOnly: true,
                          showCursor: false),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const FeedbackView(),
                      ));
                    },
                    child: const Text(
                      'View Feedback',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Survey(),
                      ));
                    },
                    child: const Text(
                      'Feedback Survey',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]))));
  }
}
