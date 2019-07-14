import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slsywc19/blocs/auth/auth_bloc.dart';
import 'package:slsywc19/blocs/prizes/prizes_bloc.dart';
import 'package:slsywc19/models/prize.dart';
import 'package:slsywc19/models/sywc_colors.dart';
import 'package:slsywc19/models/user.dart';

import 'circular_btn.dart';

class PrizeChip extends StatefulWidget {
  final Prize prize;

  const PrizeChip({Key key, this.prize}) : super(key: key);
  @override
  _PrizeChipState createState() => _PrizeChipState();
}

class _PrizeChipState extends State<PrizeChip> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser user = BlocProvider.of<AuthBloc>(context).currentUser;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: widget.prize.image,
              ),
              foregroundDecoration: BoxDecoration(
                color: user.balancePoints >= widget.prize.value
                    ? Colors.transparent
                    : Colors.white60,
                backgroundBlendMode: BlendMode.saturation,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${widget.prize.title}",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15.0),
                    ),
                    Text(
                      "${widget.prize.value} points",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: !widget.prize.isRedeemed
                    ? Container(
                        child: user.balancePoints >= widget.prize.value
                            ? Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () => _showRedeemPopup(),
                                    child: Container(
                                      padding: const EdgeInsets.all(5.0),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 3.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            "COLLECT NOW",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: SYWCColors.PrimaryColor,
                                                fontSize: 13.0),
                                          ),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  left: 7.0),
                                              decoration: BoxDecoration(
                                                  color:
                                                      SYWCColors.PrimaryColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0))),
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showRedeemPopup();
                                    },
                                    child: Text(
                                      "Where to collect?",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                ],
                              )
                            : Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  "NOT ENOUGH POINTS",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 13.0),
                                )),
                      )
                    : Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "ALREADY\nCOLLECTED",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 13.0),
                        ))),
          ],
        ),
      ),
    );
  }

  void _showRedeemPopup() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Container(
            child: CachedNetworkImage(
              fit: BoxFit.contain,
              imageUrl: widget.prize.image,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Congratulations!",
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
                  "You have enough points for a ${widget.prize.title}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Text(
                    "You can collect your prize at the redemption counter now. "),
              )
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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
}
