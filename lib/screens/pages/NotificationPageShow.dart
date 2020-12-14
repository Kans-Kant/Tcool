import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tcool_flutter/controllers/CommunicationController.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/controllers/DiscussionController.dart';
import 'package:tcool_flutter/controllers/EventController.dart';
import 'package:tcool_flutter/controllers/InterventionController.dart';
import 'package:tcool_flutter/controllers/NotificationController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Communication.dart';
import 'package:tcool_flutter/models/Discussion.dart';
import 'package:tcool_flutter/models/Evenement.dart';
import 'package:tcool_flutter/models/Intervention.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/MainScreen.dart';
import 'package:tcool_flutter/models/Notification.dart' as notification;
import 'package:tcool_flutter/screens/dicsussion/DetailDiscussion2.dart';
import 'package:tcool_flutter/screens/dicsussion/detailDiscussion_v2.dart';
import 'package:tcool_flutter/screens/evenement/DetailEvent.dart';
import 'package:tcool_flutter/screens/intervention/DetailIntervention.dart';
import 'package:tcool_flutter/screens/pages/Title.dart';
import 'package:tcool_flutter/screens/tableau_digital/DetailCommunication.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/themes/title_text.dart';

class NotificationPageShow extends StatefulWidget {
  @override
  _NotificationPageShowState createState() => _NotificationPageShowState();
}

class _NotificationPageShowState extends State<NotificationPageShow> {
  int notifcation = 3;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //   _Back(),
              FutureBuilder(
                future: CompteController().getAllUnreadNotification(context),
                builder: (context,
                    AsyncSnapshot<List<notification.Notification>> snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                        child: Text(getTranslated(context, 'no_notif')));
                  return Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      AppTitle(getTranslated(context, 'notifs')),
                      //_lineText(getTranslated(context, 'notifs')),
                      //_recentsList(snapshot.data)
                      _cartItems(snapshot.data)
                    ],
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  //----------------------------------------
  Widget _Back() => Column(
        children: <Widget>[
          SizedBox(height: 10),
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.arrow_back,
                    color: Colors.red,
                    size: 40,
                  ),
                  Text(getTranslated(context, 'retour'),
                      style: TextStyle(
                        fontFamily: "mulish",
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ))
                ],
              )),
        ],
      );

  Widget _lineText(String text) => Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "mulish",
                    )),
              ],
            ),
          ),
          Divider(
            color: Colors.black,
            height: 30,
            thickness: 5,
          )
        ],
      );

  Widget _leftRight() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              icon: SvgPicture.asset('assets/previous.svg'),
              onPressed: () {
                Navigator.pop(context);
              }),
          Text(
            '1/3',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          IconButton(
              icon: SvgPicture.asset('assets/next.svg'), onPressed: () {})
        ],
      );

  ListView _recentsList(List<notification.Notification> notifs) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(10),
      itemCount: notifs.length,
      itemBuilder: (context, index) => Card(
        color: Colors.white,
        shadowColor: Color(0xff006a71),
        child: ListTile(
            onTap: () {
              _switchTheme(notifs[index]);
            },
            leading: Icon(Icons.notifications, size: 40.0, color: Colors.red),
            title: Text(notifs[index].message),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    DateFormat('dd/MM/yyyy').format(notifs[index].createdDate)),
                Text(notifs[index].createdBy),
              ],
            )),
      ),
    );
  }

  ListView _ancientList(List<notification.Notification> notifs) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(10),
      itemCount: notifs.length,
      itemBuilder: (context, index) => Card(
        color: Colors.grey[300],
        shadowColor: Color(0xff006a71),
        child: ListTile(
            onTap: () {},
            leading: Icon(Icons.notifications, size: 40.0, color: Colors.grey),
            title: Text(notifs[index].message),
            subtitle: Text(DateFormat('dd/MM/yyyy - HH:mm:ss')
                .format(notifs[index].createdDate))),
      ),
    );
  }

  _switchTheme(notification.Notification n) async {
    print("ID:${n.idNotification}");
    Intervention inter ;
    Evenement event;
    Discussion discuss;
    Communication com;
    await NotificationController().readNotification(n.idNotification, context);
    switch (n.theme) {
      case "EVENEMENT":
        {
          /*Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(
                        currentPage: 3,
                      )));*/
           EventController().getEventById(n.parentId, context).then((value) => {
             event = value,
             Navigator.push(
                 context,
                 MaterialPageRoute(
                     builder: (context) => DetailEvent(
                       evenement:event ,
                       type: true,
                     ))),
          });
        }
        break;
      case "INTERVENTION":
        {
          /*Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(
                        currentPage: 2,
                      )));*/

          InterventionController().getInterById(n.parentId, context).then((value) => {
            inter = value,
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailIntervention(
                      intervention: inter ,
                      type: true,
                    ))),
          });
        }
        break;
      case "DISCUSSION":
        {
          /*Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(
                        currentPage: 1,
                      )));*/
          DiscussionController().getDiscussById(n.parentId, context).then((value) => {
            discuss = value,
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => detailDiscussion_v2(
                      discussion: discuss ,
                      type: true,
                    ))),
          });
        }
        break;
      case "COMMUNICATION":
        {
          CommunicationController().getCommunicationById(n.parentId, context).then((value) => {
            com = value,
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailCommunication(
                      communication: com ,
                      type: true,
                    ))),
          });
        }
        break;
      default: 
        {}
        break;
    } 
  }

  // itemList
  Widget _item(notification.Notification model) {
    return Container(
      margin: EdgeInsets.all(3),
      height: 80,
      child: Row(
        children: <Widget>[
           Container(
                    width: 65,
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: LightColor.lightGrey.withAlpha(150),
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(
            Icons.notifications,
            color:  LightColor.blueLinkedin,//LightColor.green1,
          ),
                  ),
          // AspectRatio(
          //   aspectRatio: 1.2,
          //   child: Stack(
          //     children: <Widget>[
          //       Align(
          //         alignment: Alignment.bottomLeft,
          //         child: Container(
          //           height: 60,
          //           width: 60,
          //           child: Stack(
          //             children: <Widget>[
          //               Align(
          //                 alignment: Alignment.bottomLeft,
          //                 child: Container(
          //                   decoration: BoxDecoration(
          //                       color: LightColor.lightGrey,
          //                       borderRadius: BorderRadius.circular(10)),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       Positioned(
          //         left: 30,
          //         bottom: 30,
          //         child: Icon(
          //   Icons.notifications,
          //   color:  Colors.red,
          // ),
          //       )
          //     ],
          //   ),
          // ),
          Expanded(
              child: ListTile(
                  onTap: () {
                    _switchTheme(model);
                  },
                  title: TitleText(
                    text: model.message,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TitleText(
                        text: '${model.createdBy}  ',
                        fontSize: 13,
                      ),
                       Expanded(child: TitleText(
                         text: DateFormat('dd/MM/yyyy - HH:mm:ss')
                             .format(model.createdDate),
                         color: LightColor.blueLinkedin,//LightColor.green1,
                         fontSize: 11,
                       ),)
                    ],
                  ),
                  ))
        ],
      ),
    );
  }

  Widget _cartItems(List<notification.Notification> notifs) {
    return Column(children: notifs.map((x) => _item(x)).toList());
  }
}
