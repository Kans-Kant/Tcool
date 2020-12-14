import 'package:flutter/material.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final double verticalPadding;
  final double fontSize;

  bool isPressed = false;

  RoundedButton({
    Key key,
    this.text,
    this.press,
    this.verticalPadding,
    this.fontSize,
    this.isPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: //() {
        //isPressed = !isPressed;
        press,
      //},
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 16),
        padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 30),
        decoration: BoxDecoration(
          color: isPressed ?  Colors.blue : LightColor.icon,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 3,
              color: LightColor.grey.withOpacity(.61)
            )
          ]
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            fontFamily: "mulish"
          ),
        ),
      )
    );
  }
}