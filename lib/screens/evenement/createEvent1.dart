import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/controllers/EventController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Evenement.dart';
import 'package:tcool_flutter/models/EvenementDocs.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/evenement/createEvent2.dart';
import 'package:tcool_flutter/models/Notification.dart' as notification;
import 'package:tcool_flutter/screens/pages/Title.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';

class CreateEvent1 extends StatefulWidget {
  @override
  _CreateEvent1State createState() => _CreateEvent1State();
}

class _CreateEvent1State extends State<CreateEvent1> {
  int ref;
  final storage = FlutterSecureStorage();
  List<DropdownMenuItem<String>> visibilitylList = [
    DropdownMenuItem(
      child: Text('Public'),
      value: 'Public',
    ),
    DropdownMenuItem(
      child: Text('Privé Copropriété'),
      value: 'Privé Copropriété',
    )
  ];
  final _formKey = GlobalKey<FormState>();
  String _titre;
  String _detail;
  String selectVisibility = 'Public';
  String _time = null;
  String text_time = 'Select duration';
  Evenement event;

  //to add a date event
  TextEditingController dateCtl = TextEditingController();
  TextEditingController timeCtl = TextEditingController();
  DateTime eventDate;


  //---------------- Loading spinner
  bool isLoading = false;

  //-------------------------------
  File documentFile;

