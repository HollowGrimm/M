import 'package:flutter/material.dart';
import 'package:meilinflutterproject/services/lc_docs.dart';
import 'package:meilinflutterproject/services/singleton.dart';

class Document extends StatefulWidget {
  const Document({super.key});

  @override
  State<Document> createState() => _DocumentState();
}

class _DocumentState extends State<Document> {
  final singleton = Singleton();
  final lcd = LCDocs();
  String key = "";
  List<Widget> body = [];

  @override
  void initState() {
    super.initState();
    key = singleton.currentDoc;

    List<String> tempSubtitles = LCDocs.indDocs[key]!.keys.toList();
    List<String> tempBodies = LCDocs.indDocs[key]!.values.toList();

    for (int i = 0; i < tempSubtitles.length; i++) {
      body.add(Text(tempSubtitles[i],
          style: const TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)));
      body.add(Text(tempBodies[i],
          style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.normal)));
      body.add(const SizedBox(height: 20));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              singleton.changenavbarIndex(3);
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
                  Text(key,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Quincento")),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: body,
                      // children: <Widget>[
                      //   Container(
                      //     height: 50,
                      //     color: Colors.black,
                      //     child: const Center(child: Text('Entry A')),
                      //   )
                      // ]
                    ),
                  )
                ])));
  }
}
