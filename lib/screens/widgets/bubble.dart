import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

/********************** another update ***********************/
class Bubble extends StatelessWidget {
  Bubble({this.username,this.message, this.time, this.delivered, this.isMe});

  final String message, time,username;
  final delivered, isMe;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.greenAccent.shade100 :  Colors.white;
    final align = isMe ?  CrossAxisAlignment.end :CrossAxisAlignment.start ;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
        ? BorderRadius.only(
      topLeft: Radius.circular(5.0),
      bottomLeft: Radius.circular(5.0),
      bottomRight: Radius.circular(10.0),
    ):
    BorderRadius.only(
      topRight: Radius.circular(5.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(5.0),
    );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        SizedBox(height: 4,),
        Container(
          margin: const EdgeInsets.only(left :3.0,right: 3.0),
          padding: const EdgeInsets.only(left:8.0,right: 8.0),
        ),
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(username,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: isMe ?  LightColor.greyLinkedin : LightColor.blueLinkedin,
                    fontSize: 12.0,
                  )),
              Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 48.0),
                      child: Text(message),
                    ),
                    Positioned(
                        bottom: 0.0,
                        right: 0.0,
                        child : Column(
                            children: <Widget>[
                              SizedBox(height: 3,),
                              Row(
                                children: <Widget>[
                                  Text(time,
                                      style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 10.0,
                                      )),
                                  SizedBox(width: 3.0),
                                  Icon(
                                    icon,
                                    size: 12.0,
                                    color: Colors.black38,
                                  )
                                ],
                              ),
                            ]
                        )
                    )
                  ]
              ),
            ],
          ),
        )
      ],
    );
  }
}
