import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/controllers/CoproprieteController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/screens/AppBarWidget3.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';


class AddCopropriete extends StatefulWidget {
  @override
  _AddCoproprieteState createState() => _AddCoproprieteState();
}

class _AddCoproprieteState extends State<AddCopropriete> {
  int nbrNotification = 0;
  final _formkey = GlobalKey<FormState>();
  String _nom;
  String _date;
  String _city;
  String _details;
  Compte _gestionnaire;
  int _nbResidents;
  List<Compte> gestionnaires = List();
  AutoCompleteTextField searchTextField;

  GlobalKey<AutoCompleteTextFieldState<Compte>> key = new GlobalKey();

  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar3(context),
      backgroundColor: LightColor.background,
      body: ListView(
        padding: EdgeInsets.all(15),
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 40),
          Align(
              child: Text(
            getTranslated(context, 'add_cop'),
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
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[_ajouterButton(), _backButton()],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

//--------------------------------------
  Widget _gestionnaires() => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin/*LightColor.green1*/),
      child: FutureBuilder(
          future: CompteController().getAllGestionnaires(context),
          builder: (context, AsyncSnapshot<List<Compte>> snapshot) {
            if (!snapshot.hasData) return Container();
            if (snapshot.data.length == 0) return Container();
            gestionnaires.addAll(snapshot.data);
            searchTextField = AutoCompleteTextField<Compte>(
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "mulish",
                  fontSize: 16),
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(10),
                  filled: true,
                  labelText: getTranslated(context, 'sydinc')),
              itemBuilder: (context, item) {
                return Container(
                    padding: EdgeInsets.all(7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "${item.firstName} ${item.lastName}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        Text(item.myRoles[0].role)
                      ],
                    ));
              },
              // filter
              itemFilter: (item, query) {
                return (item.firstName + ' ' + item.lastName)
                    .toLowerCase()
                    .startsWith(query.toLowerCase());
              },
              // sort
              itemSorter: (a, b) {
                return (a.firstName + ' ' + a.lastName)
                    .compareTo((b.firstName + ' ' + b.lastName));
              },
              // submission
              itemSubmitted: (item) {
                setState(() {
                  _gestionnaire = item;
                  //print(_gestionnaire);
                  searchTextField.textField.controller.text =
                      item.firstName + ' ' + item.lastName;
                });
              },
              key: key,
              clearOnSubmit: false, suggestions: gestionnaires,
            );
            return searchTextField;
          }));

  //-----------------------------------------
  Widget _dateField(String title) => TextFormField(
      initialValue: title,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      validator: (value) {
        if (value.isEmpty) return getTranslated(context, 'ses_date');
        setState(() => _date = value);
        return null;
      });

//----------------------------------------
  Widget _cityField(String title) => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin/*LightColor.green1*/),
      child: TextFormField(
          initialValue: title,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: getTranslated(context, 'ville'),
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "mulish",
                fontSize: 16),
            fillColor: Colors.white,
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value.isEmpty) return getTranslated(context, 'ses_ville');
            setState(() => _city = value);
            return null;
          }));
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
  Widget _nomField(String title) => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin/*LightColor.green1*/),
      child: TextFormField(
          initialValue: title,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: getTranslated(context, 'nom'),
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "mulish",
                fontSize: 16),
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

  //----------------------------------
  Widget _detailField() => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin/*LightColor.green1*/),
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
            _details = value;
          });
          return null;
        },
      ));
  //-----------------------------------------
  Widget _nbResidentsField(String title) => Theme(
      data: Theme.of(context).copyWith(primaryColor: LightColor.blueLinkedin/*LightColor.green1*/),
      child: TextFormField(
        initialValue: title,
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          labelText: getTranslated(context, 'nb_res'),
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_nb_res');
          setState(() {
            _nbResidents = int.parse(value);
          });
          return null;
        },
      ));

  //-----------------------------------------
  Widget decorateTextField(Widget textfield) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0, left: 30.0, right: 30),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(const Radius.circular(10)),
        // border: Border.all(width: 1, color: LightColor.green1),
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
  Widget decorateText(Widget textfield) {
    return Container(
      //width: 250,
      margin: const EdgeInsets.only(top: 15.0, left: 30.0, right: 30),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(const Radius.circular(10)),
        // border: Border.all(width: 1, color: LightColor.green1),
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

  //-----------------------------------------
  Widget _container() => Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          decorateTextField(_nomField("")),
          SizedBox(
            height: 20,
          ),
          decorateTextParagraph(_detailField()),
          SizedBox(
            height: 20,
          ),
          decorateText(_gestionnaires()),
          SizedBox(
            height: 20,
          ),
          decorateTextField(_nbResidentsField("")),
          SizedBox(
            height: 20,
          ),
          decorateTextField(_cityField("")),
          SizedBox(
            height: 20,
          ),
        ],
      ));

  //------------------------------
  Widget _ajouterButton() => InkWell(
        onTap: () => {addCopropriete()},
        child: Container(
          width: 90,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            gradient: _gradian(),
          ),
          child: Center(
            child: Text(
              getTranslated(context, 'ajouter'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: "mulish"),
            ),
          ),
        ),
      );

  // ---------------------------------------
  LinearGradient _gradian() {
    return new LinearGradient(
        colors: [/*LightColor.green*/LightColor.blueLinkedin, Colors.blue],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp);
  }

//-------------------------------------------------
  Widget _backButton() => InkWell(
        onTap: () => Navigator.of(context).pop(context),
        child: Container(
          width: 90,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: Colors.blue[300],
          ),
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

  // add a co-ownership
  addCopropriete() async {
    if (_formkey.currentState.validate()) {
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));
      Copropriete cop = new Copropriete();
      cop.createdDate = new DateTime.now();
      cop.lastModifiedDate = new DateTime.now();
      cop.createdBy = currentUser['username'];
      cop.details = _details;
      cop.nbResidents = _nbResidents;
      cop.name = _nom;
      cop.city = _city;
      cop.gestionnaire = _gestionnaire;
      CoproprieteController().saveCopropriete(cop, context);
      Navigator.of(context).pop(context);
    }
  }
}
