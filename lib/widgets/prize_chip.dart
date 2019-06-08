import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:slsywc19/models/prize.dart';

class PrizeChip extends StatefulWidget {
  final Prize prize;

  const PrizeChip({Key key, this.prize}) : super(key: key);
  @override
  _PrizeChipState createState() => _PrizeChipState();
}

class _PrizeChipState extends State<PrizeChip> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10.0),
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  widget.prize.image,
                ),
              ),
            ),
          ),
          Container(
            child: Text(
              widget.prize.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
