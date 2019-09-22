import 'package:flutter/material.dart';
import 'package:slsywc19/models/sywc_colors.dart';

class CircularButton extends StatefulWidget {
  final Function onPressed;
  final Widget child;
  final bool isSelected;
  final Color color;

  const CircularButton(
      {Key key, this.onPressed, this.isSelected, this.child, this.color})
      : super(key: key);

  @override
  _CircularButtonState createState() => _CircularButtonState();
}

class _CircularButtonState extends State<CircularButton> {
  @override
  Widget build(BuildContext context) {
    return !widget.isSelected
        ? OutlineButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            onPressed: () {
              widget.onPressed();
            },
            child: widget.child,
            borderSide: BorderSide(
              color: SYWCColors.PrimaryColor, //Color of the border
              style: BorderStyle.solid, //Style of the border
              width: 2.5, //width of the border
            ),
            color: widget.color == null ? Colors.white : widget.color,
          )
        : RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            color: SYWCColors.PrimaryColor,
            onPressed: () {
              widget.onPressed();
            },
            child: widget.child,
          );
  }
}
