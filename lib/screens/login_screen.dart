import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slsywc19/blocs/auth/auth_bloc.dart';
import 'package:slsywc19/models/sywc_colors.dart';

class LoginScreen extends StatefulWidget {
  final String errorMsg;
  final bool isLoading;

  const LoginScreen({Key key, this.errorMsg, this.isLoading = false})
      : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              height: screenSize.height,
              child: Image(
                image: AssetImage('assets/images/login_bg_cropped.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              )),
          Container(
            height: screenSize.height,
            color: Colors.black45,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Container(
                      padding: const EdgeInsets.all(30.0),
                      child: Image(
                          fit: BoxFit.contain,
                          image: AssetImage(
                              'assets/images/SLSYWC19Logo-Light.png'))),
                ),
                Flexible(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 70.0),
                            width: screenSize.width,
                            child: !widget.isLoading
                                ? OutlineButton(
                                    borderSide: BorderSide(
                                      color: SYWCColors
                                          .PrimaryColor, //Color of the border
                                      style: BorderStyle
                                          .solid, //Style of the border
                                      width: 2.5, //width of the border
                                    ),
                                    child: Container(
                                      child: Text(
                                        "Sign In",
                                        style: GoogleFonts.poppins(
                                            textStyle:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    onPressed: () {
                                      BlocProvider.of<AuthBloc>(context)
                                          .signIn();
                                    },
                                  )
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      CircularProgressIndicator()
                                    ],
                                  )),
                        widget.errorMsg != null
                            ? Container(
                                margin: const EdgeInsets.only(top: 20.0),
                                child: Text(
                                  widget.errorMsg,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      textStyle:
                                          TextStyle(color: Colors.white)),
                                ),
                              )
                            : Container(),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
