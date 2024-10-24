import 'package:flutter/material.dart';
import 'package:meilinflutterproject/firebase/firebase_cloud.dart';

import '../../services/singleton.dart';

class Survey extends StatefulWidget {
  const Survey({super.key});

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  final singleton = Singleton();
  String key = '';
  List<String> feedbackQuestions = [
    "Did the author achieve their goal with their piece? What can they improve?",
    "Did the structure of the writing (order of events) make sense?",
    "Did you understand the central idea of this piece?",
    "Did the structure of the writing (order of events) make sense?",
    "Did the author add enough details for you to connect with the piece?",
    "How was the tone of the piece?"
  ];
  List<List<IconData>> yesOrNoIcons = [];
  List<List<bool>> yesToggle = [];
  List<List<bool>> noToggle = [];

  @override
  void initState() {
    super.initState();
    key = singleton.id;

    for (int i = 0; i < feedbackQuestions.length; i++) {
      yesOrNoIcons.add(
          [Icons.thumb_up_off_alt_outlined, Icons.thumb_down_off_alt_outlined]);
      yesToggle.add([false]);
      noToggle.add([false]);
    }
  }

  List<String> countYesResults() {
    List<String> tempYes = [];
    if (singleton.feedBackSurveyResults[0].isNotEmpty &&
        singleton.feedBackSurveyResults[1].isNotEmpty) {
      for (int i = 0; i < feedbackQuestions.length; i++) {
        if (yesToggle[0][0] == true) {
          tempYes.add((int.parse(singleton.feedBackSurveyResults[0][i]) + 1)
              .toString());
        }
      }
    } else {
      for (int i = 0; i < feedbackQuestions.length; i++) {
        if (yesToggle[0][0] == true) {
          tempYes.add("1");
        } else {
          tempYes.add("0");
        }
      }
    }

    return tempYes;
  }

  List<String> countNoResults() {
    List<String> tempNo = [];
    if (singleton.feedBackSurveyResults[0].isNotEmpty &&
        singleton.feedBackSurveyResults[1].isNotEmpty) {
      for (int i = 0; i < feedbackQuestions.length; i++) {
        if (noToggle[0][0] == true) {
          tempNo.add((int.parse(singleton.feedBackSurveyResults[0][i]) + 1)
              .toString());
        }
      }
    } else {
      for (int i = 0; i < feedbackQuestions.length; i++) {
        if (noToggle[0][0] == true) {
          tempNo.add("1");
        } else {
          tempNo.add("0");
        }
      }
    }

    return tempNo;
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
                              child: Text(feedbackQuestions[index],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('Yes',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                ToggleButtons(
                                  renderBorder: false,
                                  isSelected: yesToggle[index],
                                  onPressed: (n) {
                                    setState(() {
                                      yesToggle[index][0] = true;
                                      noToggle[index][0] = false;
                                      yesOrNoIcons[index][0] = Icons
                                          .thumb_up_off_alt_rounded; //filled thumbs up
                                      yesOrNoIcons[index][1] = Icons
                                          .thumb_down_off_alt_outlined; //unfilled thumbs down
                                    });
                                  },
                                  children: [Icon(yesOrNoIcons[index][0])],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('No',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                ToggleButtons(
                                  renderBorder: false,
                                  isSelected: noToggle[index],
                                  onPressed: (n) {
                                    setState(() {
                                      noToggle[index][0] = true;
                                      yesToggle[index][0] = false;
                                      yesOrNoIcons[index][0] = Icons
                                          .thumb_up_off_alt_outlined; //unfilled thumbs up
                                      yesOrNoIcons[index][1] = Icons
                                          .thumb_down_alt_rounded; //filled thumbs down
                                    });
                                  },
                                  children: [Icon(yesOrNoIcons[index][1])],
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  )),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseCloud().updateFeedback(
                          key, countYesResults(), countNoResults());
                      Navigator.popAndPushNamed(context, '/publishedWork');
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]))));
  }
}
