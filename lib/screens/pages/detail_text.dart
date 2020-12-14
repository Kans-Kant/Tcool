
import 'package:flutter/material.dart';
import 'package:tcool_flutter/themes/theme.dart';
import 'package:tcool_flutter/themes/title_text.dart';

DetailTitle(String text1, String text2,double size) {
  return Container(
      margin: AppTheme.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
           Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleText(
                  text: text1,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left:5.0,right: 5),
                        width: size,
                        child:TitleText(
                          text: text2,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ]
                ),
              ],
            ),
          Spacer(),
          SizedBox()
        ],
      ));
}

DetailTitleWidget(String text1, Widget _widget) {
  return Container(
      margin: AppTheme.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
           Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleText(
                  text: text1,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(
              height: 10,
            ),
              Align(
                alignment: Alignment.topLeft,
                child: _widget
              )
              ],
            ),
          Spacer(),
          SizedBox()
        ],
      ));
}