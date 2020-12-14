import 'dart:convert' show json;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:tcool_flutter/screens/MainScreen.dart';
import 'package:tcool_flutter/screens/pages/CreateAccountPage.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  String _login;
  String _password;
  FocusNode nodeEmail = FocusNode();
  FocusNode nodePassword = FocusNode();

  //----------------------------- loading spinner
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: LightColor.white,
        body: Container(
          child: isLoading
              ? Center(
            child: const Loading(),
          ):SingleChildScrollView(
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 70),
                    //  _titlePage(),
                        _icon(),
                    SizedBox(height: 60),
                    Form(
                      key: _formKey,
                      child: _loginContainer(),
                    ),
                    SizedBox(height: 50),
                    _loginButton(),
                    SizedBox(height: 10),
                    _signup(),
                  ],
                )),
          ),
        )
    );
  }


  //---------------------------------------
  Widget _titlePage() => Container(
        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: Text(
          getTranslated(context, 'connexion'),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 26,fontFamily: "mulish"

          ),
        ),
      );

  //---------------------------------------
  Widget _divider() => Container(
        width: 30,
        height: 5,
        decoration: BoxDecoration(
          color: LightColor.blueLinkedin/*Color(0xff006a71)*/,
        ),
      );

  //----------------------------------------
  Widget _forgottenPassword() => Container(
    margin: EdgeInsets.only(right: 30, top: 3),
    alignment: Alignment.topRight,
    child: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: getTranslated(context, 'forgotten'),
                  style: TextStyle(color: LightColor.blueLinkedin/*Colors.lightBlue[700]*/),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      print("ok");
                    }),
            ],
          ),
        )
  );

  //----------------------------------------
  Widget _signup() => RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: getTranslated(context, 'enregitre'),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "mulish",
                    decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateAccountPage()));
                  }),
          ],
        ),
      );
  //----------------------------------------
  /*Widget _loginButton() => InkWell(
    //focusColor: Colors.red,
    //hoverColor: Colors.red,
    highlightColor: Colors.green,
    //splashColor:Colors.green,
    onTap: () => {login()},
    child: Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          //color: Color(0xff006a71),
          gradient: _gradian()
      ),
      child: Center(
        child: Text(
          getTranslated(context, 'connexion'),
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontFamily: "mulish",
          ),
        ),
      ),
    ),
  );*/

  Widget _loginButton() => Container(
    //width: 300,
    height: 50,
    margin: EdgeInsets.symmetric(horizontal: 30),
    /*decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        gradient: _gradian(),
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
          getTranslated(context, 'connexion'),
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontFamily: "mulish",
          ),
        ),
      ),
      onPressed: () => {login()},
    ),
  );


  //------------------------------------------
  Widget _loginField() => Theme(
      data: Theme.of(context)
          .copyWith(primaryColor: LightColor.blueLinkedin /*Color(0xff006a71)*/),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: getTranslated(context, 'login'),
            icon: Icon(Icons.email)),
        onFieldSubmitted: (term) {
          FocusScope.of(context).requestFocus(nodePassword);
        },
        focusNode: nodeEmail,
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'saisir_mail');
          if (value.isNotEmpty && !value.contains('@'))
            return getTranslated(context, 'no_valid_mail');
          setState(() {
            _login = value;
          });
          return null;
        },
      ));

  //------------------------------------------
  Widget _passwordField() => Theme(
      data: Theme.of(context)
          .copyWith(primaryColor: LightColor.blueLinkedin/*Color(0xff006a71)*/),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: getTranslated(context, 'password'),
          icon: Icon(Icons.vpn_key),
        ),
        focusNode: nodePassword,
        onFieldSubmitted: (term) => login(),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'saisir_pass');
          setState(() {
            _password = value;
          });
          return null;
        },
      ));

  //--------------------------------------
  Widget decorateTextField(Widget textfield) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0, left: 30.0, right: 30),
      padding: const EdgeInsets.only(top:2,bottom: 2,left:9,right:9),
      decoration: BoxDecoration(
        color: Colors.white,
        //border: Border.all(width: 2, color: LightColor.blueLinkedin/*LightColor.green*/),
        borderRadius: BorderRadius.all(const Radius.circular(90)),
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

  // ---------------------------------------
  LinearGradient _gradian() {
    return new LinearGradient(
        colors: [LightColor.blueLinkedin/*LightColor.green*/,Colors.blue /*Colors.teal[800]*/],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp);
  }

  //-----------------------------------------
  Widget _loginContainer() => Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          decorateTextField(_loginField()),
          SizedBox(
            height: 20,
          ),
          decorateTextField(_passwordField()),
        ],
      ));
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
  //--------------------------------
  void login() async {
    if(!await Utils.connected()){
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
      return;
    }
    if (_formKey.currentState.validate()) {
      isLoading = true;
      Map body = {'username': _login, 'password': _password};
      print(body);
      // authentification jwt dans le BE
      try {
        var response = await http.post(Constants.LOGIN,
            headers: {"Content-Type": "application/json"},
            body: json.encode(body));

        if (response.statusCode == 200) {
          isLoading = false;
          Map parsed = json.decode(response.body);
          //local storage
          await storage.write(key: 'token', value: parsed['token']);
          await storage.write(key: 'password', value: _password);
          await storage.write(
              key: 'currentUser', value: json.encode(parsed['currentUser']));

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MainScreen(
                    currentPage: 0,
                  )));
        } else {
          isLoading =false;
          throw new Exception("Error!");
        }
      } catch (e) {
        isLoading =false;
        Navigator.pop(context);
        Utils.showAlertDialog(
            context, getTranslated(context, 'error_connexion'));
      }
    }
  }
}
