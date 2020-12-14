import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';

import '../SplashScreen.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:tcool_flutter/screens/pages/LoginPage.dart';
import 'package:http/http.dart' as http;
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';

import '../acceuil.dart';

class ConfirmationAccountPage extends StatefulWidget {
  final Map loginData;

  ConfirmationAccountPage({Key key, @required this.loginData})
      : super(key: key);

  @override
  _ConfirmationAccountPageState createState() => _ConfirmationAccountPageState();
}

class _ConfirmationAccountPageState extends State<ConfirmationAccountPage> {
  final storage = new FlutterSecureStorage();

  String _code;


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
                      Text(getTranslated(context, 'email_text'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: "Sego"
                          )),
                      SizedBox(height: 30),
                      Form(
                        key: _formkey,
                        child: _verifyContainer(),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      _validateButton(),
                      SizedBox(
                        height: 15,
                      ),
                      //_connexion(),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ))) ,
        )
    );
  }


  //-----------------------------
  Widget _codeField() => Theme(
      data: Theme.of(context)
          .copyWith(primaryColor: LightColor.green),
      child: TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: getTranslated(context, 'code'),
            labelStyle: TextStyle(fontSize: 16),
            fillColor: Colors.white,
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value.isEmpty) return getTranslated(context, 'ses_code');
            if (value.isNotEmpty && value.length < 2)
              return getTranslated(context, 'invalide');
            setState(() => _code = value);
            return null;
          }));

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
  Widget _verifyContainer() => Container(
    //width: 350,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          decorateTextField(_codeField()),
        ],
      ));

  //--------------------------------
  Widget  _validateButton() => Container(
    //width: 300,
    height: 50,
    margin: EdgeInsets.symmetric(horizontal: 30),
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
      onPressed: () => {verifycode()},
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
              decoration: TextDecoration.underline,
              fontFamily: "mulish",
              fontSize: 20,
              color: Colors.black),
        )),
  );

  //------------------------------------
  verifycode() async {

    if (_formkey.currentState.validate()) {
      isLoading = true;
      print('code : ' + _code);
      Map body = {
        "code": _code
      };
      try {
        var response = await http.post(
          Constants.EMAIL_VERIFY,
          headers: {"Content-Type": "application/json"},
          body: json.encode(body),
        );
        if (response.statusCode == 200) {
          isLoading =false;
          await login(this.widget.loginData);
          // code verify successfully
          Timer(Duration(seconds: 2), () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SplashScreen()));
            });
        } else {
          if (response.statusCode == 400) {
            // error code
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
  Future login(Map body) async {
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
  }
}
