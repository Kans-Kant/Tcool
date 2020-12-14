import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/screens/AppBarWidget3.dart';
import 'package:tcool_flutter/screens/NotifWidget.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';

import '../AppBarWidget.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final storage = FlutterSecureStorage();
  String selectVisibility = 'Public';
  int nbrNotification = 0;
  final _formkey = GlobalKey<FormState>();
  String _nom;
  String _prenom;
  String _telephone;
  String _email;
  String _password;
  String _confpwd;
  String selectProfil = 'RESIDENT';
  final _scaffold = new GlobalKey<ScaffoldState>();
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

  //----------------------- loading spinner ---------------
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: MyAppBar3(context),
      backgroundColor: LightColor.background,
      body: ListView(
        padding: EdgeInsets.all(15),
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 20),
          Align(
              child: Text(
            getTranslated(context, 'add_usr'),
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: "mulish"),
          )),
          SizedBox(height: 30),
          Form(
            key: _formkey,
            child: _container(),
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[_addAccountButton(), _backButton()],
          )
        ],
      ),
    );
  }

  //--------------------------------------
  Widget decorateTextField(Widget textfield) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0, left: 30.0, right: 30),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        //border: Border.all(width: 2, color: Color(0xff006a71)),
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

  //-----------------------------------------
  Widget _formLabel(String label) => Text(
        label,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: "mulish",
            fontSize: 16),
      );

  //-----------------------------
  Widget _nomField() => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin/*LightColor.green*/),
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
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin/*LightColor.green*/),
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

  //------------------------------------------
  Widget _emailField() => Theme(
      data: Theme.of(context).copyWith(primaryColor: Color(0xff006a71)),
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
      data: Theme.of(context).copyWith(primaryColor: Color(0xff006a71)),
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
      data: Theme.of(context).copyWith(primaryColor: Color(0xff006a71)),
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
      data: Theme.of(context).copyWith(primaryColor: Color(0xff006a71)),
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
  Widget _container() => Container(
          child: isLoading ? const Loading() : Column(
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

  Widget _addAccountButton() => InkWell(
        onTap: () => {createAccount()},
        child: Container(
          width: 110,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xff006a71)),
          child: Center(
            child: Text(
              getTranslated(context, 'ajouter'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "mulish"),
            ),
          ),
        ),
      );

//-------------------------------------------------
  Widget _backButton() => InkWell(
        onTap: () => Navigator.of(context).pop(context),
        child: Container(
          width: 110,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: Colors.blue[300]),
          child: Center(
            child: Text(
              getTranslated(context, 'retour'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "mulish"),
            ),
          ),
        ),
      );

  //---------------------------------
  createAccount() async {
    if (_formkey.currentState.validate()) {
      isLoading = true;
      Compte newAccount = new Compte();
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));
      newAccount.firstName = _nom;
      newAccount.lastName = _prenom;
      newAccount.email = _email;
      newAccount.phone = _telephone;
      newAccount.password = _password;
      newAccount.createdDate = new DateTime.now();
      newAccount.lastModifiedDate = new DateTime.now();
      newAccount.createdBy = currentUser['username'];
      AppRole accountRole = new AppRole();
      newAccount.myRoles = new List<AppRole>();
      accountRole.role = selectProfil;
      switch (selectProfil) {
        case 'RESIDENT':
          accountRole.id = 1;
          break;
        case 'GESTIONNAIRE':
          accountRole.id = 2;
          break;
        case 'INTERVENANT':
          accountRole.id = 3;
          break;
      }
      newAccount.myRoles.add(accountRole);

      CompteController().saveAccount(newAccount, context).then((value) => {
        this.setLoading(),
      });
      _scaffold.currentState.showSnackBar(
          Utils().showSnackBar(getTranslated(context, 'cpt_creer')));
    }
  }
  setLoading(){
    this.setState(() {
      isLoading=false;
    });
  }
}
