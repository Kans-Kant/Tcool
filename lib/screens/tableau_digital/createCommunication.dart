import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcool_flutter/controllers/CommunicationController.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/controllers/CoproprieteController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Communication.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/models/Notification.dart' as notification;
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/pages/Title.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';


class CreateCommunication extends StatefulWidget {
  @override
  _createCommunicationState createState() => _createCommunicationState();
}

class _createCommunicationState extends State<CreateCommunication> {
  final storage = FlutterSecureStorage();

  int ref;

  final _formKey = GlobalKey<FormState>();
  int notifcation = 3;
  String _title;
  String _detail;

  File attachment;
  final picker = ImagePicker();

  Compte myAccount = new Compte();

  List<Copropriete> myCoproprietes;

  //------------------ Loading spinner
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getUser();
    getUser();
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
    return Scaffold(
      appBar: MyAppBar2(context),
      backgroundColor: LightColor.white,
      body: Container(
        child: SingleChildScrollView(
          //child: Container(
          child: Column(
            children: <Widget>[
              //NotifWidget(context),
              SizedBox(height: 20),
              AppTitle(getTranslated(context, 'n_com')),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: _communicationContainer(),
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

  //----------------------------------
  Widget _titreField() => Theme(
      data: Theme.of(context).copyWith(
        primaryColor: LightColor.blueLinkedin, /*LightColor.green1*/
      ),
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: getTranslated(context, 'titre'),
          labelText: getTranslated(context, 'titre'),
          fillColor: Colors.white,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
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
      data: Theme.of(context).copyWith(
        primaryColor: LightColor.blueLinkedin, /*LightColor.green1*/
      ),
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: getTranslated(context, 'detail'),
          labelText: getTranslated(context, 'detail'),
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
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
            color: LightColor.blueLinkedin, //LightColor.green,
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
            color: LightColor.blueLinkedin, //LightColor.green,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: textfield,
    );
  }

  //----------------------------------
  Widget _imageButton() => InkWell(
        onTap: () => {_showPicker(context)},
        child: Container(
          width: 230,
          height: 40,
          margin: const EdgeInsets.only(top: 15.0, left: 30.0, right: 30),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.grey[700],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ImageIcon(
                  AssetImage('assets/image.png'),
                  size: 25,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                attachment == null
                    ? Text(
                        getTranslated(context, 'take_picture'),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: "mulish",
                        ),
                      )
                    : Text(
                        getTranslated(context, 'modif_photo'),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: "mulish",
                        ),
                      ),
              ],
            ),
          ),
        ),
      );

  Widget _imageContainer() => Container(
        width: 200,
        height: 140,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(attachment.path),
            fit: BoxFit.cover,
          ),
        ),
      );

  Widget _validButton() => Container(
        //width: 300,
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 30),
        decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), gradient: _gradian()),
        child: MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: Center(
            child: Text(
              getTranslated(context, 'com_publish'),
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontFamily: "mulish",
              ),
            ),
          ),
          onPressed: () => {_confirmation()},
        ),
      );

  // ---------------------------------------
  LinearGradient _gradian() {
    return new LinearGradient(colors: [LightColor.blueLinkedin /*LightColor.green*/, Colors.blue], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 0.0), stops: [0.0, 1.0], tileMode: TileMode.clamp);
  }

  //-----------------------------------------
  Widget _communicationContainer() => Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          decorateTextField(_titreField()),
          SizedBox(height: 20),
          decorateTextParagraph(_detailField()),
          SizedBox(height: 20),
          _imageButton(),
          SizedBox(height: 20),
          attachment == null ? Container() : _imageContainer(),
        ],
      ));

  //-------------------------------------
  validate() async {
    if (_formKey.currentState.validate()) {
      isLoading = true;
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));
      Communication com = new Communication();
      com.title = _title;
      com.details = _detail;
      com.createdBy = currentUser['username'];
      com.createdDate = new DateTime.now();
      com.lastModifiedDate = new DateTime.now();

      myCoproprietes = await getCopropriete() as List;

      if(myCoproprietes.isEmpty){
        Utils.showAlertDialog(context, getTranslated(context, 'error_creat'));
      }

      if(myCoproprietes.isNotEmpty){
        com.copropriete = myCoproprietes[0];
      }

      if (attachment != null) {
        List<int> imageBytes = attachment.readAsBytesSync();
        String base64Image = base64.encode(imageBytes);
        com.attachment = base64Image;
      }

      // create a notification of the save
      notification.Notification notif = new notification.Notification();
      notif.isRead = false;
      notif.createdBy = currentUser['username'];
      notif.createdDate = new DateTime.now();
      notif.lastModifiedDate = new DateTime.now();
      notif.message = "Ajout d'une nouvelle communication ${com.title}";
      notif.theme = "COMMUNICATION";

      //notify the admin that we want to create a discussion
      if(com.copropriete !=null)
      await CommunicationController().saveCommunication(com, context).then((value) {
        ref = value;
        print(ref);
        isLoading = false;
        notif.parentId = ref;
        print(myCoproprietes[0].listResidents);
        for (Compte c in myCoproprietes[0].listResidents) {
          CompteController().sendNotificationToActeur(notif, c.idCompte, context).whenComplete(() => {
                print("notification sent"),
              });
        }
        /*
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainScreen(
                      currentPage: 0,
                    )));
                    */
      });
    }
  }

  getCopropriete() async {
    List<Copropriete> myCopropriets;
    await CoproprieteController().getAllCoproprietesbyCompte(myAccount.idCompte, context).then((value) => {
          print("*****************************************"),
          myCopropriets = value,
        });

    return myCopropriets;
  }

  _confirmation() {
    //if (message.isNotEmpty) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text('Vous postez une nouvelle Communication')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text(
                    "Ce conctenu sera accessible à l'ensemble de votre copropriété. Vous Confirmez ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  FlatButton(
                      child: Text(
                        'Annuler',
                        style: TextStyle(fontSize: 17),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  FlatButton(
                      child: Text(
                        'Publier',
                        style: TextStyle(fontSize: 17),
                      ),
                      onPressed: () {
                        validate();
                        Navigator.of(context).pop();
                      })
                ])
              ],
            ),
          );
        });
    //}
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    var image = await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    if (mounted) {
      setState(() {
        attachment = File(image.path);
      });
    }
  }

  _imgFromGallery() async {
    var image = await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    if (mounted) {
      setState(() {
        attachment = File(image.path);
      });
    }
  }
}
