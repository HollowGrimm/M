import 'package:flutter/material.dart';
import 'package:mayflutterproject/navbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () async {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Navbar(),
      ));
    });
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/Instagram-Logo.png'),
          const SizedBox(height: 10),
          const Text(
            'Community Editor',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          )
        ],
      )),
    );
  }
}
