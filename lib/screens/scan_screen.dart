import 'package:barcode_scan/barcode_scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slsywc19/blocs/auth/auth_bloc.dart';
import 'package:slsywc19/blocs/scan/scan_bloc.dart';
import 'package:slsywc19/blocs/scan/scan_state.dart';
import 'package:slsywc19/models/code.dart';
import 'package:slsywc19/models/sywc_colors.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';

class ScanScreen extends StatefulWidget {
  String _code;
  CurrentUser _currentUser;

  ScanScreen(this._code, this._currentUser);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  ScanBloc _scanBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scanBloc = new ScanBloc(IEEEDataRepository.get(), widget._currentUser);
    _scanBloc.submitCode(widget._code);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return BlocProvider<ScanBloc>(
      builder: (context) => _scanBloc,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: BlocBuilder(
            bloc: _scanBloc,
            builder: (context, state) {
              print(state.toString());
              if (state is UpdatedDataState) {
                print(state.code);
                if (state.code is PointsCode) {
                  return _buildSuccessScreen(state.code);
                } else if (state.code is FriendCode) {
                  return _buildSuccessFriendScreen(state.code);
                }
              } else if (state is UpdatingDataState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ErrorUpdatingDataState) {
                return _buildErrorScreen(
                    "Error updating data, make sure this device is connected to the internet.");
              } else if (state is InvalidScanState) {
                return _buildErrorScreen("The scanned qr code is invalid.");
              }
              return _buildErrorScreen("An unknown error has occured.");
            },
          )),
    );
  }

  Widget _buildSuccessScreen(PointsCode state) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: SYWCColors.PrimaryColor,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Congratulations!\n",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.normal))),
                      TextSpan(
                          text: "${widget._currentUser.displayName}",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold)))
                    ])),
                SizedBox(
                  height: 50.0,
                ),
                Container(
                  padding: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Icon(
                    Icons.check,
                    size: 80.0,
                    color: SYWCColors.PrimaryColor,
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  "You've just earned ${state.pointsEarned} points.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0)),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Text("On the prizes tab, use these points to redeem prizes.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 17.0))),
                SizedBox(
                  height: 40.0,
                ),
                RaisedButton(
                  color: Colors.white,
                  child: Text(
                    "Back",
                    style: TextStyle(
                        color: SYWCColors.PrimaryColor, fontSize: 15.0),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessFriendScreen(FriendCode state) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text: "${state.friend.displayName}\n",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold))),
                      TextSpan(
                          text: "has been added as a contact.",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.normal)))
                    ])),
                SizedBox(
                  height: 35.0,
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: state.friend.photo,
                        placeholder: (context, val) {
                          return Container(
                            height: 250.0,
                            width: 150.0,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        imageBuilder: (context, provider) {
                          return Container(
                            height: 250.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                image: DecorationImage(
                                    image: provider, fit: BoxFit.cover)),
                          );
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: SYWCColors.PrimaryColor,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.check,
                          size: 50.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35.0,
                ),
                Text(
                  "You'll be able to see your new contact in the contacts tab.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 17.0)),
                ),
                SizedBox(
                  height: 40.0,
                ),
                RaisedButton(
                  color: SYWCColors.PrimaryColor,
                  child: Text(
                    "Back",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String errorMsg) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.red,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text: "An error has occured.\n",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.normal))),
                      TextSpan(
                          text: "Something went wrong.",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold)))
                    ])),
                SizedBox(
                  height: 100.0,
                ),
                Container(
                  padding: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Icon(
                    Icons.error,
                    size: 80.0,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  height: 100.0,
                ),
                Text("An error has occured reading that qr code, try again.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0))),
                SizedBox(
                  height: 40.0,
                ),
                Text("$errorMsg",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 17.0))),
                SizedBox(
                  height: 40.0,
                ),
                RaisedButton(
                  color: Colors.white,
                  child: Text(
                    "Back",
                    style: TextStyle(
                        color: SYWCColors.PrimaryColor, fontSize: 15.0),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
