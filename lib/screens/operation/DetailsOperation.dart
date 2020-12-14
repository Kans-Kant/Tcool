import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/NotifWidget.dart';
import 'package:tcool_flutter/screens/pages/Title.dart';
import 'package:tcool_flutter/screens/pages/detail_text.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

import '../AppBarWidget.dart';

class DetailsOperation extends StatefulWidget {
  final Operation operation;
  DetailsOperation({Key key, this.operation}) : super(key: key);
  @override
  _DetailsOperationState createState() => _DetailsOperationState();
}

class _DetailsOperationState extends State<DetailsOperation> {
  int nbrNotification = 0;
  final _formkey = GlobalKey<FormState>();
  String dateHeure;
  String titre;
  String detail;
  String montant;
  String typeOperation;
  List<DropdownMenuItem<String>> types = [
    DropdownMenuItem(
      child: Text('Crédit'),
      value: 'CREDIT',
    ),
    DropdownMenuItem(
      child: Text('Débit'),
      value: 'DEBIT',
    )
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.operation);
    if(widget.operation != null)
      typeOperation = widget.operation.typeOp;
    //print('fffffff' + typeOp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar2(context),
      backgroundColor: LightColor.background,
      body: ListView(
        padding: EdgeInsets.all(15),
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 20),
          Align(child: AppTitle(getTranslated(context, 'det_op'))),
          SizedBox(height: 30),
          Form(
            key: _formkey,
            child: _operationContainer(),
          ),
          SizedBox(height: 30),
          // _button(),
          // SizedBox(height: 30),
        ],
      ),
    );
  }

  //-----------------------------------------
  Widget _formLabel(String label) => Text(
        label,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: "mulish",
            fontSize: 14),
      );

  //-----------------------------------------
  Widget _dateHeureField(String title) => TextFormField(
        initialValue: title,
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_nom');
          setState(() {
            dateHeure = value;
          });
          return null;
        },
      );
  //-----------------------------------------
  Widget _titreField(String title) => TextFormField(
        initialValue: title,
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_nom');
          setState(() {
            titre = value;
          });
          return null;
        },
      );
  //-----------------------------------------
  Widget _detailField(String title) => TextFormField(
      initialValue: title,
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      validator: (value) {
        if (value.isEmpty) return getTranslated(context, 'ses_det');
        setState(() => detail = value);
        return null;
      });
  //-----------------------------------------
  Widget _montantField(String title) => TextFormField(
      initialValue: title,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      validator: (value) {
        if (value.isEmpty) return getTranslated(context, 'ses_det');
        setState(() => montant = value);
        return null;
      });
  //-----------------------------------------
  Widget _typeField() => DropdownButton(
        items: types,
        underline: Container(
          decoration: BoxDecoration(color: Colors.white),
        ),
        value: typeOperation,
        onChanged: (value) {
          setState(() {
            typeOperation = value;
          });
        },
        isExpanded: true,
      );

  Widget decorateTextField(Widget textfield) {
    return Container(
      width: 230,
      height: 40,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: LightColor.blueLinkedin,/*Color(0xff006a71)*/),
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

  Widget decorateTextParagraph(Widget textfield) {
    return Container(
      width: 230,
      height: 100,
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: LightColor.blueLinkedin/*Color(0xff006a71)*/),
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
  Widget _operationContainer() => Container(
    padding: EdgeInsets.all(15),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DetailTitle(getTranslated(context, 'date_heure'),DateFormat('dd/MM/yyyy - H:mm')
        .format(widget.operation.createdDate),MediaQuery.of(context).size.width * 0.37,),
        Divider(),
        DetailTitle(getTranslated(context, 'titre'),widget.operation.title,MediaQuery.of(context).size.width * 0.37,),
        Divider(),
        DetailTitle(getTranslated(context, 'detail'), widget.operation.details != null ? widget.operation.details : '',MediaQuery.of(context).size.width * 0.37,),
        Divider(),
        DetailTitle(getTranslated(context, 'montant'),"${widget.operation.amount} DH",MediaQuery.of(context).size.width * 0.37,),
        Divider(),
        DetailTitle(getTranslated(context, 'type'), widget.operation.typeOp,MediaQuery.of(context).size.width * 0.37,),
        Divider(),
      ],
    ),
  );

  //--------------------------------
  Widget _button() => InkWell(
        onTap: () {
          Navigator.of(context).pop(context);
        },
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.indigo[300]),
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
}
