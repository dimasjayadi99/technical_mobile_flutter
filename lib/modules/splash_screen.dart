import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();

}

class SplashScreenState extends State<SplashScreen>{

  final int time = 2000;

  @override
  void initState() {
    super.initState();
    directPage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void directPage() async {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, "/home");
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Text("Savoria", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
      ),
    );
  }

}