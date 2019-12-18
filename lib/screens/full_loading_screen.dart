import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            Text(
              "App made with ❤️ by",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontWeight: FontWeight.w600)),
            ),
            Image(
              width: MediaQuery.of(context).size.width / 2,
              image: AssetImage("assets/images/creatively.png"),
            ),
            SizedBox(
              height: 200.0,
            ),
            CircularProgressIndicator(),
            SizedBox(
              height: 15,
            ),
            Text("Wait, we are setting things up...")
          ],
        ),
      ),
    );
  }
}
