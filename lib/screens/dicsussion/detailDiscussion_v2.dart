import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Discussion.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/MainScreen.dart';
import 'package:http/http.dart' as http;
import 'package:tcool_flutter/models/Notification.dart' as notification;
import 'package:tcool_flutter/screens/pages/Title.dart';
import 'package:tcool_flutter/screens/pages/detail_text.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';

class detailDiscussion_v2 extends StatefulWidget {
  final Discussion discussion;
  final bool type;
  detailDiscussion_v2({Key key, @required this.discussion, this.type})
      : super(key: key);

  @override
  _detailDiscussion_v2State createState() => _detailDiscussion_v2State();
}

class _detailDiscussion_v2State extends State<detailDiscussion_v2> {
  Widget _content = CircularProgressIndicator();
  final storage = FlutterSecureStorage();
  String selectVisibility;
  int nbrNotification = 0;
  String currentRole;

  //----------------- Loading spinner
  bool isLoading = false;

  List<DropdownMenuItem<String>> visibilityList = [
    DropdownMenuItem(
      child: Text('Public'),
      value: 'Public',
    ),
    DropdownMenuItem(
      child: Text('Privé'),
      value: 'Private',
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectVisibility = widget.discussion.visibility;
  }

  // modification of AppTitle
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar2(context),
      backgroundColor: LightColor.background,
      body: FutureBuilder(
          future: Utils.getCurrentRole(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) return const Loading();
            currentRole = snapshot.data;
            print(currentRole);
            return ListView(
              padding: EdgeInsets.all(15),
              shrinkWrap: true,
              children: <Widget>[
                // SizedBox(height: 10),
                // NotifWidget(context),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: LightColor.white,
                    //border: Border.all(width: 1, color: LightColor.greyLinkedin/*Color(0xff006a71)*/),
                    borderRadius: BorderRadius.all(const Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: LightColor.blueLinkedin,
                        blurRadius: 5.0,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child:Align(
                      child: AppTitle(getTranslated(context, 'det_dis'),
                      )),
                  ),
                /*Align(
                  alignment: Alignment.center,
                  child: Text(
                    getTranslated(context, 'det_dis'),
                    textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight:  FontWeight.w700,
                          fontSize: 24,
                          fontFamily: "mulish")
                  ),
                ),*/

                SizedBox(height: 20),
                 isLoading ? const Loading() : _detailDiscussContainer(),
                SizedBox(height: 50),
                Visibility(
                  visible: Utils.isAdmin(currentRole) &&
                      (widget.discussion.status != "CLOTUREE" &&
                          widget.discussion.status != "REJETEE"),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      this.widget.type && widget.discussion.status != "REJETEE"
                          ? _validerButton()
                          : Container(width: 0, height: 0),
                      this.widget.type && widget.discussion.status != "REJETEE"
                          ? _refuserButton()
                          : Container(width: 0, height: 0),
                      //_backButton()
                    ],
                  ),
                  //replacement: _backButton(),
                )
              ],
            );
          }),
    );
  }

  Widget decorateTextField(Widget textfield) {
    return Container(
      width: 210,
      height: 40,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: LightColor.blueLinkedin/*Color(0xff006a71)*/),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: textfield,
    );
  }

  Widget decorateTextParagraph(Widget textfield) {
    return Container(
      width: 210,
      height: 90,
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: LightColor.blueLinkedin,/*Color(0xff006a71)*/),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: textfield,
    );
  }

  Widget decorateText(Widget textfield) {
    return Container(
      width: 260,
      child: textfield,
    );
  }

  Widget _formLabel(String label) => Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "mulish",
        ),
      );

  Widget _dateHourField(String dateHour) => TextFormField(
        keyboardType: TextInputType.text,
        initialValue: dateHour,
        readOnly: true,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
      );

  Widget _titleField(String title) => TextFormField(
        initialValue: title,
        maxLengthEnforced: true,
        keyboardType: TextInputType.text,
        readOnly: true,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
      );

  Widget _detailField(String details) => TextFormField(
        initialValue: details,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: getTranslated(context, 'detail')),
      );

  Widget _statusField(String status) => TextFormField(
        initialValue: status,
        keyboardType: TextInputType.text,
        readOnly: true,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
      );

  Widget _visibilityField() => DropdownButton(
        items: visibilityList,
        underline: Container(
          decoration: BoxDecoration(color: Colors.white),
        ),
        value: selectVisibility,
        onChanged: (value) {
          setState(() {
            selectVisibility = value;
          });
        },
        isExpanded: true,
      );

  Widget _detailDiscussContainer() => Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: LightColor.white,
      //border: Border.all(width: 1, color: LightColor.greyLinkedin/*Color(0xff006a71)*/),
      borderRadius: BorderRadius.all(const Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: LightColor.blueLinkedin,
          blurRadius: 5.0,
          offset: Offset(0, 2),
        )
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Container(
          child: Row(
              children: <Widget>[
                Icon(Icons.event,color: LightColor.greyLinkedin,),
                Expanded(
                  child:DetailTitle(
                      getTranslated(context, 'date_heure'),
                      DateFormat('dd/MM/yyyy - H:mm')
                          .format(widget.discussion.createdDate),MediaQuery.of(context).size.width * 0.37,),
                ),
              ]
          ),
        ),
        Divider(height: 2,color: Colors.black,),
        Container(
          child: Row(
            children: <Widget>[
              Icon(Icons.title,color: LightColor.greyLinkedin,),
              Expanded(child: DetailTitle(
                  getTranslated(context, 'titre'), widget.discussion.title,MediaQuery.of(context).size.width * 0.37,),)
            ],
          ),
        ),
        Divider(height: 2,color: Colors.black,),
        Container(
          child: Row(
            children: <Widget>[
              Icon(Icons.more_horiz, color: LightColor.greyLinkedin,),
              Expanded(
                child: DetailTitle(
                  getTranslated(context, 'detail'), widget.discussion.details,MediaQuery.of(context).size.width * 0.37,),)
            ],
          ),
        ),
        Divider(height: 2,color: Colors.black,),
        Container(
          child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  "assets/circle.svg",
                  color: widget.discussion.status =="EN COURS" ? Colors.green : LightColor.blueLinkedin,
                    ),
                //Icon(Icons.circle,color: widget.discussion.status =="EN COURS" ?  Colors.green: LightColor.blueLinkedin),
                Expanded(
                  child:DetailTitle(
                      getTranslated(context, 'status'), widget.discussion.status,MediaQuery.of(context).size.width * 0.37,),
                ),
              ]
          ),
        ),
        Divider(height: 2,color: Colors.black,),
        Container(
          child: Row(
              children: <Widget>[
                Icon(Icons.account_circle,color: LightColor.greyLinkedin,),
                Expanded(
                  child:DetailTitle(getTranslated(context, 'visibility'), selectVisibility,MediaQuery.of(context).size.width * 0.37,),
                ),
              ]
          ),
        ),
          ],
        ),
      );

  Widget _validerButton() => InkWell(
        onTap: () => {_valider(widget.discussion)},
        //  Navigator.push(context, MaterialPageRoute(builder: (context) =>
        //    SuiviDiscussion(discussion: widget.discussion))),
        child: Container(
          width: 90,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: LightColor.blueLinkedin/*Color(0xff006a71)*/),
          child: Center(
            child: Text(
              getTranslated(context, 'valider'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: "mulish"),
            ),
          ),
        ),
      );

