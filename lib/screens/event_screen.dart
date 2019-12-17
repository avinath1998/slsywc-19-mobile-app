import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slsywc19/models/event.dart';
import 'package:slsywc19/models/speaker.dart';
import 'package:slsywc19/models/sywc_colors.dart';
import 'package:rubber/rubber.dart';

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

  Widget _buildSpeakersRow(List<Speaker> speakers) {
    final List<Widget> rows = new List();
    speakers.forEach((speaker) {
      Widget widget = Container(
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
          ));
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
          Icon(
            icon,
            color: SYWCColors.PrimaryColor,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0),
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
