import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/controllers/DiscussionController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/models/Notification.dart' as notification;
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/dicsussion/createDiscussion3.dart';
import 'package:tcool_flutter/screens/pages/Title.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';

import 'createDiscussion3.dart';

class CreateDiscussion2 extends StatefulWidget {
  final String theme;
  CreateDiscussion2({Key key, this.theme}) : super(key: key);
  @override
  _createDiscussion2State createState() => _createDiscussion2State();
}

class _createDiscussion2State extends State<CreateDiscussion2> {
  final storage = FlutterSecureStorage();

  int ref;

  List<DropdownMenuItem<String>> visibilitylList = [
    DropdownMenuItem(
      child: Text('Public'),
      value: 'Public',
    ),
    DropdownMenuItem(
      child: Text('Privé'),
      value: 'Private',
    )
  ];
  final _formKey = GlobalKey<FormState>();
  int notifcation = 3;
  String _title;
  String _detail;
  String selectVisibility = 'Public';

  //------------------ Loading spinner
  bool isLoading =false;


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
          //child: Container(
            child:Column(
              children: <Widget>[
                //NotifWidget(context),
                SizedBox(height: 20),
                AppTitle(getTranslated(context, 'det_dis')),
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: _formContainer(),
                ),
                SizedBox(height: 40),
                _validButton(),
                SizedBox(height: 60),
              ],
            //),
          ),
        ),
        //   bottomNavigationBar: bottomNav(1)
       ),
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
            '2/3',
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
            _title = value;
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
  /*Widget _validButton() => RaisedButton(
        onPressed: () => {validate()},
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
      onPressed: () => {validate()},
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
          decorateTextField(_titreField()),
          SizedBox(height: 20),
          decorateTextParagraph(_detailField()),
          SizedBox(height: 20),
          decorateTextField(_visibilityField()),
          SizedBox(height: 20),
        ],
      ));

  validate() async {
    if (_formKey.currentState.validate()) {
      isLoading =true;
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));
      Discussion discussion = new Discussion();
      discussion.theme = widget.theme;
      discussion.title = _title;
      discussion.details = _detail;
      discussion.visibility = selectVisibility;
      discussion.status = "EN COURS";
      discussion.createdBy = currentUser['username'];
      discussion.createdDate = new DateTime.now();
      discussion.lastModifiedDate = new DateTime.now();

      // create a notification of the save
      notification.Notification notif = new notification.Notification();
      notif.isRead = false;
      notif.createdBy = currentUser['username'];
      notif.createdDate = new DateTime.now();
      notif.lastModifiedDate = new DateTime.now();
      notif.message = "Création discussion ${discussion.title}";
      notif.theme = "DISCUSSION";

      //DiscussionController().saveDiscussion(discussion, context);
      // notify the admin that we want to create a discussion
      await DiscussionController().saveDiscussion(discussion, context).then((value) {
        ref = value;
        print(ref);
        isLoading = false;
        notif.parentId = ref;

            CompteController().sendNotificationToAdmin(notif, context).whenComplete(
                () =>
            {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => createDiscussion3(
                  ref: ref,
                )),
              ),
            });
      });

    }
  }
}