//-------------------------------------------------
  Widget _refuserButton() => InkWell(
        onTap: () => {_annuler(widget.discussion)},
        child: Container(
          width: 90,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: Colors.blue[300]),
          child: Center(
            child: Text(
              getTranslated(context, 'refuser'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: "mulish"),
            ),
          ),
        ),
      );

//-------------------------------------------------
  Widget _backButton() => InkWell(
        onTap: () => Navigator.of(context).pop(context),
        child: Container(
          width: 90,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.indigo[300]),
          child: Center(
            child: Text(
              getTranslated(context, 'retour'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: "mulish"),
            ),
          ),
        ),
      );

  _valider(Discussion i) async {
    isLoading = true;
    String _token = await storage.read(key: 'token');
    i.lastModifiedDate = new DateTime.now();
    Map currentUser = json.decode(await storage.read(key: 'currentUser'));
    var response = await http.put(
        Constants.DISCUSSISONS + 'cloturer-status/' + "${i.idDiscussion}",
        headers: {"Authorization": "Bearer $_token"});
    if (response.statusCode == 200) {
      notification.Notification notif = new notification.Notification();
      notif.createdDate = new DateTime.now();
      notif.createdBy = currentUser['username'];
      notif.lastModifiedDate = new DateTime.now();
      notif.message = "La discusstion ${i.title} a été cloturée";
      notif.isRead = false;
      notif.theme = "DISCUSSION";
      // notify the creator of the discussion
      CompteController()
          .sendNotificationToActeurByEmmail(notif, i.createdBy, context)
          .whenComplete(() {
            isLoading =false;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MainScreen(
                  currentPage: 1,
                )));
      });
      Utils.showAlertDialog(context, '${i.title} validée !!');
    } else {
      isLoading =false;
      throw Exception('Erreur !!');
    }
  }

  _annuler(Discussion i) async {
    String _token = await storage.read(key: 'token');
    Map currentUser = json.decode(await storage.read(key: 'currentUser'));
    var response = await http.put(
        Constants.DISCUSSISONS + 'rejeter-status/' + "${i.idDiscussion}",
        headers: {"Authorization": "Bearer $_token"});
    if (response.statusCode == 200) {
      notification.Notification notif = new notification.Notification();
      notif.createdDate = new DateTime.now();
      notif.createdBy = currentUser['username'];
      notif.lastModifiedDate = new DateTime.now();
      notif.message = "La discusstion ${i.title} a été annulée";
      notif.isRead = false;
      notif.theme = "DISCUSSION";
      // notify the creator of the discussion
      CompteController()
          .sendNotificationToActeurByEmmail(notif, i.createdBy, context)
          .whenComplete(() {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MainScreen(
                  currentPage: 1,
                )));
      });
      Utils.showAlertDialog(context, '${i.title} annulée !!');
      //
    } else {
      throw Exception('Erreur !!');
    }
  }
}
