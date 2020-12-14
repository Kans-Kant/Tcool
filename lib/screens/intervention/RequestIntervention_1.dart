import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/screens/AppBarWidget.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/NotifWidget.dart';
import 'package:tcool_flutter/screens/intervention/RequestIntervention_2.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/pages/Title.dart';

class RequestIntervention1 extends StatefulWidget {
  @override
  _RequestIntervention1State createState() => _RequestIntervention1State();
}

class _RequestIntervention1State extends State<RequestIntervention1> {
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
                AppTitle(getTranslated(context, 'choix_theme')),
                SizedBox(height: 30),
                _cardsContainer(),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      //  bottomNavigationBar: bottomNav(2)
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
            border: Border.all(width: 1, color: LightColor.blueLinkedin,/*LightColor.green1*/)),*/
        child: InkWell(
          splashColor: LightColor.blueLinkedin,//Color(0xff006a71),
          onTap: () => {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RequestIntervention2(
                      theme: text,
                    )))
          },
          child: _card(icon, text,myColor),
        ),
      );

  //----------------------------------------
  Widget _card0(icon, text) => Container(
        width:MediaQuery.of(context).size.width * 0.37,
        height: 150,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            SvgPicture.asset(
              icon,
              color: LightColor.blueLinkedin,//LightColor.green,
            ),
            SizedBox(height: 10),
            Text(getTranslated(context, text),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
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
            child:SvgPicture.asset(
              icon,
              width: 50,
              height: 50,
              color: myColor,
              allowDrawingOutsideViewBox: false,
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
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _cardsClick('assets/peinture.svg',
                      /*getTranslated(context, */'peinture',Colors.blue/*)*/),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.05,
                  ),
                  _cardsClick('assets/plomberie.svg',
                      /*getTranslated(context, */'plomberie',Colors.blue/*)*/),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _cardsClick(
                      'assets/jardin.svg', /*getTranslated(context, */'jardin',Colors.blue/*)*/),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.05,
                  ),
                  _cardsClick(
                      'assets/autres.svg', /*getTranslated(context, */'travaux',Colors.blue/*)*/),
                ],
              ),
            ],
          ),
        ),
      );

  //----------------------------------------
  Widget _leftRight() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              icon: SvgPicture.asset('assets/previous.svg',color: LightColor.blueLinkedin,),
              onPressed: () {
                Navigator.pop(context);
              }),
          Text(
            '1/3',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          IconButton(
              icon: SvgPicture.asset('assets/next.svg',color: LightColor.blueLinkedin,), onPressed: () {})
        ],
      );
}
