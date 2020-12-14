import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:tcool_flutter/screens/AppBarWidget.dart';
import 'package:tcool_flutter/screens/pages/ConfirmationAccountPage.dart';
import 'package:tcool_flutter/screens/pages/LoginPage.dart';
import 'package:http/http.dart' as http;
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';

import '../acceuil.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final storage = new FlutterSecureStorage();

  String _nom;
  String _prenom;
  String _immeuble;
  String _appartement;
  String _telephone;
  String _email;
  String _password;
  String _confpwd;
  String selectProfil = 'RESIDENT';

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


  //-------------------------------- loading spinner
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: LightColor.white,
        body: Container(
          child:isLoading
              ? Center(
            child: const Loading(),
          ):
          SingleChildScrollView(
              child:Center(
                  child :Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 70,
                      ),
                      _icon(),
                      SizedBox(height: 30),
                      Form(
                        key: _formkey,
                        child: _signupContainer(),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      _validateButton(),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(getTranslated(context, 'compte_existant'),
                          style: TextStyle(
                            fontSize: 16,
                          ),),
                          _connexion(),
                      ],),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ))) ,
        )
    );
  }

  //----------------------------
  Widget _titlePage() {
    return Container(
      height: 80,
      child: Column(children: <Widget>[
        Text(
          getTranslated(context, 'creat_cpt'),
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 26,fontFamily: "mulish"),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: 30,
          height: 5,
          decoration: BoxDecoration(
            color: LightColor.blueLinkedin//LightColor.green,
          ),
        ),
      ]),
    );
  }

  //-----------------------------
  Widget _nomField() => Theme(
      data: Theme.of(context)
          .copyWith(primaryColor: LightColor.blueLinkedin,/*LightColor.green*/),
      child: TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: getTranslated(context, 'nom'),
            labelStyle: TextStyle(fontSize: 16),
            fillColor: Colors.white,
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value.isEmpty) return getTranslated(context, 'ses_nom');
            if (value.isNotEmpty && value.length < 2)
              return getTranslated(context, 'invalide');
            setState(() => _nom = value);
            return null;
          }));

  Widget _prenomField() => Theme(
      data: Theme.of(context)
          .copyWith(primaryColor: LightColor.blueLinkedin/*LightColor.green*/),
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: getTranslated(context, 'prenom'),
          labelStyle: TextStyle(fontSize: 16),
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_pre');
          if (value.isNotEmpty && value.length < 2)
            return getTranslated(context, 'invalide');
          setState(() {
            _prenom = value;
          });
          return null;
        },
      ));

  //----------------------------------------
  Widget _immeubleField() => Theme(
      data: Theme.of(context)
          .copyWith(primaryColor: LightColor.blueLinkedin/*LightColor.green*/),
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: getTranslated(context, 'immeuble'),
          labelStyle: TextStyle(fontSize: 16),
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

  //----------------------------------------
  Widget _appartementField() => Theme(
      data: Theme.of(context)
          .copyWith(primaryColor: LightColor.blueLinkedin/*LightColor.green*/),
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: getTranslated(context, 'apart'),
          labelStyle: TextStyle(fontSize: 16),
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

  //------------------------------------------
  Widget _emailField() => Theme(
      data: Theme.of(context)
          .copyWith(primaryColor: LightColor.blueLinkedin/*Color(0xff006a71)*/),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: getTranslated(context, 'mail'),
          labelStyle: TextStyle(fontSize: 16),
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_em');
          if (value.isNotEmpty && !value.contains('@'))
            return getTranslated(context, 'invalide');
          setState(() {
            _email = value;
          });
          return null;
        },
      ));

  //------------------------------------------
  Widget _phoneField() => Theme(
      data: Theme.of(context)
          .copyWith(primaryColor: LightColor.blueLinkedin/*Color(0xff006a71)*/),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: getTranslated(context, 'telephone'),
          labelStyle: TextStyle(fontSize: 16),
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'saisir_tel');
          if (value.isNotEmpty && value.length < 10)
            return getTranslated(context, 'tel_invalide');
          setState(() {
            _telephone = value;
          });
          return null;
        },
      ));

  //------------------------------------------
  Widget _passwordField() => Theme(
      data: Theme.of(context)
          .copyWith(primaryColor: LightColor.blueLinkedin,/*Color(0xff006a71)*/),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        decoration: InputDecoration(
          labelText: getTranslated(context, 'password'),
          labelStyle: TextStyle(fontSize: 16),
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'saisir_pass');
          if (value.isNotEmpty && value.length < 6)
            return getTranslated(context, 'mdp_court');
          setState(() {
            _password = value;
          });
          return null;
        },
      ));

  //------------------------------------------
  Widget _confpwdField() => Theme(
      data: Theme.of(context)
          .copyWith(primaryColor: LightColor.blueLinkedin,/*Color(0xff006a71)*/),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        decoration: InputDecoration(
          labelText: getTranslated(context, 'confirmer'),
          labelStyle: TextStyle(fontSize: 16),
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'saisir_pass');
          if (value.isNotEmpty && value != _password)
            return getTranslated(context, 'ses_mdp');
          setState(() {
            _confpwd = value;
          });
          return null;
        },
      ));

  //------------------------------------------
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
  //--------------------------------------
  Widget decorateTextField(Widget textfield) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0, left: 30.0, right: 30),
      padding: const EdgeInsets.only(top:2,bottom:2,right:9,left:20),//cEdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        //border: Border.all(width: 2, color: Color(0xff006a71)),
        borderRadius: BorderRadius.all(const Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: LightColor.blueLinkedin,//LightColor.green,
            blurRadius: 3.0,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: textfield,
    );
  }

  Widget dTextField(Widget textfield) {
    return Container(
      width: 250,
      height: 50,
      margin: const EdgeInsets.only(top: 15.0, left: 30.0, right: 30),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2, color: LightColor.blueLinkedin/*Color(0xff006a71)*/),
        borderRadius: BorderRadius.all(const Radius.circular(10)),
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
 //--------------------------------
          Widget _icon() => Column(
              children: <Widget>[
               Image.asset(
                        'assets/SUN SQUARE ALMAZ.jpg',
                        fit: BoxFit.cover, // this is the solution for border
                        width: 120.0,
                        height: 120.0,
                      ),
                /*Text(
                  "TCOOL",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff006a71),
                    fontFamily: "Mulish",
                  ),
                ),*/
              ],
            );
  //----------------------------------------
  Widget _formLabel(String label) => Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          fontFamily: "mulish",
        ),
      );
  //-----------------------------------------
  Widget _signupContainer() => Container(
          //width: 350,
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          decorateTextField(_nomField()),
          SizedBox(
            height: 10,
          ),
          decorateTextField(_prenomField()),
          SizedBox(
            height: 10,
          ),
          decorateTextField(_immeubleField()),
          SizedBox(
            height: 10,
          ),
          decorateTextField(_appartementField()),
          SizedBox(
            height: 10,
          ),
          decorateTextField(_emailField()),
          SizedBox(
            height: 10,
          ),
          decorateTextField(_phoneField()),
          SizedBox(
            height: 10,
          ),
          decorateTextField(_passwordField()),
          SizedBox(
            height: 10,
          ),
          decorateTextField(_confpwdField()),
          SizedBox(
            height: 10,
          ),
          decorateTextField(_profilField()),
        ],
      ));

  //--------------------------------
  /*Widget _validateButton() => InkWell(
        onTap: () {
          signup();
        },
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: _gradian(),
          ),
          child: Center(
            child: Text(
              getTranslated(context, 'valider'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,fontFamily: "mulish"),
            ),
          ),
        ),
      );*/

  Widget  _validateButton() => Container(
    //width: 300,
    height: 50,
    margin: EdgeInsets.symmetric(horizontal: 30),
    /*decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        gradient: _gradian()
    ),*/
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(const Radius.circular(50)),
      gradient: _gradian(),
      boxShadow: [
        BoxShadow(
          color: LightColor.blueLinkedin,//LightColor.green,
          blurRadius: 5.0,
          offset: Offset(0, 2),
        )
      ],
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
      onPressed: () => {signup()},
    ),
  );

  // ---------------------------------------
  LinearGradient _gradian() {
    return new LinearGradient(
        colors: [LightColor.blueLinkedin/*LightColor.green*/,Colors.blue /*LightColor.green1*/],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp);
  }

  //-------------------------------------
  Widget _connexion() => Container(
        child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              getTranslated(context, 'connexion'),
              style: TextStyle(
                  //decoration: TextDecoration.underline,
                  fontFamily: "mulish",
                  fontSize: 18,
                  color: Colors.red),
            )),
      );

  //------------------------------------
  signup() async {
    if (_formkey.currentState.validate()) {
      isLoading = true;
      print('nom ' + _nom);
      print('prénom ' + _prenom);
      print('appartement' + _appartement);
      print('residene ' + _immeuble);
      print('email ' + _email);
      print('tel ' + _telephone);
      print('mdp ' + _password);
      print('conf mdp ' + _confpwd);
      print('profil ' + selectProfil);
      Map body = {
        "createdBy": 'KF2Y',
        "firstName": _nom,
        "lastName": _prenom,
        "immeuble": _immeuble,
        "appartement": _appartement,
        "email": _email,
        "phone": _telephone,
        "password": _password,
        "myRole": selectProfil,
        "avatar": null,
      };

      try {
        var response = await http.post(
          Constants.SIGNUP,
          headers: {"Content-Type": "application/json"},
          body: json.encode(body),
        );
        if (response.statusCode == 200) {
          isLoading =false;
          Map bodyAuth = {'username': _email, 'password': _password};
          //await login(bodyAuth);
          // Account created successfully
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ConfirmationAccountPage(
                loginData : bodyAuth,
              )));
        } else {
          if (response.statusCode == 400) {
            // Login already taken
            this.setState(() {
              isLoading = false;
            });
            Map parsed = json.decode(response.body);
            Utils.showAlertDialog(context, parsed['message']);
          } else {
            isLoading = true;
            throw new Exception("Error!");
          }
        }
      } catch (e) {
        isLoading = false;
        Utils.showAlertDialog(context, getTranslated(context, 'error_creat'));
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Acceuil()));
      }
    }
  }

  //--------------------------------
  /*Future login(Map body) async {
    // authentification jwt dans le BE
    isLoading= true;
    try {
      var response = await http.post(Constants.LOGIN,
          headers: {"Content-Type": "application/json"},
          body: json.encode(body));
      if (response.statusCode == 200) {
        isLoading = false;
        Map parsed = json.decode(response.body);
        //local storage
        await storage.write(key: 'token', value: parsed['token']);
        await storage.write(
            key: 'currentUser', value: json.encode(parsed['currentUser']));
      } else {
        isLoading=false;
        throw new Exception("Error!");
      }
    } catch (e) {isLoading=false;}
  }*/
}
