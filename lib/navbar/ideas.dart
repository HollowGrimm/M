import 'package:flutter/material.dart';

class IdeasScreen extends StatefulWidget {
  const IdeasScreen({super.key});

  @override
  State<IdeasScreen> createState() => _IdeasScreenState();
}

class _IdeasScreenState extends State<IdeasScreen> {
  List<List<Widget>> idea = [
    [
      const Text("Topic 1"),
      const Text(
          "Lorem ipsum dolor sit amet,onsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,")
    ],
    [
      const Text("Topic 2"),
      const Text(
          "Lorem ipsum dolor sit amet,onsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,")
    ],
    [
      const Text("Topic 3"),
      const Text(
          "Lorem ipsum dolor sit amet,onsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,")
    ],
    [
      const Text("Topic 4"),
      const Text(
          "Lorem ipsum dolor sit amet,onsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,")
    ],
    [
      const Text("Topic 5"),
      const Text(
          "Lorem ipsum dolor sit amet,onsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,")
    ]
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("My Ideas",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.normal)),
            Expanded(
                child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: idea.length,
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
                          idea[index][0],
                          const SizedBox(height: 25),
                          idea[index][1],
                        ],
                      ),
                    ));
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ))
          ]),
    );
  }
}
