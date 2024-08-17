import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meilinflutterproject/firebase/firebase_cloud.dart';
import 'package:meilinflutterproject/services/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase/firebase_options.dart';
import 'services/singleton.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final singleton = Singleton();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (prefs.containsKey("userID")) {
    FirebaseCloud().getUser(await singleton.getUID());
  } else {
    singleton.setUID();
    String username = singleton.randomName();
    FirebaseCloud().createUser(
        await singleton.getUID(), username, "Bio/Description", '', [], [], []);
    FirebaseCloud().getUser(await singleton.getUID());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routes: screenRoutes,
    );
  }
}
