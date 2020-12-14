import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/controllers/CoproprieteController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Copropriete.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/AppBarWidget3.dart';
import 'package:tcool_flutter/screens/pages/Title.dart';
import 'package:tcool_flutter/screens/pages/detail_text.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

class CoOwnershipFile extends StatefulWidget {
  Copropriete copropriete;
  CoOwnershipFile({Key key, @required this.copropriete}) : super(key: key);
  @override
  _CoOwnershipFileState createState() => _CoOwnershipFileState();
}

class _CoOwnershipFileState extends State<CoOwnershipFile> {
  final _scaffold = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  int nbrNotification = 0;
  String _city;
  String _details;
  String _nbResidents;
  String _name;
  Compte _gestionnaire;
  TextEditingController _controller = new TextEditingController();
  List<Compte> gestionnaires = List();
  AutoCompleteTextField searchTextField;

  GlobalKey<AutoCompleteTextFieldState<Compte>> key = new GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /* _controller.text = widget.copropriete.gestionnaire.firstName +
        ' ' +
        widget.copropriete.gestionnaire.lastName; */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: MyAppBar3(context),
      backgroundColor: LightColor.background,
      body: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          SizedBox(height: 20),
          Align(child: AppTitle(getTranslated(context, 'fiche_cop'))),
          SizedBox(height: 20),
          Form(
            key: _formKey,
            child: _coproprieteFileContainer(),
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _validateButton(),
              _deleteButton(),
              // _backButton()
            ],
          )
        ],
      ),
    );
  }

//---------------------------------------
  Widget decorateTextField(Widget textfield) {
    return Container(
      width: 270,
      margin: const EdgeInsets.only(top: 15.0, right: 15),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(const Radius.circular(10)),
        // border: Border.all(width: 1, color: LightColor.green1),
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

  //------------------------------------------
  Widget decorateTextParagraph(Widget textfield) {
    return Container(
      width: 150,
      height: 100,
      padding: EdgeInsets.all(7),
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

  //-----------------------------------------
  Widget _createdDateField(String title) => TextFormField(
        initialValue: title,
        keyboardType: TextInputType.text,
        readOnly: true,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      );

  //-----------------------------------------
  Widget _nameField(String title) => TextFormField(
        initialValue: title,
        keyboardType: TextInputType.text,
        readOnly: true,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_nom');
          if (value.isNotEmpty)
            setState(() {
              _name = value;
            });
          return null;
        },
      );

  //-----------------------------------------
  Widget _detailsField(String details) => TextFormField(
        initialValue: details,
        keyboardType: TextInputType.multiline,
        maxLines: 10,
        readOnly: true,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_det');
          if (value.isNotEmpty)
            setState(() {
              _details = value;
            });
          return null;
        },
      );

  //----------------------------------------------
  Widget _nbResidentsField(String residents) => TextFormField(
        initialValue: residents,
        readOnly: true,
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return getTranslated(context, 'ses_nb_res');
          }
          if (value.isNotEmpty)
            setState(() {
              _nbResidents = value;
            });
          return null;
        },
      );

//--------------------------------------
  Widget _gestionnaires() => FutureBuilder(
      future: CompteController().getAllGestionnaires(context),
      builder: (context, AsyncSnapshot<List<Compte>> snapshot) {
        if (!snapshot.hasData) return Container();
        if (snapshot.data.length == 0) return Container();
        gestionnaires.addAll(snapshot.data);
        searchTextField = AutoCompleteTextField<Compte>(
          controller: _controller,
          style: new TextStyle(color: Colors.black, fontSize: 16.0),
          decoration: new InputDecoration(
              border: InputBorder.none,
              fillColor: LightColor.white,
              //suffixIcon: Container(width: 230, height: 50,),
              contentPadding: EdgeInsets.all(10),
              filled: true,
              hintText: getTranslated(context, 'sel_gestionnaire')),

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
      });
  //------------------------------------------------
  Widget _cityField(String status) => TextFormField(
        initialValue: status,
        readOnly: true,
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_ville');
          if (value.isNotEmpty)
            setState(() {
              _city = value;
            });
          return null;
        },
      );
  //-----------------------------------------
  Widget _formLabel(String label) => Text(
        label,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: "mulish",
            fontSize: 14),
      );

  //---------------------------------------
  Widget _coproprieteFileContainer() => Container(
      padding: EdgeInsets.all(10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DetailTitle(
                getTranslated(context, 'date_heure'),
                DateFormat('dd/MM/yyyy - H:mm')
                    .format(widget.copropriete.createdDate),MediaQuery.of(context).size.width * 0.37,),
            Divider(),
            DetailTitle(getTranslated(context, 'nom'), widget.copropriete.name,MediaQuery.of(context).size.width * 0.37,),
            Divider(),
            DetailTitle(
                getTranslated(context, 'detail'), widget.copropriete.details,MediaQuery.of(context).size.width * 0.37,),
            Divider(),
            DetailTitle(getTranslated(context, 'nb_res'),
                '${widget.copropriete.nbResidents}',MediaQuery.of(context).size.width * 0.37,),
            Divider(),
            DetailTitleWidget(getTranslated(context, 'gestionnaire'),
                decorateTextField(_gestionnaires())),
            Divider(),
            /*  DetailTitleGestionnaire(getTranslated(context, 'sydinc'),
                decorateTextField(_nbResidentsField("${widget.copropriete.nbResidents}"))),
            Divider(),*/
            DetailTitle(
                getTranslated(context, 'ville'), widget.copropriete.city,MediaQuery.of(context).size.width * 0.37,),
          ]));

  Widget _validateButton() => InkWell(
        onTap: () => {validate()},
        child: Container(
          width: 100,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: LightColor.blueLinkedin, /*Color(0xff006a71)*/
          ),
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
        onTap: () => deleteCopropriete(),
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

  //------------------------------------------------
  validate() {
    if (_formKey.currentState.validate()) {
      //widget.copropriete.name = _name;
      //widget.copropriete.details = _details;
      widget.copropriete.gestionnaire = _gestionnaire;
      widget.copropriete.lastModifiedDate = new DateTime.now();
      //widget.copropriete.nbResidents = int.parse(_nbResidents);
      //widget.copropriete.city = _city;
      CoproprieteController()
          .updateCopropriete(widget.copropriete, context)
          .whenComplete(() {
        Navigator.pop(context);
        _scaffold.currentState.showSnackBar(
            Utils().showSnackBar(getTranslated(context, 'maj_eff')));
      });
      //Utils.showAlertDialog(context, "Mise à jour effectuée!");
    }
  }

  //--------------------
  deleteCopropriete() {
    CoproprieteController()
        .deleteCopropriete(widget.copropriete.idCopropriete, context);
    _scaffold.currentState.showSnackBar(Utils().showSnackBar(
        "La copropriété de ${widget.copropriete.name} est supprimé avec succès!"));
    //Utils.showAlertDialog(context, "La copropriété de ${widget.copropriete.name} est supprimé avec succès!");
    //Navigator.pop(context);
  }
}
