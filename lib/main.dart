import 'package:flutter/material.dart';
import 'package:slsywc19/screens/root_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SYWC',
      theme: ThemeData(
          primarySwatch: Colors.green, accentColor: Colors.lightGreen),
      home: RootScreen(),
    );
  }
}
