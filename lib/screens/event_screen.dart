import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slsywc19/models/event.dart';
import 'package:slsywc19/models/speaker.dart';
import 'package:slsywc19/models/sywc_colors.dart';
import 'package:rubber/rubber.dart';
import 'package:url_launcher/url_launcher.dart';

import '../exceptions/data_fetch_exception.dart';
import '../network/repository/ieee_data_repository.dart';

class EventScreen extends StatefulWidget {
  final Event event;

  const EventScreen({Key key, this.event}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with SingleTickerProviderStateMixin {
  RubberAnimationController _controller;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = RubberAnimationController(
        vsync: this,
        halfBoundValue: AnimationControllerValue(percentage: 0.7),
        duration: Duration(milliseconds: 50));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    print(widget.event.id);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  Center(
                    child: CachedNetworkImage(
                      width: screenSize.width,
                      fit: BoxFit.cover,
                      imageUrl: widget.event.image,
                      errorWidget: (context, url, error) {
                        return Container(
                          padding: const EdgeInsets.all(50.0),
                          child: Center(child: Icon(Icons.error)),
                        );
                      },
                      placeholder: (context, url) {
                        return Container(
                          padding: const EdgeInsets.all(50.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, left: 10.0),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Day ${widget.event.day}, ",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Text(
                                    widget.event.getTimeRangeAsString(),
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                  width: screenSize.width,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.event.title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  _buildInfoRow(
                                      Icons.location_on, widget.event.location),
                                  _buildInfoRow(Icons.today,
                                      widget.event.getDateAsString()),
                                  _buildInfoRow(Icons.access_time,
                                      widget.event.getTimeRangeAsString()),
                                ],
                              ),
                            )),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.event.desc,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 8.0, right: 8.0),
                        child: Text(
                          "Speakers",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: _buildSpeakersRow(widget.event.getSpeakers())),
                    ],
                  ))
            ],
          ),
        ));
  }

  void _showSpeakerPopup(Speaker speaker) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Container(
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(
                color: Colors.black12,
                style: BorderStyle.solid,
                width: 3.0,
              ),
            )),
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 250.0,
                        margin: const EdgeInsets.only(bottom: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            image: CachedNetworkImageProvider(speaker.image),
                          ),
                        ),
                      ),
                      Text(
                        speaker.name,
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: SYWCColors.PrimaryColor),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Divider(
                            color: Colors.black,
                          ),
                          width: 30.0,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          speaker.desc,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            speaker.socialLinks.length > 0 &&
                    speaker.socialLinks['linkedIn'] != null &&
                    speaker.socialLinks['linkedIn']
                        .toLowerCase()
                        .contains("linkedin")
                ? FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    color: SYWCColors.PrimaryColor,
                    child: Text(
                      "See LinkedIn",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (speaker.socialLinks['linkedIn'] != null) {
                        launch(speaker.socialLinks['linkedIn']);
                      }
                    })
                : Container(),
            FlatButton(
              child: Text(
                "Close",
                style: TextStyle(color: SYWCColors.PrimaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSpeakersRow(List<Speaker> speakers) {
    final List<Widget> rows = new List();
    speakers.forEach((speaker) {
      Widget widget = GestureDetector(
        onTap: () async {
          print(speaker.name);
          print(speaker.id);
          if (speaker.id != "g8CQ0cB8c8eycKyygC5I") {
            try {
              showDialog(
                context: context,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  title: Container(
                    width: 100.0,
                    height: 230.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(speaker.image),
                      ),
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Retreiving ${speaker.name}'s details",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      CircularProgressIndicator()
                    ],
                  ),
                ),
              );
              Speaker speakerWhole =
                  await IEEEDataRepository.get().fetchSpeaker(speaker.id);
              Navigator.pop(context);
              if (speakerWhole != null &&
                  speakerWhole.image != null &&
                  speakerWhole.desc != null) {
                _showSpeakerPopup(speakerWhole);
              } else {
                Fluttertoast.showToast(
                    msg: "No speaker details found.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.pop(context);
              }
            } on DataFetchException catch (e) {
              print(e.msg);
              Fluttertoast.showToast(
                  msg: "No speaker details found.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.pop(context);
            }
          }
        },
        child: Container(
            margin: const EdgeInsets.only(top: 5.0, left: 10.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(speaker.image),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    speaker.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )),
      );
      rows.add(widget);
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              icon,
              color: SYWCColors.PrimaryColor,
            ),
          ),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0),
            ),
          )
        ],
      ),
    );
  }
}
