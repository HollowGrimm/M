import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meilinflutterproject/services/singleton.dart';
import 'package:restart_app/restart_app.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final singleton = Singleton();
  String image = "";
  String name = "";
  String bio = "";

  bool nameVisible = true;
  bool bioVisible = true;

  late TextEditingController nameController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    image = singleton.profile[0];
    name = singleton.profile[1];
    bio = singleton.profile[2];

    nameController = TextEditingController(text: name);
    bioController = TextEditingController(text: bio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
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
                Row(
                  children: [
                    ClipOval(
                      child: IconButton(
                          onPressed: () {
                            singleton.updateProfile(image, name, bio);
                          },
                          iconSize: 50.0,
                          icon: const Icon(
                            Icons.person,
                            color: Colors.black,
                          )),
                    ),
                    Visibility(
                      visible: !nameVisible,
                      child: SizedBox(
                        width: 300,
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.normal),
                          onSubmitted: (text) {
                            setState(() {
                              name = nameController.text;
                              nameVisible = true;
                              singleton.updateProfile(image, name, bio);
                            });
                          },
                          onTapOutside: (event) {
                            setState(() {
                              name = nameController.text;
                              nameVisible = true;
                              singleton.updateProfile(image, name, bio);
                            });
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: nameVisible,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            nameVisible = false;
                          });
                        },
                        child: Text(name,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Visibility(
                  visible: !bioVisible,
                  child: TextField(
                    controller: bioController,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                    onSubmitted: (text) {
                      setState(() {
                        bio = bioController.text;
                        bioVisible = true;
                        singleton.updateProfile(image, name, bio);
                      });
                    },
                    onTapOutside: (event) {
                      setState(() {
                        bio = bioController.text;
                        bioVisible = true;
                        singleton.updateProfile(image, name, bio);
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: bioVisible,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        bioVisible = false;
                      });
                    },
                    child: Text(bio,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.normal)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext c) => AlertDialog(
                              content: const Text(
                                  'Press \'Confirm\' to delete your account'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    await singleton.deleteAccount();
                                    Restart.restartApp();
                                  },
                                  child: const Text('Confirm'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(c, 'Cancel');
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ],
                            ));
                  },
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('ideas_published')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Error');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          documents = snapshot.data!.docs;
                      final filteredDocuments = documents
                          .where((doc) =>
                              singleton.userpublishedIDs.contains(doc.id))
                          .toList();

                      return Expanded(
                        child: filteredDocuments
                                .isEmpty // Check if the data source is empty
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Publish An Idea",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 50),
                                  ],
                                ),
                              )
                            : Expanded(
                                child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                itemCount: filteredDocuments.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final itemData = filteredDocuments[index];
                                  return Card(
                                    child: Container(
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
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              Text(itemData['title']),
                                              const SizedBox(height: 25),
                                              Text(
                                                  "${itemData['username']} / ${itemData['modifiedDate']}"),
                                            ],
                                          ),
                                        )),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                              )),
                      );
                    })
              ]),
        ));
  }
}
