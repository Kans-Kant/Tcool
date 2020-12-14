import 'package:flutter/material.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/screens/NotifWidget.dart';
import 'package:tcool_flutter/screens/intervention/InterventionCloturees.dart';
import 'package:tcool_flutter/screens/intervention/InterventionEnCours.dart';
import 'package:tcool_flutter/screens/intervention/InterventionRejetees.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

class InterventionScreen extends StatefulWidget {
  @override
  _InterventionScreenState createState() => _InterventionScreenState();
}

class _InterventionScreenState extends State<InterventionScreen> {
  @override
  Widget build(BuildContext context) {
    return _discussionTab();
  }


  //-----------------------------------------------
  Widget _discussionTab() => DefaultTabController(
        length: 3,
        child: Column(children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
              margin: EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: LightColor.blueLinkedin,//LightColor.green,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: TabBar(
                  indicatorColor: LightColor.blue1,
                  labelColor: LightColor.black,
                  indicator: BoxDecoration(
                      color: LightColor.blue1,
                      border: Border.all(width: 2, color: LightColor.blue1),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  tabs: [
                    Tab(
                      child: Text(getTranslated(context, 'encours'),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: "mulish")),
                    ),
                    Tab(
                      child: Text(getTranslated(context, 'cloturee'),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: "mulish")),
                    ),
                    Tab(
                      child: Text(getTranslated(context, 'rejetee'),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: "mulish")),
                    ),
                  ])),
          _interventionContainer()
        ]),
      );

  //------------------------------------------------
  Widget _interventionContainer() => Expanded(
      flex: 1,
      child: TabBarView(
        children: <Widget>[
          InterventionEnCours(),
          InterventionCloturees(),
          InterventionRejetees()
        ],
      ));
}
