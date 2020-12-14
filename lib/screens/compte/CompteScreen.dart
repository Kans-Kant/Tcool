import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/screens/pages/ShowImage.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';
import 'package:http/http.dart' as http;

class CompteScreen extends StatefulWidget {
  @override
  _CompteScreenState createState() => _CompteScreenState();
}

class _CompteScreenState extends State<CompteScreen> with TickerProviderStateMixin{
  String dateCreation;
  String _nom;
  String _prenom;
  String _immeuble;
  String _appartement;
  String _telephone;
  String _email;
  String _password;
  String _confpwd;
  String selectProfil;
  final storage = FlutterSecureStorage();
  Widget _content = CircularProgressIndicator();
  Compte myAccount;

  int userId;

  //update of amelioration
  File _avatar;
  String avatartemp;
  final picker = ImagePicker();

  final String path = 'assets/uploads/';

  List<DropdownMenuItem<String>> profilList = [
    DropdownMenuItem(
      child: Text('Résident'),
      value: 'RESIDENT',
    ),
    DropdownMenuItem(
      child: Text('Gestionnaire'),
      value: 'GESTIONNAIRE',
    ),
    DropdownMenuItem(
      child: Text('Intervenant'),
      value: 'INTERVENANT',
    ),
  ];

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPassword();
  }

  getPassword() async {
    _password = await storage.read(key: 'password');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Form(
            key: _formkey,
            child: _container(),
          ),
          SizedBox(
            height: 40,
          ),
          _updateButton(),
          SizedBox(
            height: 30,
          ),
        ])));
  }

  //-----------------------------------------
  Widget decorateTextField(Widget textfield) {
    return Container(
      //width: 230,
      //height: 70,
      margin: const EdgeInsets.only(top: 15.0, left: 30.0, right: 30),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(const Radius.circular(10)),
        // border: Border.all(width: 1, color: LightColor.green1),
        boxShadow: [
          BoxShadow(
            color: LightColor.blueLinkedin /*LightColor.green*/,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: textfield,
    );
  }

  //-----------------------------------------
  Widget _formLabel(String label) => Text(
        label,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
      );
  //-----------------------------------------
  Widget _nomField(String title) => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin /*LightColor.green1*/),
      child: TextFormField(
          initialValue: title,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: getTranslated(context, 'nom'),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
            fillColor: Colors.white,
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value.isEmpty) return getTranslated(context, 'ses_nom');
            if (value.isNotEmpty && value.length < 2) return getTranslated(context, 'invalide');
            setState(() => _nom = value);
            return null;
          }));
  //-----------------------------------------
  Widget _prenomField(String title) => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin /*LightColor.green1*/),
      child: TextFormField(
        initialValue: title,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: getTranslated(context, 'prenom'),
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_pre');
          if (value.isNotEmpty && value.length < 2) return getTranslated(context, 'invalide');
          setState(() {
            _prenom = value;
          });
          return null;
        },
      ));

  //-----------------------------------------
  Widget _immeubleField(String title) => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin /*LightColor.green1*/),
      child: TextFormField(
        initialValue: title,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: getTranslated(context, 'immeuble'),
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_imm');
          setState(() {
            _immeuble = value;
          });
          return null;
        },
      ));

  //-----------------------------------------
  Widget _appartementField(String title) => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin /*LightColor.green1*/),
      child: TextFormField(
        initialValue: title,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: getTranslated(context, 'apart'),
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_apart');
          setState(() {
            _appartement = value;
          });
          return null;
        },
      ));
  //-----------------------------------------
  Widget _phoneField(String title) => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin /*LightColor.green1*/),
      child: TextFormField(
        initialValue: title,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: getTranslated(context, 'telephone'),
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_tel');
          if (value.isNotEmpty && value.length < 10) return getTranslated(context, 'invalide');
          setState(() {
            _telephone = value;
          });
          return null;
        },
      ));
  //-----------------------------------------
  Widget _emailField(String title) => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin /*LightColor.green1*/),
      child: TextFormField(
        initialValue: title,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: getTranslated(context, 'mail'),
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_em');
          if (value.isNotEmpty && !value.contains('@')) return getTranslated(context, 'invalide');
          setState(() {
            _email = value;
          });
          return null;
        },
      ));
  //-----------------------------------------
  Widget _passwordField(String title) => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin /*LightColor.green1*/),
      child: TextFormField(
        initialValue: title,
        obscureText: true,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: getTranslated(context, 'password'),
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_mdp');
          if (value.isNotEmpty && value.length < 6) return getTranslated(context, 'trop_court');
          setState(() {
            _password = value;
          });
          return null;
        },
      ));
  //-----------------------------------------
  Widget _confpwdField(String title) => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin /*LightColor.green1*/),
      child: TextFormField(
        initialValue: title,
        obscureText: true,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: getTranslated(context, 'confirmer'),
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_mdp');
          if (value.isNotEmpty && value != _password) return getTranslated(context, 'ses_mdp');
          setState(() {
            _confpwd = value;
          });
          return null;
        },
      ));
  //-----------------------------------------
  Widget _profilField() => DropdownButton(
        items: profilList,
        underline: Container(
          decoration: BoxDecoration(color: Colors.white),
        ),
        value: selectProfil,
        onChanged: (value) {
          setState(() {
            selectProfil = value;
          });
        },
        isExpanded: true,
      );
  //-----------------------------------------
  Widget _container() => FutureBuilder(
      future: CompteController().getCurrentAccount(context),
      builder: (context, AsyncSnapshot<Compte> snapshot) {
        print(snapshot);
        if (!snapshot.hasData) return Loading();
        dateCreation = DateFormat('dd MMMM yyyy').format(snapshot.data.createdDate);
        selectProfil = snapshot.data.myRoles[0].role;
        myAccount = new Compte();
        myAccount = snapshot.data;
        return Container(
            // width: 350,
            child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
                child: Text(
              '${getTranslated(context, 'Cre_acc')} : $dateCreation',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: "mulish"),
            )),
            SizedBox(height: 40),
            _profilphoto(snapshot.data.avatar),
            decorateTextField(_nomField("${snapshot.data.firstName}")),
            SizedBox(
              height: 15,
            ),
            decorateTextField(_prenomField("${snapshot.data.lastName}")),
            SizedBox(
              height: 15,
            ),
            decorateTextField(_immeubleField("${snapshot.data.immeuble}")),
            SizedBox(
              height: 15,
            ),
            decorateTextField(_appartementField("${snapshot.data.appartement}")),
            SizedBox(
              height: 15,
            ),
            decorateTextField(_emailField("${snapshot.data.email}")),
            SizedBox(
              height: 15,
            ),
            decorateTextField(_phoneField("${snapshot.data.phone}")),
            SizedBox(
              height: 15,
            ),
            decorateTextField(_passwordField("$_password")),
            SizedBox(
              height: 15,
            ),
            decorateTextField(_confpwdField("$_password")),
            SizedBox(
              height: 15,
            ),
            Utils.isAdmin(selectProfil) ? Container(width: 0, height: 0) : decorateTextField(_profilField())
          ],
        ));
      });
  //--------------------------------
  Widget _updateButton() => InkWell(
        onTap: () {
          updateAccount();
          //Navigator.of(context).push(MaterialPageRoute(
          // builder: (context) => DetailsOperation()));
        },
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), gradient: _gradian()),
          child: Center(
            child: Text(
              getTranslated(context, 'majData'),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: "mulish"),
            ),
          ),
        ),
      );

  // ---------------------------------------
  LinearGradient _gradian() {
    return new LinearGradient(colors: [LightColor.blueLinkedin /*LightColor.green*/, LightColor.green1], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 0.0), stops: [0.0, 1.0], tileMode: TileMode.clamp);
  }

  updateAccount() async {
    if (_formkey.currentState.validate()) {
      myAccount.firstName = _nom;
      myAccount.lastName = _prenom;
      myAccount.immeuble = _immeuble;
      myAccount.appartement = _appartement;
      myAccount.email = _email;
      myAccount.phone = _telephone;
      myAccount.password = _password;
      myAccount.lastModifiedDate = new DateTime.now();
      myAccount.lastModifiedBy = myAccount.createdBy;

      if (_avatar != null) {
        List<int> imageBytes = _avatar.readAsBytesSync();
        String base64Image = base64.encode(imageBytes);
        myAccount.avatar = base64Image;
      } else {
        myAccount.avatar = avatartemp;
      }

      Map body = {'username': _email, 'password': _password};

      //updatedAccount.myRoles[0].ro
      CompteController().updateAccount(myAccount, context).whenComplete(() => {login(body)});
      Scaffold.of(context).showSnackBar(Utils().showSnackBar(getTranslated(context, 'maj_eff')));
    } else {
      print('Error to update!');
    }
  }

  //--------------------------------
  Future login(Map body) async {
    // authentification jwt dans le BE
    try {
      var response = await http.post(Constants.LOGIN, headers: {"Content-Type": "application/json"}, body: json.encode(body));
      if (response.statusCode == 200) {
        Map parsed = json.decode(response.body);
        //local storage
        await storage.write(key: 'token', value: parsed['token']);
        await storage.write(key: 'currentUser', value: json.encode(parsed['currentUser']));
      } else {
        throw new Exception("Error!");
      }
    } catch (e) {}
  }

  // ---------------------------------------
  Widget _profilphoto(String avatar) => Container(
        height: 250.0,
        color: Colors.white,
        child: new Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: new Stack(fit: StackFit.loose, children: <Widget>[
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new GestureDetector(
                      onTap: () {
                        Navigator.of(this.context).push(MaterialPageRoute(
                            builder: (context) => ShowImage(
                                  image: avatar,
                                )));
                      },
                      child: Container(
                          width: 140.0,
                          height: 140.0,
                          child: CircleAvatar(
                            backgroundImage: avatarShow(avatar), //_avatar != null  ? new ExactAssetImage(_avatar.path) : MemoryImage(base64.decode(avatar ==null ?avatar : (base64.encode(avatartemp.readAsBytes())))) ,
                            backgroundColor: Colors.blueGrey[50],
                          ),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                          )),
                    ),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(top: 90.0, left: 100.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new MaterialButton(
                          onPressed: () {
                            _showPicker(context);
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Icon(
                            Icons.camera_alt,
                            size: 24,
                          ),
                          padding: EdgeInsets.all(16),
                          shape: CircleBorder(),
                        )
                      ],
                    )),
              ]),
            )
          ],
        ),
      );

  avatarShow(String avatar) {
    if (_avatar == null) {
      if (avatar != null) {
        avatartemp = avatar;
        return MemoryImage(base64.decode(avatar));
      }
    }
    if (_avatar != null) {
      return new ExactAssetImage(_avatar.path);
    } else {
      return new ExactAssetImage("assets/user.jpg");
    }
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
    final image = await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    if (mounted) {
      setState(() {
        _avatar = File(image.path);
      });
    }
  }

  _imgFromGallery() async {
    final image = await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    if (mounted) {
      setState(() {
        _avatar = File(image.path);
      });
    }
  }
}
