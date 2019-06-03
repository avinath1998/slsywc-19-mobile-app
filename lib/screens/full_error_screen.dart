import 'package:flutter/material.dart';

class FullErrorScreen extends StatefulWidget {
  @override
  _FullErrorScreenState createState() => _FullErrorScreenState();
}

class _FullErrorScreenState extends State<FullErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Error Screen"),
      ),
    );
  }
}
