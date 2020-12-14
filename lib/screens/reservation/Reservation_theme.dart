import 'package:flutter/material.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/pages/Title.dart';

import 'reservation_calendar.dart';


class Reservation2 extends StatefulWidget {
  @override
  Reservation2State createState() => Reservation2State();
}

class Reservation2State extends State<Reservation2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar2(context),
      backgroundColor: LightColor.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              AppTitle(getTranslated(context, 'choix_terrain')),
              SizedBox(height: 60),
              _cardsContainer(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  //----------------------------------------
  Widget _cardsClick(icon, text,myColor) => Container(
        //padding: EdgeInsets.all(7),
        /*decoration: BoxDecoration(
            color: LightColor.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: LightColor.grey, blurRadius: 15, spreadRadius: 10),
            ],
            border: Border.all(width: 1, color: LightColor.blueLinkedin)),*/
        child: InkWell(
          splashColor: LightColor.green,
          onTap: () => {_switchNav(text)},
          child: _card(icon, text,myColor),
        ),
      );

  //----------------------------------------
  Widget _card0(icon, text) => Container(
        width:MediaQuery.of(context).size.width * 0.37,
        height: 150,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Image.asset(
              icon,
              width: 70,
              height: 70,
              color: LightColor.blueLinkedin,
            ),
            SizedBox(height: 10),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "mulish",
                ))
          ],
        ),
      );

  Widget _card(icon, text,myColor) => Container(
    width:MediaQuery.of(context).size.width * 0.40,
    child: Column(
      children: <Widget>[
        Container(
          height:  120,
          width: 120,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: LightColor.blueLinkedin,
                    blurRadius: 7,
                    spreadRadius: 1),
              ],
              borderRadius: BorderRadius.all(Radius.circular(60.0)),
              //border: Border.all(width: 2, color: LightColor.blueLinkedin)
          ),
          child: Center(
            child: Image.asset(
              icon,
              width: 50,
              height: 50,
              color: myColor,
            ),),
        ),
        Container(
            height : 67,
            padding: EdgeInsets.all(5),
            child:Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "mulish",
                ))
        ),
      ],
    ),
  );
  //----------------------------------------
  Widget _cardsContainer() => Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _cardsClick('assets/soccer_player.png',
                      getTranslated(context, 'foot'),Colors.blue),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.05,
                  ),
                  _cardsClick(
                      'assets/basketball_player.png', getTranslated(context, 'basket'),Colors.blue),
                ],
              ),
            ],
          ),
        ),
      );
  //----------------------------------------
  _switchNav(text) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CalendarPage(text)));
  }
}
