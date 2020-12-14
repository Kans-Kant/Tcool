import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/controllers/InterventionController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Intervention.dart';
import 'package:tcool_flutter/resources/GmapLocations.dart';
import 'package:tcool_flutter/resources/utils.dart';
//import 'package:tcool_flutter/screens/AppBarWidget.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/NotifWidget.dart';
import 'package:tcool_flutter/screens/intervention/RecordAudio.dart';
import 'package:tcool_flutter/screens/intervention/RequestIntervention_3.dart';
import 'package:tcool_flutter/screens/pages/MapScreen.dart';
import 'package:tcool_flutter/models/Notification.dart' as notification;
import 'package:tcool_flutter/screens/pages/Title.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';

class RequestIntervention2 extends StatefulWidget {
  final String theme;
  RequestIntervention2({Key key, this.theme}) : super(key: key);
  @override
  _RequestIntervention2State createState() => _RequestIntervention2State();
}

class _RequestIntervention2State extends State<RequestIntervention2> {
  int ref;
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  final storage = FlutterSecureStorage();
  Widget _content = CircularProgressIndicator();
  final _formKey = GlobalKey<FormState>();
  String _titre;
  String _detail;
  String _emplacement;
  String location;
  File imageFile;
  final picker = ImagePicker();
  String audioFile;

  //------------------ loading spinner ---------------------
  bool isLoading = false;

