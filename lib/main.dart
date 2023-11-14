import 'package:flutter/material.dart';
import 'package:ametask/home/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ametask',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
