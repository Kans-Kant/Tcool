import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Evenement.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:tcool_flutter/screens/AppBarWidget.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/MainScreen.dart';
import 'package:tcool_flutter/screens/NotifWidget.dart';
import 'package:tcool_flutter/screens/evenement/SuivreEvenement.dart';
import 'package:http/http.dart' as http;
import 'package:tcool_flutter/models/Notification.dart' as notification;
import 'package:tcool_flutter/screens/pages/Title.dart';
import 'package:tcool_flutter/screens/pages/detail_text.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

import 'package:path_provider/path_provider.dart';

class DetailEvent extends StatefulWidget {
  final Evenement evenement;
  final bool type;
  DetailEvent({Key key, @required this.evenement, this.type}) : super(key: key);

  @override
  _DetailEventState createState() => _DetailEventState();
}

class _DetailEventState extends State<DetailEvent> {
  Widget _content = CircularProgressIndicator();
  String currentRole;
  final storage = FlutterSecureStorage();
  String selectVisibility;
  int nbrNotification = 0;
  List<DropdownMenuItem<String>> visibilityList = [
    DropdownMenuItem(
      child: Text('Public'),
      value: 'Public',
    ),
    DropdownMenuItem(
      child: Text('Privé Copropriété'),
      value: 'Privé Copropriété',
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectVisibility = widget.evenement.visibility;
    print(widget.evenement.visibility);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar2(context),
      backgroundColor: LightColor.background,
      body: FutureBuilder(
          future: Utils.getCurrentRole(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) return Center(child: _content);
            currentRole = snapshot.data;
            print(currentRole);
            return ListView(
              padding: EdgeInsets.all(15),
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 20),
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
                      child: AppTitle(getTranslated(context, 'det_event'),
                      )),
                ),
                SizedBox(height: 30),
                _detailDiscussContainer(),
                SizedBox(height: 50),
                Visibility(
                  visible: Utils.isAdmin(currentRole) &&
                      widget.evenement.status == "EN COURS",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      this.widget.type
                          ? _validerButton()
                          : Container(width: 0, height: 0),
                      this.widget.type
                          ? _refuserButton()
                          : Container(width: 0, height: 0),
                      //  _backButton()
                    ],
                  ),
                  //  replacement: _backButton(),
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
      height: 100,
      padding: EdgeInsets.all(7),
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
        readOnly: true,
        initialValue: details,
        keyboardType: TextInputType.multiline,
        maxLines: 10,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
      );

  Widget _statusField(String status) => TextFormField(
        initialValue: status,
        keyboardType: TextInputType.text,
        readOnly: true,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
      );

  /*Widget _eventDateField(String eventDate) => TextFormField(
    initialValue: eventDate,
    maxLengthEnforced: true,
    keyboardType: TextInputType.text,
    readOnly: true,
    decoration: new InputDecoration(
      border: InputBorder.none,
    ),
  );*/

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
    // TODO: padding of container
    padding: EdgeInsets.all(15),
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
                Icon(Icons.event,color: Colors.grey,),
                Expanded(
                  child:DetailTitle(
                      getTranslated(context, 'date_heure'),
                      DateFormat('dd/MM/yyyy - H:mm')
                          .format(widget.evenement.createdDate),MediaQuery.of(context).size.width * 0.37,),
                ),
              ]
          ),
        ),

        Divider(height: 2,color: Colors.black,),
        Container(
          child: Row(
              children: <Widget>[
                Icon(Icons.event,color: LightColor.greyLinkedin,),
                Expanded(
                  child:DetailTitle(
                      getTranslated(context, 'event_date'),  widget.evenement.eventDate.toString()== "null" ? "absent" : DateFormat('dd/MM/yyyy')
                      .format(widget.evenement.eventDate),MediaQuery.of(context).size.width * 0.37,),
                ),
              ]
          ),
        ),
        Divider(height: 2,color: Colors.black,),
        Container(
          child: Row(
              children: <Widget>[
                Icon(Icons.timer,color: LightColor.greyLinkedin,),
                Expanded(
                  child:DetailTitle(
                      getTranslated(context, 'duration'), widget.evenement.duration,MediaQuery.of(context).size.width * 0.37,),
                ),
              ]
          ),
        ),
        Divider(height: 2,color: Colors.black,),
        Container(
          child: Row(
              children: <Widget>[
                Icon(Icons.title,color: LightColor.greyLinkedin,),
                Expanded(
                  child:DetailTitle(
                      getTranslated(context, 'titre'), widget.evenement.title,MediaQuery.of(context).size.width * 0.37,),
                ),
              ]
          ),
        ),

        Divider(height: 2,color: Colors.black,),
        Container(
          child: Row(
              children: <Widget>[
                Icon(Icons.more_horiz,color: LightColor.greyLinkedin,),
                Expanded(
                  child:DetailTitle(
                      getTranslated(context, 'detail'), widget.evenement.details,MediaQuery.of(context).size.width * 0.37,),
                ),
              ]
          ),
        ),
        Divider(height: 2,color: Colors.black,),

        Container(
          child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  "assets/circle.svg",
                  color: widget.evenement.status =="EN COURS" ? Colors.green : LightColor.blueLinkedin,
                    ),
               // Icon(Icons.circle,color: widget.evenement.status =="EN COURS"?Colors.green :LightColor.blueLinkedin,),
                Expanded(
                  child:DetailTitle(
                      getTranslated(context, 'status'), widget.evenement.status,MediaQuery.of(context).size.width * 0.37,),
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
        /*Container(
          child: Row(
              children: <Widget>[
                Icon(Icons.photo,color: LightColor.greyLinkedin,),
                Expanded(
                  child:this.widget.evenement.document == null ? DetailTitle(
                      getTranslated(context, 'document'), "no document",MediaQuery.of(context).size.width * 0.37,) :DetailTitleWidget(getTranslated(context, 'document'), _documentButton()),
                ),
              ]
          ),
        ),*/
      ],
    ),
  );

  //----------------------------------
  Widget _documentButton() => InkWell(
    onTap: () => {
      //getDocument(),
    },
    child: Container(
      width: 190,
      height: 40,
      //   margin: EdgeInsets.symmetric(horizontal: 50),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.grey[200],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(Icons.file_download),
            SizedBox(
              height: 10,
            ),
            Text(
              getTranslated(context, 'aff_doc'),
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontFamily: "mulish",
              ),
            ),
          ],
        ),
      ),
    ),
  );

  //---------------------- get the document ------------

  /*getDocument() async {

    var file;

    if(this.widget.evenement.document!=null){
      file = await writeToFile(this.widget.evenement.document); // <= returns File

    }
    //file.delete();
  }*/

  //----------------------------------
  Future<File> writeToFile(String data) async {

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath + '/file_01.tmp'; // file_01.tmp is dump file, can be anything
    return new File(filePath).writeAsBytes(base64.decode(data));
  }

  Widget _rejoindreButton() => InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SuivreEvenement(evenement: widget.evenement))),
        child: Container(
          width: 110,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: LightColor.blueLinkedin,/*Color(0xff006a71)*/),
          child: Center(
            child: Text(
              getTranslated(context, 'rejoindre'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "mulish"),
            ),
          ),
        ),
      );

  Widget _validerButton() => InkWell(
        onTap: () => {_valider(widget.evenement)},
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
        onTap: () => {_annuler(widget.evenement)},
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

  _valider(Evenement i) async {
    String _token = await storage.read(key: 'token');
    Map currentUser = json.decode(await storage.read(key: 'currentUser'));
    var response = await http.put(
        Constants.EVENEMENTS + 'cloturer-status/' + "${i.idEvenement}",
        headers: {"Authorization": "Bearer $_token"});
    if (response.statusCode == 200) {
      // create a notification of the save
      notification.Notification notif = new notification.Notification();
      notif.theme = "EVENEMENT";
      notif.isRead = false;
      notif.createdBy = currentUser['username'];
      notif.createdDate = new DateTime.now();
      notif.lastModifiedDate = new DateTime.now();
      notif.message = "l'événement ${i.title} a été cloturée";
      CompteController()
          .sendNotificationToActeurByEmmail(notif, i.createdBy, context)
          .whenComplete(() {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MainScreen(
                  currentPage: 3,
                )));
      });
      Utils.showAlertDialog(context, '${i.title} validée !!');
    } else {
      throw Exception('Erreur !!');
    }
  }

  _annuler(Evenement i) async {
    String _token = await storage.read(key: 'token');
    Map currentUser = json.decode(await storage.read(key: 'currentUser'));
    var response = await http.put(
        Constants.EVENEMENTS + 'rejeter-status/' + "${i.idEvenement}",
        headers: {"Authorization": "Bearer $_token"});
    if (response.statusCode == 200) {
      notification.Notification notif = new notification.Notification();
      notif.createdDate = new DateTime.now();
      notif.createdBy = currentUser['username'];
      notif.lastModifiedDate = new DateTime.now();
      notif.message = "La discusstion ${i.title} a été annulée";
      notif.isRead = false;
      notif.theme = "EVENEMENT";
      // notify the creator of the discussion
      CompteController()
          .sendNotificationToActeurByEmmail(notif, i.createdBy, context)
          .whenComplete(() {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MainScreen(
                  currentPage: 3,
                )));
      });
      Utils.showAlertDialog(context, '${i.title} annulée !!');
      //
    } else {
      throw Exception('Erreur !!');
    }
  }
}
