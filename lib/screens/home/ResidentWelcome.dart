import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/permissionService.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/screens/NotifWidget.dart';
import 'package:tcool_flutter/screens/dicsussion/createDiscussion1.dart';
import 'package:tcool_flutter/screens/dicsussion/createDiscussion2.dart';
import 'package:tcool_flutter/screens/evenement/createEvent1.dart';
import 'package:tcool_flutter/screens/intervention/RequestIntervention_1.dart';
import 'package:tcool_flutter/screens/operation/SuiviBudget.dart';
import 'package:tcool_flutter/screens/reservation/Reservation_theme.dart';
import 'package:tcool_flutter/screens/tableau_digital/tableauDigitalScreen.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

class ResidentWelcome extends StatefulWidget {
  @override
  _ResidentWelcomeState createState() => _ResidentWelcomeState();
}

class _ResidentWelcomeState extends State<ResidentWelcome> {
  final storage = FlutterSecureStorage();
  String currentRole;

  @override
  void initState() {
    permissionAcessPhone();
    super.initState();
  }

  Future permissionAcessPhone() {
    PermissionService().requestPermission(onPermissionDenied: () {
      print('Permission has been denied');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColor.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              _cardsContainer()],
          ),
        ),
      ),
    );
  }

  //----------------------------------------
  Widget _card(icon, text,myColor) => Container(
    width:MediaQuery.of(context).size.width * 0.40,
    //height: 160,
    //padding: EdgeInsets.only(top: 4),
    /*decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: LightColor.grey,
              blurRadius: 15,
              spreadRadius: 5),
        ],
        /*border: Border.all(width: 1, color:  LightColor.blueLinkedin/*Color(0xff006a71)*/)*/),*/
    child: Column(
      children: <Widget>[
        /*ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                child: Image.asset(
                  image,
                  width: double.infinity,
                  height : 75,
                  fit: BoxFit.fill,
                ),
              ),*/
        Container(
          height:  120,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(60.0)),
            //border: Border.all(width: 2, color: myColor),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: myColor,
                  blurRadius: 7,
                  spreadRadius: 1),
            ],
          ),
          child: Center(
            child:SvgPicture.asset(
              icon,
              width: 60,
              height: 60,
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
                  fontFamily: "Sego",
                ))
        ),
      ],
    ),
  );

  Widget _card0(icon, text) => Container( //initial card
    width: 135,
    height: 120,
    child: Column(
      children: <Widget>[
        SvgPicture.asset(
          icon,
          color: LightColor.blueLinkedin,
          width: 25,
          height: 25,
        ),
        SizedBox(height:10),
        Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: "mulish",
            )),
      ],
    ),
  );

  //----------------------------------------
  /*Widget _cardsContainer0() => Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 30),
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: LightColor.grey,
                              blurRadius: 15,
                              spreadRadius: 10),
                        ],
                        border: Border.all(width: 1, color: LightColor.green1)),
                    child: InkWell(
                      splashColor: LightColor.green,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RequestIntervention1()));
                      },
                      child: _card('assets/demandeintervention.svg',
                          getTranslated(context, 'demander_intervention')),
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1, color:  LightColor.blueLinkedin/*Color(0xff006a71)*/),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: LightColor.grey,
                            blurRadius: 15,
                            spreadRadius: 5),
                      ],
                    ),
                    child: InkWell(
                      splashColor:  LightColor.blueLinkedin,//Color(0xff006a71),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => createDiscussion1()));
                      },
                      child: _card('assets/discussion2.svg',
                          getTranslated(context, 'create_discuss')),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1, color: LightColor.blueLinkedin),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: LightColor.grey,
                            blurRadius: 15,
                            spreadRadius: 5),
                      ],
                    ),
                    child: InkWell(
                        splashColor: LightColor.green,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Reservation2()));
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 10),
                              Image.asset('assets/reserv_field.png', width: 40, /*height: 35,*/ color: LightColor.blueLinkedin ),
                              SizedBox(height: 10),
                              Text(getTranslated(context, 'reservation'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: "mulish",
                                  ))
                            ],
                          ),
                        )),
                  ),
                  SizedBox(width: 15),
                  Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: LightColor.grey,
                              blurRadius: 15,
                              spreadRadius: 5),
                        ],
                        border: Border.all(width: 1, color:  LightColor.blueLinkedin/*Color(0xff006a71)*/)),
                    child: InkWell(
                      splashColor: LightColor.green,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SuiviBudget()));
                      },
                      child: _card('assets/billet.svg',
                          getTranslated(context, 'suivre_budget')),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(width: 1, color: LightColor.blueLinkedin),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: LightColor.grey,
                              blurRadius: 15,
                              spreadRadius: 5),
                        ],
                      ),
                      child: InkWell(
                          splashColor: LightColor.green,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Reservation2()));
                          },
                          child: Container(
                            width: 135,
                            height: 145,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10),
                                Image.asset('assets/reserv_field.png', width: 65, height: 65, color: LightColor.blueLinkedin ),
                                SizedBox(height: 10),
                                Text(getTranslated(context, 'reservation'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: "mulish",
                                    ))
                              ],
                            ),
                          )),
                    ),
                  ]),*/
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: LightColor.grey,
                              blurRadius: 15,
                              spreadRadius: 5),
                        ],
                        border: Border.all(width: 1, color:  LightColor.blueLinkedin/*Color(0xff006a71)*/)),
                    child: InkWell(
                      splashColor: LightColor.green,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CreateEvent1()));
                      },
                      child: _card('assets/evenement.svg',
                          getTranslated(context, 'create_event')),
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: LightColor.grey,
                              blurRadius: 15,
                              spreadRadius: 5),
                        ],
                        border: Border.all(width: 1, color:  LightColor.blueLinkedin/*Color(0xff006a71)*/)),
                    child: InkWell(
                      splashColor: LightColor.green,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CreateEvent1()));
                      },
                      child: _card('assets/evenement.svg',
                          /*getTranslated(context, 'create_event')*/'Tableau de bord'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      );*/

  Widget _cardsContainer() => Container(
    padding: EdgeInsets.fromLTRB(15, 0, 15, 30),
    child: Center(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: InkWell(
                  splashColor: LightColor.green,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RequestIntervention1()));
                  },
                  child: _card('assets/renovation.svg'/*'assets/intervention.jpg'*/,
                      getTranslated(context, 'demander_intervention',),Colors.black),
                ),
              ),
              SizedBox(width: 10),
              Container(
                child: InkWell(
                  splashColor:  LightColor.blueLinkedin,//Color(0xff006a71),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => createDiscussion1()));
                  },
                  child: _card('assets/talking.svg'/*'assets/discussion.jpg'*/,
                      getTranslated(context, 'create_discuss'),Colors.blue),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: InkWell(
                  splashColor:  LightColor.blueLinkedin,//Color(0xff006a71),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Reservation2()));
                  },
                  child: _card('assets/golf-field.svg' /*'assets/terrain.jpg'*/,
                      getTranslated(context,  'reservation'),Colors.green),
                ),
              ),
              SizedBox(width: 10),
              Container(
                child: InkWell(
                  splashColor:  LightColor.blueLinkedin,//Color(0xff006a71),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SuiviBudget()));
                  },
                  child: _card('assets/budget.svg' /*'assets/budget.png'*/,
                      getTranslated(context, 'suivre_budget'),Colors.orange),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: InkWell(
                  splashColor:  LightColor.blueLinkedin,//Color(0xff006a71),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateEvent1()));
                  },
                  child: _card('assets/calendar.svg' /*'assets/event.png'*/,
                      getTranslated(context, 'create_event'),Colors.indigo),
                ),
              ),
              SizedBox(width: 10),
              Container(
                child: InkWell(
                  splashColor:  LightColor.blueLinkedin,//Color(0xff006a71),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TableauDigitalScreen()));
                  },
                  child: _card('assets/notes.svg' /*'assets/bord.png'*/,
                      getTranslated(context, 'tableau_bord'),Colors.amber),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
        ],
      ),
    ),
  );
}
