import 'package:flutter/material.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/screens/NotifWidget.dart';
import 'package:tcool_flutter/screens/compte/CompteScreen.dart';
import 'package:tcool_flutter/screens/compte/CoproprietesScreen.dart';
import 'package:tcool_flutter/screens/compte/UtilisateursScreen.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

import '../AppBarWidget3.dart';

class CompteTab extends StatefulWidget {
  @override
  _CompteTabState createState() => _CompteTabState();
}

class _CompteTabState extends State<CompteTab> {
  String currentRole;
  Widget _content = CircularProgressIndicator();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar3(context),
      backgroundColor: LightColor.white,
      body : Container(
        child: _discussionTab(),
      ),
    );
    //return _discussionTab();
  }

  //-----------------------------------------------
  Widget _discussionTab() => FutureBuilder(
      future: Utils.getCurrentRole(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) return Center(child: _content);
        currentRole = snapshot.data;
        print(currentRole);
        return DefaultTabController(
          length: 3,
          child: Column(children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color:  LightColor.blueLinkedin,//LightColor.green,
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
                        child: Text(getTranslated(context, 'compte'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontFamily: "mulish")),
                      ),
                      Visibility(
                        visible: Utils.isAdmin(currentRole),
                        child: Tab(
                          child: Text(getTranslated(context, 'Cops'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: "mulish")),
                        ),
                      ),
                      Visibility(
                        visible: Utils.isAdmin(currentRole),
                        child: Tab(
                          child: Text(getTranslated(context, 'users'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: "mulish")),
                        ),
                      ),
                    ])),
            Expanded(
                flex: 1,
                child: TabBarView(
                  children: <Widget>[
                    CompteScreen(),
                    Visibility(
                        visible: Utils.isAdmin(currentRole),
                        child: CoproprietesScren()),
                    Visibility(
                        visible: Utils.isAdmin(currentRole),
                        child: UtilisateursScreen())
                  ],
                ))
          ]),
        );
      });
}
