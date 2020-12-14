import 'package:cron/cron.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/screens/AppBarWidget.dart';
import 'package:tcool_flutter/screens/dicsussion/DiscussionScreen.dart';
import 'package:tcool_flutter/screens/evenement/EvenementScreen.dart';
import 'package:tcool_flutter/screens/home/ResidentWelcome.dart';
import 'package:tcool_flutter/screens/intervention/InterventionScreen.dart';
import 'package:tcool_flutter/screens/pages/NotificationPageShow.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:tcool_flutter/models/Notification.dart' as notification;

const storage = FlutterSecureStorage();
/************* notifications *******************************/

class MainScreen extends StatefulWidget {
  int currentPage;
  MainScreen({Key key, this.currentPage}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  var pages = [
    ResidentWelcome(),
    DiscussionScreen(),
    InterventionScreen(),
    EvenementScreen(),
    //CompteTab()
    NotificationPageShow(),
  ];

// flutter local notification setup
  void showNotification(v, flp) async {
    var android = AndroidNotificationDetails("channel id", "channel nmame", "channel description", priority: Priority.High, importance: Importance.Max);
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    await flp.show(0, 'TCOOL', '$v', platform);
  }

  initNotification() async {
    FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initSettings = InitializationSettings(android, ios);
    flp.initialize(initSettings, onSelectNotification: _onSelectNotification);

    List<notification.Notification> notifications = [];
    var response = await CompteController().getAllUnreadNotificationV2();

    //print(response);
    if (response != null && response.length > 0) {
      notifications = response;
      storage.write(key: 'notifNumber', value: "${notifications.length}");
      showNotification(getTranslated(context, "new_notif"), flp); // "Vous avez de nouvelles notifications", flp);
      print('${notifications.length} nouvelles notifications!');
    } else {
      print("Pas de notifications");
    }
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(title: Text(title), content: Text(body), actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Ok'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  await Navigator.push(context, MaterialPageRoute(builder: (cxt) => MainScreen()));
                },
              )
            ]));
  }

  Future _onSelectNotification(String payload) {
    if (payload != null) {
      print(payload);
      /* Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => NotificationPageShow()));*/
    }
  }

  runNotification() async {
    var cron = new Cron();
    cron.schedule((new Schedule.parse('*/10 * * * *')), () async => initNotification());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onBottomIconPressed(widget.currentPage);
    runNotification();
  }
  //------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(context),
      backgroundColor: LightColor.white,
      bottomNavigationBar: CustomBottomNavigationBar(onIconPresedCallback: onBottomIconPressed, selectedIndex: widget.currentPage),
      body: pages[widget.currentPage],
    );
  }

  void onBottomIconPressed(int index) {
    setState(() {
      widget.currentPage = index;
    });
  }
}
