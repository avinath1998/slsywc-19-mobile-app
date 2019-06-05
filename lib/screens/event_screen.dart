import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:slsywc19/models/event.dart';
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: widget.event.image,
                  placeholder: (context, url) {
                    return CircularProgressIndicator();
                  },
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15, left: 10.0),
                      child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          child: Center(
                            child: Text(
                              widget.event.getTimeRangeAsString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
            Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      widget.event.title,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    Card(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.pin_drop),
                          ],
                        )
                      ],
                    ))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
