import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Communication.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/MainScreen.dart';
import 'package:http/http.dart' as http;
import 'package:tcool_flutter/models/Notification.dart' as notification;
import 'package:tcool_flutter/screens/pages/ShowImage.dart';
import 'package:tcool_flutter/screens/pages/Title.dart';
import 'package:tcool_flutter/screens/pages/detail_text.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';

class DetailCommunication extends StatefulWidget {
  final Communication communication;
  final bool type;
  DetailCommunication({Key key, @required this.communication, this.type})
      : super(key: key);

  @override
  DetailCommunicationState createState() => DetailCommunicationState();
}

class DetailCommunicationState extends State<DetailCommunication> {
  Widget _content = CircularProgressIndicator();
  final storage = FlutterSecureStorage();

  int nbrNotification = 0;
  String currentRole;

  //----------------- Loading spinner
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                SizedBox(height: 20),
                isLoading ? const Loading() : _detailCommunicationContainer(),
                SizedBox(height: 50),
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

  Widget _detailCommunicationContainer() => Container(
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
                          .format(widget.communication.createdDate),MediaQuery.of(context).size.width * 0.37,),
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
                  getTranslated(context, 'titre'), widget.communication.title,MediaQuery.of(context).size.width * 0.37,),)
            ],
          ),
        ),
        Divider(height: 2,color: Colors.black,),
        Container(
          child: Row(
            children: <Widget>[
              Icon(Icons.account_circle,color: LightColor.greyLinkedin,),
              Expanded(child: DetailTitle(
                  getTranslated(context, 'auteur'), widget.communication.createdBy,MediaQuery.of(context).size.width * 0.37,),)
            ],
          ),
        ),
        Divider(height: 2,color: Colors.black,),
        Container(
          child: Row(
            children: <Widget>[
              Icon(Icons.account_circle,color: LightColor.greyLinkedin,),
              Expanded(child: DetailTitle(
                  getTranslated(context, 'detail'), widget.communication.details,MediaQuery.of(context).size.width * 0.37,),
              ),
            ],
          ),
        ),

        Divider(height: 2,color: Colors.black,),
        Container(
          child: Row(
            children: <Widget>[
              Icon(Icons.attachment, color: LightColor.greyLinkedin,),
              Expanded(
                child: widget.communication.attachment == null ? Container() : GestureDetector(
                  onTap:(){
                    Navigator.of(this.context).push(MaterialPageRoute(
                        builder: (context) => ShowImage(
                          image:widget.communication.attachment ,
                        )));
                  },
                  child:Container(
                    width:150,
                    height: 140,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(base64.decode(widget.communication.attachment)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                )
            ],
          ),
        ),
      ],
    ),
  );
}
