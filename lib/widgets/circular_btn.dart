import 'package:flutter/material.dart';
import 'package:slsywc19/models/sywc_colors.dart';

class CircularButton extends StatefulWidget {
  final Function onPressed;
  final Widget child;
  final bool isSelected;

  const CircularButton({Key key, this.onPressed, this.isSelected, this.child})
      : super(key: key);

  @override
  _CircularButtonState createState() => _CircularButtonState();
}

class _CircularButtonState extends State<CircularButton> {
  @override
  Widget build(BuildContext context) {
    return !widget.isSelected
        ? OutlineButton(
            color: Colors.white,
            onPressed: () {
              widget.onPressed();
            },
            child: widget.child,
            borderSide: BorderSide(
              color: SYWCColors.PrimaryColor, //Color of the border
              style: BorderStyle.solid, //Style of the border
              width: 2.5, //width of the border
            ),
          )
        : OutlineButton(
            color: SYWCColors.PrimaryLightColor,
            onPressed: () {
              widget.onPressed();
            },
            child: widget.child,
            borderSide: BorderSide(
              color: SYWCColors.PrimaryColor, //Color of the border
              style: BorderStyle.solid, //Style of the border
              width: 2.5, //width of the border
            ),
          );
  }
}
