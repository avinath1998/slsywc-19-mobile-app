import 'package:flutter/material.dart';

class FullLoadingScreen extends StatefulWidget {
  @override
  _FullLoadingScreenState createState() => _FullLoadingScreenState();
}

class _FullLoadingScreenState extends State<FullLoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              height: 15.0,
            ),
            Text("Loading....")
          ],
        ),
      ),
    );
  }
}
