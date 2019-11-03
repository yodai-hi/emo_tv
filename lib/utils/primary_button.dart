import 'package:emo_tv/constants/color_constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PrimaryButton extends StatefulWidget {
  PrimaryButton({Key key, this.text, this.height, this.onPressed}) : super(key: key);
  String text;
  double height;
  VoidCallback onPressed;

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: widget.height),
      child: RaisedButton(
          child: Text(widget.text, style: TextStyle(color: Colors.white, fontSize: 20.0)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(widget.height / 2))),
          color: CC.MAIN,
          textColor: CC.MAIN_TEXT,
          onPressed: widget.onPressed),
    );
  }
}
