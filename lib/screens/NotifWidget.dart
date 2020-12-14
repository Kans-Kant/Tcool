
import 'package:flutter/material.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/screens/pages/NotificationPageShow.dart';
import 'package:tcool_flutter/models/Notification.dart' as notif ;
import 'package:tcool_flutter/screens/themes/light_color.dart';

NotifWidget(BuildContext context) {
  return FutureBuilder(
    future: CompteController().getAllUnreadNotification(context),
    builder: (context, AsyncSnapshot<List<notif.Notification>> snapshot) {
        if (!snapshot.hasData) return col(context,0);
        if(snapshot.data.length == 0) return col(context,0);
        return col(context, snapshot.data.length);
      }
  );
  
}
Widget col(BuildContext context, int nbr_notification) => Column(
        children: <Widget>[
          SizedBox(height: 10),
          FlatButton(
      onPressed: () { Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NotificationPageShow()));},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.notifications,
            color: nbr_notification > 0 ? LightColor.red : LightColor.lightGrey,
            size: 40,
          ),
          Text('${getTranslated(context, 'notifs')} : $nbr_notification',
              style: TextStyle(
                fontFamily: "mulish",
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: nbr_notification > 0 ? Colors.red : LightColor.lightGrey,
              ))
        ],
      )),
        ],
      );