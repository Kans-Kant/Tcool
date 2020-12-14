import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/screens/AppBarWidget3.dart';
import 'package:tcool_flutter/screens/settings/ContactUtilScreen.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

import '../AppBarWidget4.dart';
import '../SplashScreen.dart';
import 'FaqScreen.dart';




class  SettingScreen extends StatefulWidget {

  SettingScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingScreenState();

}

class _SettingScreenState extends State< SettingScreen> {

  List<List<String>> items = List();

  @override
  void initState() {
    super.initState();
    //items.add(["Langue", ""]);
    //items.add(["Environment", ""]);
    items.add(["A Propos de TCOOL", ""]);
    items.add(["FAQ", ""]);
    items.add(["Contacts utils", ""]);
    //items.add(["Aide ?", ""]);
    //items.add(["Politique de confidentialité", ""]);
    items.add(["Déconnexion", ""]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar4(context),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: _settingContainer(),
      ),
    );
  }

  Widget _settingContainer() {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _listItem(index);
        }
    );
  }

  Widget _listItem(index) {
    return new GestureDetector(
      onTap: () {
        _displayScreen(index);
        print(index);
      },
      child: Column(
          children: <Widget>[
            Container(
              child: ListTile(
                title: Text(
                  items[index][0],
                  style: TextStyle(fontSize: 18.0),
                ),
                trailing: Icon(Icons.arrow_forward_ios,size: 18,),
              ),
            ),
            Divider(color: Colors.grey,)
          ]
      ),
    );
  }

  _displayScreen(index){
    if(index==3){
      _deconnexion(context);
    }
    if(index==0){
      _showAboutUs(context);
    }
    if(index==1){
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => FaqScreen()));
    }
    if(index==2){
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ContactUtilScreen()));
    }

  }

  _deconnexion(BuildContext context) async {
    final storage = FlutterSecureStorage();
    // await storage.deleteAll();
    await storage.delete(key: 'currentUser');
    await storage.delete(key: 'token');

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SplashScreen()));
  }

  _showAboutUs(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationIcon: FlutterLogo(),
      applicationName: 'TCOOL',
      applicationVersion: '1.0.0',
      applicationLegalese: '©2020 TCOOL',
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              getTranslated(context, "description_tcool"),
            )
        )
      ],
    );
  }
}
