import 'package:flutter/material.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/themes/theme.dart';
import 'package:tcool_flutter/themes/title_text.dart';

/*AppTitle(String text) {
  return Container(
      margin: AppTheme.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TitleText(
                text: text,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          Spacer(),
          SizedBox()
        ],
      ));
}*/

AppTitle(String text) {
  return Column(
     // crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          //margin: AppTheme.padding,
          height: 45,
          child: Align(
            alignment: Alignment.center,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /*Container(
                    child: Icon(Icons.content_paste, color: LightColor.blueLinkedin,),
                  ),*/
                  SizedBox(width: 20),
                  TitleText(
                    text: text,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ]
            )/*TitleText(
              text: text,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),*/
          ),),
        SizedBox(height: 3,),
  ]);
}
