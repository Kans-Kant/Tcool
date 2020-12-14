import 'package:flutter/material.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/AppBarWidget3.dart';
import 'package:tcool_flutter/screens/pages/Title.dart';
import 'package:tcool_flutter/screens/pages/detail_text.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

class UserFile extends StatefulWidget {
  final Compte compte;
  UserFile({Key key, @required this.compte}) : super(key: key);
  @override
  _UserFileState createState() => _UserFileState();
}

class _UserFileState extends State<UserFile> {
  int nbrNotification = 0;
  String selectProfil;

  final GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();

  List<DropdownMenuItem<String>> profilList = [
    DropdownMenuItem(
      child: Text('Résident'),
      value: 'RESIDENT',
    ),
    DropdownMenuItem(
      child: Text('Syndic'),
      value: 'SYNDIC',
    ),
    DropdownMenuItem(
      child: Text('Intervenant'),
      value: 'INTERVENANT',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffold,
        appBar: MyAppBar3(context),
        backgroundColor:LightColor.background,
        body: ListView(
          padding: EdgeInsets.all(15),
          children: <Widget>[
            SizedBox(height: 20),
            Align(child: AppTitle(getTranslated(context, 'fiche_ut'))),
            _userFileContainer(),
            SizedBox(height: 50),
            Utils.isAdmin(widget.compte.myRoles[0].role)
                ? Container(width: 0, height: 0)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _validateButton(),
                      _deleteButton(),
                    //  _backButton()
                    ],
                  )
          ],
        ));
  }

  Widget decorateTextField(Widget textfield) {
    return Container(
      width: 230,
      height: 45,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: /*Color(0xff006a71)*/LightColor.blueLinkedin),
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

  //-----------------------------------------
  Widget _formLabel(String label) => Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "mulish",
        ),
      );
  //-----------------------------------------
  Widget _nomField(String title) => TextFormField(
        initialValue: title,
        keyboardType: TextInputType.text,
        readOnly: true,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      );
  //-----------------------------------------
  Widget _prenomField(String title) => TextFormField(
        initialValue: title,
        readOnly: true,
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
      );
  //-----------------------------------------
  Widget _phoneField(String title) => TextFormField(
        initialValue: title,
        readOnly: true,
        keyboardType: TextInputType.phone,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
      );
  //-----------------------------------------
  Widget _emailField(String title) => TextFormField(
        initialValue: title,
        readOnly: true,
        keyboardType: TextInputType.emailAddress,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
      );
  //-----------------------------------------
  Widget _passwordField(String title) => TextFormField(
        initialValue: title,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
      );
  //-----------------------------------------
  Widget _confpwdField(String title) => TextFormField(
        initialValue: title,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
      );
  //-----------------------------------------
  Widget _profilField() => DropdownButton(
        items: profilList,
        underline: Container(
          decoration: BoxDecoration(color: Colors.white),
        ),
        value: widget.compte.myRoles[0].role,
        onChanged: (value) {
          setState(() {
            selectProfil = value;
          });
        },
        isExpanded: true,
      );
  //-----------------------------------------
  Widget _userFileContainer() => Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 40),
           DetailTitle(getTranslated(context, 'nom'),widget.compte.firstName,MediaQuery.of(context).size.width * 0.37,),
                    Divider(),
                    DetailTitle(getTranslated(context, 'prenom'),widget.compte.lastName,MediaQuery.of(context).size.width * 0.37,),
                    Divider(),
                    DetailTitle(getTranslated(context, 'mail'),widget.compte.email,MediaQuery.of(context).size.width * 0.37,),
                    Divider(),
                    DetailTitle(getTranslated(context, 'telephone'),widget.compte.phone,MediaQuery.of(context).size.width * 0.37,),
                    Divider(),
          Utils.isAdmin(widget.compte.myRoles[0].role)
              ? Container(width: 0, height: 0)
              :  DetailTitle(getTranslated(context, 'profil'),widget.compte.myRoles[0].role,MediaQuery.of(context).size.width * 0.37,)
             
        ],
      ));

  Widget _validateButton() => InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 100,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: LightColor.blueLinkedin,/*Color(0xff006a71)*/),
          child: Center(
            child: Text(
              getTranslated(context, 'valider'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: "mulish"),
            ),
          ),
        ),
      );

  //-----------------------------------------------
  Widget _deleteButton() => InkWell(
        onTap: () => deleteAccount(),
        child: Container(
          width: 100,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: Colors.blue[300]),
          child: Center(
            child: Text(
              getTranslated(context, 'supprimer'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: "mulish"),
            ),
          ),
        ),
      );

  //-----------------------------------------------
  Widget _backButton() => InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 90,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Color.fromARGB(255, 178, 102, 255)),
          child: Center(
            child: Text(
              getTranslated(context, 'retour'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: "mulish"),
            ),
          ),
        ),
      );

  deleteAccount() {
    CompteController().deleteAccount(widget.compte.idCompte, context);
    _scaffold.currentState.showSnackBar(Utils().showSnackBar(
        "Le compte de ${widget.compte.firstName} est supprimé avec succès!"));
    Navigator.of(context).pop(context);
  }
}