  @override
  Widget build0(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar2(context),
      backgroundColor: LightColor.white,
      body: Container(
        child: isLoading
            ? Center(
                child: const Loading(),
              )
            : SingleChildScrollView(
                child: Container(
                  child: FutureBuilder(
                      future: GmapLocations.currentStringLocation(),
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        if (!snapshot.hasData) return Container();
                        location = snapshot.data;
                        _emplacement = location;
                        return Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            AppTitle(getTranslated(context, 'det_inter')),
                            SizedBox(height: 30),
                            Form(
                              key: _formKey,
                              child: _formContainer(),
                            ),
                            SizedBox(height: 40),
                            _validButton(),
                            SizedBox(height: 60),
                          ],
                        );
                      }),
                ),
              ),
      ),
    );
    //  bottomNavigationBar: bottomNav(2)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar2(context),
      backgroundColor: LightColor.white,
      body: Container(
        child: isLoading
            ? Center(
                child: const Loading(),
              )
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      AppTitle(getTranslated(context, 'det_inter')),
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
    );
    //  bottomNavigationBar: bottomNav(2)
  }

  //----------------------------------------
  Widget _leftRight() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              icon: SvgPicture.asset('assets/previous.svg'),
              onPressed: () {
                Navigator.pop(this.context);
              }),
          Text(
            '2/3',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          IconButton(icon: SvgPicture.asset('assets/next.svg'), onPressed: () {})
        ],
      );

  //----------------------------------
  Widget _titreLabel() => Text(
        getTranslated(context, 'titre'),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "mulish",
          fontSize: 16,
        ),
      );

  //----------------------------------
  Widget _detailLabel() => Text(
        getTranslated(context, 'detail'),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "mulish",
          fontSize: 16,
        ),
      );

  //----------------------------------
  Widget _emplacementLabel() => Text(
        getTranslated(context, 'emplacement'),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "mulish",
          fontSize: 16,
        ),
      );

  //----------------------------------
  Widget _audioLabel() => Text(
        getTranslated(context, 'audio'),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "mulish",
          fontSize: 16,
        ),
      );

  //----------------------------------
  Widget _imagesLabel() => Text(
        getTranslated(context, 'image'),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "mulish",
          fontSize: 16,
        ),
      );

  //----------------------------------
  Widget _titreField() => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin /*LightColor.green1*/),
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
            _titre = value;
          });
          return null;
        },
      ));
  //----------------------------------
  Widget _detailField() => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin /*LightColor.green1*/),
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

  //----------------------------------
  Widget _audioButton() => InkWell(
        onTap: () => {_navigateToAudioScreen()},
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
                SvgPicture.asset('assets/audio.svg'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  getTranslated(context, 'take_audio'),
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

  //----------------------------------
  Widget _imageButton() => InkWell(
        onTap: () => {_showSelectionDialog(this.context)},
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
                imageFile == null
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
  //----------------------------------
  Widget _emplacementField() => Theme(
      data: Theme.of(context).copyWith(
        primaryColor: LightColor.blueLinkedin, /*LightColor.green1*/
      ),
      child: TextFormField(
        readOnly: true,
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: getTranslated(context, 'emplacement'),
          labelText: getTranslated(context, 'emplacement'),
          fillColor: Colors.white,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
        ),
        inputFormatters: [
          new LengthLimitingTextInputFormatter(40), // for mobile
        ],
        initialValue: _emplacement,
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_empl');
          setState(() {
            _emplacement = value;
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
  Widget decorateText(Widget textfield) {
    return Container(
      width: 180,
      height: 40,
      // margin: EdgeInsets.symmetric(horizontal: 50),
      //margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: LightColor.blueLinkedin, /*Color(0xff006a71)*/
        ),
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

//-----------------------------------------
  Widget _formContainer() => Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          decorateTextField(_titreField()),
          SizedBox(
            height: 10,
          ),
          decorateTextParagraph(_detailField()),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.topLeft,
            child: _audioButton(),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.topLeft,
            child: _imageButton(),
          ),
          SizedBox(height: 10),
          FutureBuilder(
              future: GmapLocations.currentStringLocation(),
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (!snapshot.hasData)
                  return Container(
                    //margin: EdgeInsets.all(5),
                    child: Text(getTranslated(context, 'ses_empl')),
                  );
                location = snapshot.data;
                _emplacement = location;
                return decorateTextField(_emplacementField());
              }),
          SizedBox(height: 7),
          _map()
        ],
      ));

  //----------------------------------------
  Widget _map() => Column(
        children: <Widget>[
          IconButton(
            icon: SvgPicture.asset(
              'assets/map.svg',
              color: LightColor.blueLinkedin,
            ),
            onPressed: () {
              viewOnMap();
            },
          ),
          Text(getTranslated(context, 'map'),
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: LightColor.blueLinkedin, //Color(0xff006a71),
                  fontFamily: "mulish"))
        ],
      );
  //----------------------------------------
  /*Widget _validButton() => InkWell(
        onTap: () => {_validate()},
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
        decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), gradient: _gradian()),
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
          onPressed: () => {_validate()},
        ),
      );

  // ---------------------------------------
  LinearGradient _gradian() {
    return new LinearGradient(colors: [LightColor.blueLinkedin /*LightColor.green*/, Colors.blue], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 0.0), stops: [0.0, 1.0], tileMode: TileMode.clamp);
  }

  viewOnMap() async {
    if (_formKey.currentState.validate() && _emplacement != null) {
      await Navigator.of(this.context).push(MaterialPageRoute(builder: (context) => MapScreen(location: _emplacement)));
    }
  }

  _validate() async {
    if (_formKey.currentState.validate() && location != null) {
      isLoading = true;

      Map currentUser = json.decode(await storage.read(key: 'currentUser'));
      Intervention intervention = new Intervention();
      intervention.theme = widget.theme;
      intervention.title = _titre;
      intervention.details = _detail;
      intervention.intervenant = null;
      print(audioFile);

      if (imageFile != null) {
        List<int> imageBytes = imageFile.readAsBytesSync();
        String base64Image = base64.encode(imageBytes);
        intervention.images = base64Image;
      }

      // Adding Audio element
      intervention.audio = audioFile;

      intervention.createdDate = new DateTime.now();
      intervention.lastModifiedDate = new DateTime.now();
      intervention.location = _emplacement;
      Position p = await GmapLocations.currentPosition();
      intervention.latitude = p.latitude;
      intervention.longitude = p.longitude;
      intervention.status = "VALIDER";
      intervention.createdBy = currentUser['username'];

      // create a notification of the save
      notification.Notification notif = new notification.Notification();
      notif.isRead = false;
      notif.createdBy = currentUser['username'];
      notif.createdDate = new DateTime.now();
      notif.lastModifiedDate = new DateTime.now();
      notif.theme = "INTERVENTION";
      notif.message = "Création intervention ${intervention.title}";

      await InterventionController().saveIntervention(intervention, context).then((value) {
        ref = value;
        print(ref);

        notif.parentId = ref;
        CompteController().sendNotificationGestionnaire(notif, context).whenComplete(() => {
          isLoading = false,
        });

      });
      Navigator.of(this.context).push(MaterialPageRoute(
          builder: (context) => RequestIntervention3(
                ref: ref,
              )));
    }
  }

  _navigateToAudioScreen() async {
    final result = await Navigator.of(this.context).push(MaterialPageRoute(builder: (context) => RecordAudio(audioFileName: this.audioFile)));
    setState(() {
      this.audioFile = result;
    });
    print('request intervention' + '${this.audioFile}');
  }

  //-------------------------------------------------------------
  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(getTranslated(context, 'type_pic')),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text(getTranslated(context, 'gallery')),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text(getTranslated(context, 'camera')),
                      onTap: () {
                        getImageCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void _openGallery(BuildContext context) async {
    var picture = await picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = File(picture.path);
    });
    Navigator.of(context).pop();
    showDialog1();
  }

  Future getImageCamera(BuildContext context) async {
    var picture = await picker.getImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(picture.path);
    });
    Navigator.of(context).pop();
    showDialog1();
  }

  showDialog1() {
    if (this.imageFile != null) {
      Utils.showAlertDialog(context, getTranslated(context, 'add_image'));
    }
  }
}
