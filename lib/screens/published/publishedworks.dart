import 'package:flutter/material.dart';
import 'package:meilinflutterproject/firebase/firebase_cloud.dart';
//import 'package:flutter_quill/flutter_quill.dart';
import 'package:meilinflutterproject/services/singleton.dart';

class PublishedWork extends StatefulWidget {
  const PublishedWork({super.key});

  @override
  State<PublishedWork> createState() => _PublishedWorkState();
}

class _PublishedWorkState extends State<PublishedWork> {
  final singleton = Singleton();
  late String title;
  late String author;
  late String date; //day, month, year
  late String content;

  late String draftID;

  @override
  void initState() {
    super.initState();
    draftID = singleton.id;
    if (draftID != "") {
      title = singleton.published[0];
      author = singleton.published[1];
      date = singleton.published[2];
      content = singleton.published[3];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              singleton.changenavbarIndex(0);
              Navigator.popAndPushNamed(context, '/navbar');
            },
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
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
                  SizedBox(
                    height: 600,
                    child: SingleChildScrollView(
                      child: Text(content,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // FirebaseCloud().getFeedback(draftID);
                          Navigator.popAndPushNamed(context, '/feedbackView');
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
                          // FirebaseCloud().getFeedback(draftID);
                          Navigator.popAndPushNamed(context, '/feedbackSurvey');
                        },
                        child: const Text(
                          'Feedback Survey',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.popAndPushNamed(context, '/discussion');
                      },
                      child: const Text(
                        'View Discussion',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ])));
  }
}
