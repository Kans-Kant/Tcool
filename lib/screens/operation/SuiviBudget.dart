import 'package:flutter/material.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/screens/AppBarWidget.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/NotifWidget.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

import 'CreditsPage.dart';
import 'DebitsPage.dart';
import 'SynthesePage.dart';

class SuiviBudget extends StatefulWidget {
  @override
  _SuiviBudgetState createState() => _SuiviBudgetState();
}

class _SuiviBudgetState extends State<SuiviBudget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar2(context),
      backgroundColor: LightColor.white,
      body: _operationTab(),
    );
  }

  //-----------------------------------------------
  Widget _operationTab() => DefaultTabController(
        length: 3,
        child: Column(children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: LightColor.blueLinkedin,//LightColor.green,
               borderRadius: BorderRadius.all(Radius.circular(30)
              )),
            child: TabBar(
              indicatorColor: LightColor.blue1,
              labelColor: LightColor.black,
              indicator: BoxDecoration(
                      color: LightColor.blue1,
                      border: Border.all(width: 2, color: LightColor.blue1),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
              tabs: [
              Tab(
                  child: Text(getTranslated(context, 'debit'),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16,fontFamily: "mulish")),
              ),
              Tab(
                child: Text(getTranslated(context, 'credit'),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16,fontFamily: "mulish")),
                ),
              Tab(
                  child: Text(getTranslated(context, 'synthese'),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16,fontFamily: "mulish")),
                ),
            ])
          ),
          _operationContainer()
        ]),
      );

  Widget _operationContainer() => Expanded(
    flex: 1,
    child: TabBarView(
      children: <Widget>[
        DebitsPage(),
        CreditsPage(),
        SynthesePage()
      ],
    ),
  );
}