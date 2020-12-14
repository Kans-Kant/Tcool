import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/main.dart';
import 'package:tcool_flutter/models/Compte.dart';
import 'package:tcool_flutter/screens/compte/CompteScreen.dart';
import 'package:tcool_flutter/screens/compte/CompteTab.dart';
import 'package:tcool_flutter/screens/pages/NotificationPageShow.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/models/Notification.dart' as notif ;
import 'package:tcool_flutter/screens/widgets/avatarWidget.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';
import 'SplashScreen.dart';

// widget for appBar
MyAppBar(BuildContext context) {
  Locale _temp;

  return PreferredSize(
      preferredSize: Size.fromHeight(70),
      child:  FutureBuilder(
    future: CompteController().getAllUnreadNotification(context),
    builder: (context, AsyncSnapshot<List<notif.Notification>> snapshot) {
       if (!snapshot.hasData) return body(context, _temp, 0);
       if(snapshot.data.length == 0) return body(context, _temp, 0);
      return body(context, _temp, snapshot.data.length);
      }
  ));

}

_deconnexion(BuildContext context) async {
  final storage = FlutterSecureStorage();
  await storage.deleteAll();

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SplashScreen()));
}

Widget body(BuildContext context, Locale _temp, int snap) => AppBar(
        backgroundColor: LightColor.blueLinkedin,//LightColor.green1,
        leading: Container(
          child:Column(
              children: <Widget>[
                Expanded(
                  child:PopupMenuButton(
                    icon: Icon(Icons.language, color: Color(0xffcbeaed),size: 30,),
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Image.asset(
                                  'assets/britishflag.png',
                                  fit: BoxFit.cover, // this is the solution for border
                                  width: 25.0,
                                  height: 25.0,
                                ),
                                Text(
                                  "English",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: "mulish"),
                                )
                              ],
                            ),
                            value: ENGLISH),
                        PopupMenuItem(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Image.asset(
                                  'assets/france2.png',
                                  fit: BoxFit.cover, // this is the solution for border
                                  width: 25.0,
                                  height: 25.0,
                                ),
                                Text(
                                  "Français",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: "mulish"),
                                )
                              ],
                            ),
                            value: FRENCH),
                        PopupMenuItem(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Image.asset(
                                  'assets/morocco.png',
                                  fit: BoxFit.cover, // this is the solution for border
                                  width: 25.0,
                                  height: 25.0,
                                ),
                                Text(
                                  "العربية",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: "mulish"),
                                )
                              ],
                            ),
                            value: ARABIC)
                      ];
                    },
                    onSelected: (value) async {
                      _temp = await setLocale(value);
                      print(_temp.toString());
                      MyApp.setLocale(context, _temp);
                    },
                  ),
                ),
                Container(
                  //margin: EdgeInsets.only(top : 2),
                  //height: 7,
                  child : Text(
                      MyApp.getUserLocale(context).substring(0,2).toUpperCase(),
                    style: TextStyle(
                        color: Color(0xffcbeaed),
                        fontFamily: "mulish"),
                  ),
                ),
              ]
          ),
        ),
        title: new Image(
            fit: BoxFit.cover,
            image: new ExactAssetImage("assets/SUN SQUARE ALMAZ.jpg"),
            height: 48.0,
            width: 48.0,
            alignment: FractionalOffset.center),

        centerTitle: true,
        actionsIconTheme: IconThemeData(color: Color(0xffcbeaed)),
        actions: <Widget>[
          //adding of avatar
          //-----------------------
          AvatarWidget(),
        ],
      );