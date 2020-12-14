import 'package:flutter/material.dart';
import 'package:tcool_flutter/screens/AppBarWidget.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

import 'SuivreDiscussion.dart';

class DetailDiscussion2 extends StatefulWidget {
  @override
  _DetailDiscussion2State createState() => _DetailDiscussion2State();
}

class _DetailDiscussion2State extends State<DetailDiscussion2> {
   List<DropdownMenuItem<String>> visibilitylList = [
    DropdownMenuItem(
      child: Text('Public'),
      value: 'Public',
    ),
    DropdownMenuItem(
      child: Text('Privé'),
      value: 'Privé',
    )
  ];
  final _formKey = GlobalKey<FormState>();
  int notifcation = 3;
  String _dateHeure;
  String _titre ;
  String _detail;
  String selectVisibility = 'Public';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(context),
        backgroundColor: Color.fromARGB(255, 238, 238, 238),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: _formContainer(),
                ),
                _twoButtons(),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      //  bottomNavigationBar: bottomNav(1)
        );
  }

  //----------------------------------------
  Widget _notification() => Column(
        children: <Widget>[
          SizedBox(height: 10),
          IconButton(
            icon: Icon(Icons.notifications, size: 40.0, color: Colors.white),
            onPressed: () {
              print("Nofitications");
              setState(() {
                //  _volume += 10;
              });
            },
          ),
          SizedBox(height: 5),
          Text('Notifications : $notifcation',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ))
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
        initialValue: "27 Mai 2020 à 18H30",
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return 'Saisir le titre';
          setState(() {
            _dateHeure = value;
          });
          return null;
        },
      );
  //----------------------------------
  Widget _titreField() => TextFormField(
        initialValue: "Titre",
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return 'Saisir le titre';
          setState(() {
            _titre = value;
          });
          return null;
        },
      );
  //----------------------------------
  Widget _detailField() => TextFormField(
        initialValue: "Détails de l'évènement",
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return 'Saisir les détails';
          setState(() {
            _detail = value;
          });
          return null;
        },
      );
        //----------------------------------
  Widget _statutField() => TextFormField(
        initialValue: "En cours",
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return 'Saisir le titre';
          setState(() {
            _dateHeure = value;
          });
          return null;
        },
      );
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
      width: 200,
      height: 40,
      //margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 3, color: LightColor.blueLinkedin/*Color(0xff006a71)*/),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            offset: Offset(0,2),
          )
        ],
      ),
      child: textfield,
    );
  }
  //--------------------------------------
  Widget decorateTextParagraph(Widget textfield) {
    return Container(
      width: 200,
      height: 70,
      //margin: const EdgeInsets.all(3),
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2, color: LightColor.blueLinkedin,/*Color(0xff006a71)*/),
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
 //----------------------------------------
  Widget _twoButtons() => Container(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SuiviDiscussion()))
              },
              child: Container(
                height: 50,
                width: 150,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: LightColor.blueLinkedin,//Color(0xff006a71),
                ),
                child: Center(
                  child: Text(
                    "Rejoindre",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontFamily: "mulish",
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => {
                 Navigator.pop(context)
              },
              child: Container(
                height: 50,
                width: 150,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.cyanAccent[700],
                ),
                child: Center(
                  child: Text(
                    "Retour",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontFamily: "mulish",
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
      //-----------------------------------------
  Widget _formContainer() => Container(
      width: 350,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _Label("Date - Heure"),
              decorateTextField(_dateHeureField()),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _Label("Titre évènement"),
              decorateTextField(_titreField()),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _Label("Détails"),
              decorateTextParagraph(_detailField()),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _Label("statut"),
              decorateTextField(_statutField()),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _Label("Visibilité"),
              SizedBox(height: 10),
              decorateTextField(_visibilityField()),
            ],
          ),
          SizedBox(height: 20),
        ],
      ));

}