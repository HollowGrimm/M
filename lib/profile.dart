import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<List<Widget>> published = [
    [const Text("Published Work 1"), const Text("Author/Date")],
    [const Text("Published Work 2"), const Text("Author/Date")],
    [const Text("Published Work 3"), const Text("Author/Date")],
    [const Text("Published Work 4"), const Text("Author/Date")]
  ];
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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    ClipOval(
                      child: IconButton(
                          onPressed: null,
                          iconSize: 50.0,
                          icon: Icon(
                            Icons.person,
                            color: Colors.black,
                          )),
                    ),
                    Text("My Username Here",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.normal)),
                  ],
                ),
                const SizedBox(height: 50),
                const Text("Bio/Description", //TODO: editable bio
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.normal)),
                const SizedBox(height: 50),
                Expanded(
                    child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: published.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.white70,
                                offset: Offset(
                                  5.0,
                                  5.0,
                                ),
                                blurRadius: 2.5,
                                spreadRadius: 2.0,
                              ), //BoxShadow
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(0.0, 0.0),
                                blurRadius: 0.0,
                                spreadRadius: 0.0,
                              ), //BoxShadow
                            ],
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              published[index][0],
                              const SizedBox(height: 25),
                              published[index][1],
                            ],
                          ),
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ))
              ]),
        ));
  }
}
