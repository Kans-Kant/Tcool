import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/dicsussion/createDiscussion2.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/pages/Title.dart';

import 'createDiscussion2.dart';

class createDiscussion1 extends StatefulWidget {
  @override
  _createDiscussion1State createState() => _createDiscussion1State();
}

class _createDiscussion1State extends State<createDiscussion1> {
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
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: bottomNav(1)
    );
  }

  //----------------------------------------
  Widget _cardsClick(icon, text,myColor) => Container(
        /*decoration: BoxDecoration(
            color: LightColor.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: LightColor.grey, blurRadius: 15, spreadRadius: 10),
            ],
            border: Border.all(width: 1, color: LightColor.blueLinkedin,/*LightColor.green1*/)),*/
        child: InkWell(
          splashColor: LightColor.blueLinkedin,//LightColor.green,
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
            SvgPicture.asset(
              icon,
              color: LightColor.blueLinkedin,//LightColor.green,
            ),
            SizedBox(height: 10),
            Text(getTranslated(context, text),
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

  //----------------------------------------
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
              //border: Border.all(width: 2, color: LightColor.blueLinkedin),

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
                  _cardsClick('assets/relationSyndic.svg',
                      /*getTranslated(context, */'gestionnaire_rel',Colors.blue/*)*/),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.05,
                  ),
                  _cardsClick(
                      'assets/ballon.svg', /*getTranslated(context, */'hobbies',Colors.blue/*)*/),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _cardsClick('assets/villeRegion.svg',
                      /*getTranslated(context, */'sujets',Colors.blue/*)*/),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.05,
                  ),
                  _cardsClick('assets/autreDiscussion.svg',
                      /*getTranslated(context, */'autre_sujet',Colors.blue/*)*/),
                ],
              ),
            ],
          ),
        ),
      );

  //----------------------------------------
  _switchNav(text) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateDiscussion2(theme: text)));
  }
}
