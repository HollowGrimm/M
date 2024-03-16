import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class DraftScreen extends StatefulWidget {
  const DraftScreen({super.key});

  @override
  State<DraftScreen> createState() => _DraftScreenState();
}

class _DraftScreenState extends State<DraftScreen> {
  String title = "Draft";
  String author = "Meilin S.";
  String content =
      "Lorem ipsum dolor sit amet,onsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam Lorem ipsum dolor sit amet,onsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniamLorem ipsum dolor sit amet,onsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniamLorem ipsum dolor sit amet,onsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam. Lorem ipsum dolor sit amet,onsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniamLorem ipsum dolor sit amet,onsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniamLorem ipsum dolor sit amet,onsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniamLorem ipsum dolor sit amet,onsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam";
  String feedback = "I want feedback on...";
  bool titleVisible = true;
  bool minimize = true;
  bool feedbackVisible = true;

  late TextEditingController titleController;

  QuillController contentController = QuillController.basic();
  late TextEditingController feedbackController;

  @override
  void initState() {
    super.initState();
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
                      //TODO: Change to dynamic icon arrows
                      icon: const Icon(
                        Icons.edit,
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
                          placeholder: content),
                    ),
                  ),
                  Visibility(
                      visible: minimize,
                      child: Row(
                        children: [
                          //TODO: Saves text
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                content = contentController.toString();
                              });
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
                          //TODO: Sends data to story screen and saves text
                          ElevatedButton(
                            onPressed: () async {},
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
                              builder: (BuildContext context) => AlertDialog(
                                    content: Column(children: [
                                      Visibility(
                                        visible: feedbackVisible,
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              titleVisible = false;
                                            });
                                          },
                                          child: Text(feedback,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ),
                                      ),
                                      Visibility(
                                        visible: !feedbackVisible,
                                        child: TextField(
                                          controller: feedbackController,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder()),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                          onSubmitted: (text) {
                                            setState(() {
                                              feedbackVisible = true;
                                            });
                                          },
                                          onTapOutside: (event) {
                                            setState(() {
                                              feedbackVisible = true;
                                            });
                                          },
                                        ),
                                      ),
                                    ]),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            feedback = titleController.text;
                                          });
                                          Navigator.of(context).pop();
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
