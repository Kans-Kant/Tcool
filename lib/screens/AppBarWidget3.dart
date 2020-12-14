import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/screens/settings/SettingScreen.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/models/Notification.dart' as notif ;
import 'SplashScreen.dart';
import 'themes/light_color.dart';

MyAppBar3(BuildContext context) {
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
  leading: BackButton(
      color: LightColor.icon
  ),
  backgroundColor: LightColor.blueLinkedin, //LightColor.green1,
  title :new Image(
      image: new ExactAssetImage("assets/SUN SQUARE ALMAZ.jpg"),
      height: 48.0,
      width: 48.0,
      alignment: FractionalOffset.center),
  centerTitle: true,
  actionsIconTheme: IconThemeData(color: Color(0xffcbeaed)),
  actions: <Widget>[
    //adding of avatar
    //-----------------------
    Container(
      width: 64,
      margin: const EdgeInsets.only(right: 20.0),
      child: new IconButton(
        icon: new Icon(Icons.settings),
        //highlightColor: Colors.pink,
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SettingScreen()));
        },
      ),
    ),
  ],
);
