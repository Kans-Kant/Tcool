import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcool_flutter/controllers/OperationController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/screens/AppBarWidget.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/NotifWidget.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';

import 'AddConfirmationPage.dart';

class AddOperationScreen extends StatefulWidget {
  @override
  _AddOperationScreenState createState() => _AddOperationScreenState();
}

class _AddOperationScreenState extends State<AddOperationScreen> {
  final storage = FlutterSecureStorage();
  final _scaffold = new GlobalKey<ScaffoldState>();
  int nbrNotification = 0;
  final _formkey = GlobalKey<FormState>();
  String _titleOp;
  String _details;
  double _amount;
  String typeOp = 'CREDIT';
  List<DropdownMenuItem<String>> typeOpList = [
    DropdownMenuItem(
      child: Text('Crédit'),
      value: 'CREDIT',
    ),
    DropdownMenuItem(
      child: Text('Débit'),
      value: 'DEBIT',
    ),
  ];

  //---------------------- loading spinner
  bool isLoading = false;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: MyAppBar2(context),
      backgroundColor: LightColor.white,
      body:Container(
        child:isLoading
            ? Center(
          child: const Loading(),
        ):
        SingleChildScrollView(
          child :
          ListView(
            padding: EdgeInsets.all(15),
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 20),
              Align(
                child: Text(
                  getTranslated(context, 'add_opr'),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: "mulish"
                  ),
                )),
              SizedBox(height: 30),
              Form(
                key: _formkey,
                child: _container(),
              ),
              SizedBox(height: 50),
              _addAccountButton(),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: <Widget>[
              //     _addAccountButton(),
              //     _backButton()
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }


 //-----------------------------------------
  /*Widget decorateTextField(Widget textfield) {
    return Container(
      width: 230,
      height: 70,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2, color: LightColor.blueLinkedin/*Color(0xff006a71)*/),
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
  }*/

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

  //--------------------------------------
  Widget decorateTextParagraph(Widget textfield) {
    return Container(
      width: 230,
      height: 100,
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2, color: LightColor.blueLinkedin/*Color(0xff006a71)*/),
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
          fontSize: 18
        ),
      );
  //-----------------------------------------
  Widget _titleField(String title) => TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: title,
      ),
      validator: (value) {
        if (value.isEmpty) return getTranslated(context, 'ses_tit');
        setState(() => _titleOp = value);
        return null;
      });
  //-----------------------------------------
  Widget _detailsField(String title) => TextFormField(
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: title,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_det');
          setState(() {
            _details = value;
          });
          return null;
        },
      );
  //-----------------------------------------
  Widget _amountField(String title) => TextFormField(
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: title,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_mon');
          if (value.isNotEmpty && double.parse(value) <= 0)
            return getTranslated(context, 'invalide');
          setState(() {
            _amount = double.parse(value);
          });
          return null;
        },
      );
  //-----------------------------------------
  Widget _typeOpField() => DropdownButton(
        items: typeOpList,
        underline: Container(
          decoration: BoxDecoration(color: Colors.white),
        ),
        value: typeOp,
        onChanged: (value) {
          setState(() {
            typeOp = value;
          });
        },
        isExpanded: true,
      );
  //-----------------------------------------
  /*Widget _container() => Container(
      width: 350,
      child: isLoading ? const Loading()
          :Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _formLabel(getTranslated(context, 'titre')),
              decorateTextField(_titleField('Cotisation Résident 1')),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _formLabel(getTranslated(context, 'detail')),
              decorateTextParagraph(_detailsField("Détails opération")),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _formLabel(getTranslated(context, 'montant')),
              decorateTextField(_amountField('100 DH')),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _formLabel(getTranslated(context, 'type')),
              decorateTextField(_typeOpField()),
            ],
          ),
        ],
      ));*/

  Widget _container() => Container(
    //width: 350,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          decorateTextField(_titleField('Cotisation Résident 1')),
          SizedBox(
            height: 10,
          ),
          decorateTextField(_detailsField("Détails opération")),
          SizedBox(
            height: 10,
          ),
          decorateTextField(_amountField('Montant(ex : 100 DH)')),
          SizedBox(
            height: 10,
          ),
          decorateTextField(_typeOpField()),
          SizedBox(
            height: 10,
          ),
        ],
      ));

  /*Widget _addAccountButton() => InkWell(
    onTap: () => { createOperation() },
    child: Container(
      width: 110,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: _gradian(),
        color: LightColor.blueLinkedin,/*Color(0xff006a71)*/),
      child: Center(
        child: Text(getTranslated(context, 'ajouter'),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
            fontSize: 20,fontFamily: "mulish"),),
      ),
    ),
  );*/

  Widget  _addAccountButton() => Container(
    width: 110,
    height: 50,
    margin: EdgeInsets.symmetric(horizontal: 30),
    decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        gradient: _gradian()
    ),
    child: MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Center(
        child: Text(
          getTranslated(context, 'ajouter'),
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontFamily: "mulish",
          ),
        ),
      ),
      onPressed: () => {
        createOperation() ,
      },
    ),
  );

  // ---------------------------------------
  LinearGradient _gradian() {
    return new LinearGradient(
        colors: [LightColor.blueLinkedin/*LightColor.green*/, Colors.blue],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp);
  }

//-------------------------------------------------
  Widget _backButton() => InkWell(
    onTap: () => Navigator.of(context).pop(context),
    child: Container(
      width: 110,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Colors.blue[300]),
      child: Center(
        child: Text(getTranslated(context, 'retour'),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
            fontSize: 20,fontFamily: "mulish"),),
      ),
    ),
  );

  createOperation() {
    if(_formkey.currentState.validate()){
      isLoading = true;
      Operation newOp = new Operation();
      newOp.createdDate = new DateTime.now();
      newOp.lastModifiedDate = new DateTime.now();
      newOp.title = _titleOp;
      newOp.details = _details;
      newOp.amount =_amount;
      newOp.typeOp = typeOp;

      OperationController().saveOperation(newOp, context).whenComplete(() =>{
          this.setLoading(),
        Navigator.of(context).push(MaterialPageRoute(builder:
          (context) => AddConfirmationPage()
        ))
      });
      
    }
  }
 // to not make infinite the loading spinner
  setLoading(){
    this.setState(() {
      isLoading=false;
    });
  }

}