import 'package:flutter/material.dart';

import '../../services/singleton.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  final singleton = Singleton();
  String key = '';
  List<List<String>> feedbackQuestions = [
    [
      "Did the author achieve their goal with their piece? What can they improve?",
      '0',
      '0'
    ],
    [
      "Did the structure of the writing (order of events) make sense?",
      '0',
      '0'
    ],
    ["Did you understand the central idea of this piece?", '0', '0'],
    [
      "Did the structure of the writing (order of events) make sense?",
      '0',
      '0'
    ],
    [
      "Did the author add enough details for you to connect with the piece?",
      '0',
      '0'
    ],
    ["How was the tone of the piece?", '0', '0']
  ];

  @override
  void initState() {
    super.initState();
    key = singleton.id;
    if (singleton.feedBackSurveyResults.isNotEmpty) {
      for (int i = 0; i < 6; i++) {
        feedbackQuestions[i][1] =
            singleton.feedBackSurveyResults[key]![i][0].toString();
        feedbackQuestions[i][2] =
            singleton.feedBackSurveyResults[key]![i][1].toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/publishedWork');
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
                  const Text(
                    'Feedback',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                      child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: feedbackQuestions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.black,
                        )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(feedbackQuestions[index][0],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal)),
                            ),
                            Text('Yes ${feedbackQuestions[index][1]}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal)),
                            Text('No ${feedbackQuestions[index][2]}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  )),
                ]))));
  }
}