  EvenementDocs eventDOCS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar2(context),
      backgroundColor: LightColor.white,
      body:Container(
        child:isLoading
            ? Center(
          child: const Loading(),
        ):
        SingleChildScrollView(
          child: Container(
            child:Column(
              children: <Widget>[
                SizedBox(height: 20),
                AppTitle(getTranslated(context, 'det_event')),
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: _formContainer(),
                ),
                SizedBox(height: 40),
                _validButton(),
                SizedBox(height: 60),
              ],
            ),
          ),
          ),
        ),
      //  bottomNavigationBar: bottomNav(3)
    );
  }

  //----------------------------------------
  Widget _leftRight() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              icon: SvgPicture.asset('assets/previous.svg'),
              onPressed: () {
                Navigator.pop(context);
              }),
          Text(
            '1/2',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          IconButton(
              icon: SvgPicture.asset('assets/next.svg'), onPressed: () {})
        ],
      );
  //----------------------------------
  Widget _Label(text) => Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "mulish",
          fontSize: 16,
        ),
      );

  //----------------------------------

  Widget _dateHeureField() => TextFormField(
    controller: dateCtl,
    decoration: InputDecoration(
      labelText: "Date",
      border : OutlineInputBorder(),
      /*hintText: getTranslated(context, 'eventDate'),*/),
    onTap: () async{
      DateTime date = DateTime(1900);
      FocusScope.of(context).requestFocus(new FocusNode());

      date = await showDatePicker(
          context: context,
          initialDate:DateTime.now(),
          firstDate:DateTime(1900),
          lastDate: DateTime(2100));

      dateCtl.text = DateFormat('dd/MM/yyyy')
          .format(date);
      eventDate = DateTime.parse(date.toIso8601String());
      },
    validator: (value) {
      if (value.isEmpty) return getTranslated(context, 'ses_field');
      return null;
    },
  );
  //----------------------------------
  Widget _titreField() => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin,/*LightColor.green1*/),
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: getTranslated(context, 'titre'),
          labelText: getTranslated(context, 'titre'),
          fillColor: Colors.white,
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_tit');
          setState(() {
            _titre = value;
          });
          return null;
        },
      ));
  //----------------------------------
  Widget _detailField() => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin,/*LightColor.green1*/),
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: getTranslated(context, 'detail'),
          labelText: getTranslated(context, 'detail'),
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_det');
          setState(() {
            _detail = value;
          });
          return null;
        },
      ));
  //------------------------------------------
  Widget _visibilityField() => DropdownButton(
        items: visibilitylList,
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
  //--------------------------------------
  Widget decorateTextField(Widget textfield) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0, left: 30.0, right: 30),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(const Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: LightColor.blueLinkedin,//LightColor.green,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: textfield,
    );
  }

  //--------------------------------------
  Widget decorateText(Widget text) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0, left: 30.0, right: 30),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(const Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: LightColor.blueLinkedin,//LightColor.green,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: text,
    );
  }

  //--------------------------------------
  Widget decorateTextParagraph(Widget textfield) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: 15.0, left: 30.0, right: 30),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(const Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: LightColor.blueLinkedin,//LightColor.green,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: textfield,
    );
  }

  //----------------------------------------
  /*Widget _validButton() => InkWell(
        onTap: () => {validate()},
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            gradient: _gradian(),
          ),
          child: Center(
            child: Text(
              getTranslated(context, 'valider'),
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontFamily: "mulish",
              ),
            ),
          ),
        ),
      );*/

  Widget _validButton() => Container(
    //width: 300,
    height: 50,
    margin: EdgeInsets.symmetric(horizontal: 30),
    decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        gradient: _gradian()
    ),
    child: MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Center(
        child: Text(
          getTranslated(context, 'valider'),
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontFamily: "mulish",
          ),
        ),
      ),
      onPressed: () =>{validate()},
    ),
  );

  // ---------------------------------------
  LinearGradient _gradian() {
    return new LinearGradient(
        colors: [LightColor.blueLinkedin/*LightColor.green*/, Colors.blue],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp);
  }

  //-----------------------------------------
  Widget _formContainer() => Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          decorateTextField(_dateHeureField()),
          SizedBox(height: 20),
          decorateTextField(_titreField()),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.topLeft,
            child: decorateText(clickable()),
          ),
          SizedBox(height: 20),
          decorateTextParagraph(_detailField()),
          SizedBox(height: 20),
          decorateTextField(_visibilityField()),
          /*SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomLeft,
            child: decorateTextField(_documentField()),
          ),*/
          SizedBox(height: 20),
        ],
      ));
  //-----------------------------------------
  showPickerNumber(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(
            begin: 00,
            end: 99
          ),
          NumberPickerColumn(begin: 00, end: 59),
        ]),
        hideHeader: true,
        title: Text(getTranslated(context, 'plz_sel')),
        selectedTextStyle: TextStyle(color: LightColor.blueLinkedin,/*Color(0xff006a71)*/),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        }).showDialog(context);
  }

  //Widget clickable() => Theme(
      /*data: Theme.of(context).copyWith(primaryColor: LightColor.green1),
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: isNull ? 'Empty field': text_time,
                style: isNull ? TextStyle(color: Colors.red):TextStyle(color: Colors.black),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    DatePicker.showTimePicker(
                      context,
                      showTitleActions: true,

                      onChanged: (date) {},
                      onConfirm: (date) {
                        setState(() {
                          isNull=false;
                          _time = DateFormat('HH:mm:ss').format(date);
                          text_time = _time;
                        });
                      },
                      // Modify to put all to the init value 00
                      currentTime: new DateTime(00),
                    );
                  }),
          ],
        ),
      ));*/

  Widget clickable() => Container(
    width: 250,
    height:50,
    child : TextFormField(
      readOnly: true,
      controller: timeCtl,  // add this line.
      decoration: InputDecoration(
        hintText: 'Select Duration',
        border: InputBorder.none,
      ),
      onTap: () async {
        DateTime picked;

        picked = await DatePicker.showTimePicker(
          context,
          showTitleActions: true,

          onChanged: (date) {},
          onConfirm: (date) {
            setState(() {
              _time = DateFormat('HH:mm:ss').format(date);
              timeCtl.text = _time.toString();
              text_time = _time;
            });
            },
          currentTime: new DateTime(00),
        );
        },
      validator: (value) {
        if (value.isEmpty) {
          return 'cant be empty';
        }
        return null;
        },
    ),
  );

  //-------------- joindre une pièce -------

  Widget _documentField() => InkWell(
    onTap:() {
      getFile();
    },
    child : Container(
      width: 250,
      //height:20,
      child:Row(
          children: <Widget>[
            Icon(Icons.attachment),
            Container(
              margin: EdgeInsets.only(left: 5, top:2),
              child: Text("Join a  file"),
            )
          ]
      ),
    ),
  );

  //---------------- get the join file ------

  getFile() async {

    FilePickerResult result = await FilePicker.platform.pickFiles();

    if(result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);

      EvenementDocs docs = new EvenementDocs();
      docs.name = file.name;
      docs.content = base64.encode(file.bytes);
      docs.extension = file.extension;

      this.setState(() {
        documentFile = File(result.files.single.path);
        eventDOCS =docs;
      });
    }
  }

  //-----------------------------------------
  validate() async {
    print(_time);
    if (_formKey.currentState.validate() && _time !=null) {
      isLoading = true;
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));
      Evenement evenement = new Evenement();
      evenement.title = _titre;
      print(_time);
      evenement.duration = _time;
      evenement.eventDate = eventDate;
      //EvenementDocs evenementDocs;
      if (documentFile != null) {
        List<int> imageBytes = documentFile.readAsBytesSync();
        String base64Image = base64.encode(imageBytes);
        evenement.documents.add(eventDOCS);
      }

      evenement.details = _detail;
      evenement.visibility = selectVisibility;
      evenement.status = "EN COURS";
      evenement.createdDate = new DateTime.now();
      evenement.lastModifiedDate = new DateTime.now();
      evenement.createdBy = currentUser['username'];

      // create a notification of the save
      notification.Notification notif = new notification.Notification();
      notif.isRead = false;
      notif.createdBy = currentUser['username'];
      notif.createdDate = new DateTime.now();
      notif.lastModifiedDate = new DateTime.now();
      notif.message = "Création événement ${evenement.title}";
      notif.theme = "EVENEMENT";

      await EventController().saveEvent(evenement, context).then((value) {
        ref = value;
        print(ref);
        notif.parentId = ref;
        CompteController()
            .sendNotificationToAdmin(notif, context)
            .whenComplete(() =>{
              isLoading = false,
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => createEvent2(
                      ref: ref,
                    )))});
      });
    }
  }
}
