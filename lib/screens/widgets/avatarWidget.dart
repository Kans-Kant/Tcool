import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Compte.dart';
import 'package:tcool_flutter/screens/compte/CompteTab.dart';

import '../SplashScreen.dart';

class AvatarWidget extends StatefulWidget {
  @override
  _avatarWidgetState createState() => _avatarWidgetState();
}

class _avatarWidgetState extends State<AvatarWidget> {
  Compte myAccount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getUser();
  }

  getUser() {
    CompteController().getCurrentAccount(context).then((value) => {
          this.setState(() {
            myAccount = value;
          }),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _container(),
    );
  }

  Widget _container() => FutureBuilder(
      future: CompteController().getCurrentAccount(context),
      builder: (BuildContext context, AsyncSnapshot<Compte> snap) {
        this.myAccount = snap.data;
        return ClipRect(
          child: Align(
            //alignment: Alignment.topCenter,
            //heightFactor: 0.5,
            child: PopupMenuButton(
              icon: this.myAccount == null ? new Container() : Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.account_circle),
                          Text(
                            getTranslated(context, 'compte'),
                            //'Account',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "mulish"),
                          )
                        ],
                      ),
                      value: 1),
                  PopupMenuItem(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.exit_to_app),
                          Text(
                            getTranslated(context, 'logout'),
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "mulish"),
                          )
                        ],
                      ),
                      value: 2),
                ];
              },
              onSelected: (value) {
                switch (value) {
                  case 1:
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CompteTab()));
                    break;
                  case 2:
                    _deconnexion(context);
                    break;
                  default:
                }
              },
            ),
          ),
        );
      });

  _deconnexion(BuildContext context) async {
    final storage = FlutterSecureStorage();

    await storage.delete(key: 'currentUser');
    await storage.delete(key: 'token');
    //await storage.deleteAll();

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SplashScreen()));
  }

  avatarShow(String avatar) {
    if (avatar != null) {
      Image.memory(base64.decode(avatar));
      return MemoryImage(base64.decode(avatar));
    } else {
      return new ExactAssetImage("assets/acceuil.png");
    }
  }
}
