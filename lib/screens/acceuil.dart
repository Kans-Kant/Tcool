import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/main.dart';
import 'package:tcool_flutter/screens/pages/CreateAccountPage.dart';
import 'package:tcool_flutter/screens/pages/LoginPage.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

class Acceuil extends StatefulWidget {
  @override
  _AcceuilState createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  Locale _temp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,//Color.fromRGBO(32, 142, 168, 1.0),
      body: Container(
        decoration: BoxDecoration(
          //color: Color.fromRGBO(32, 142, 168, 1.0),
          gradient: LinearGradient(
              colors: [Color.fromRGBO(32, 142, 168, 1.0), Color.fromRGBO(26, 155, 85, 1.0)],
              begin: FractionalOffset(0, 0),
              end: FractionalOffset(0, 1),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp
          ),
          image: DecorationImage(
            image: const AssetImage('assets/acceuil.png'),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.05), BlendMode.dstIn),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 15,),
            /*FadeInImage(
              image: AssetImage('assets/acceuil.png'),
              placeholder: AssetImage("assets/placeholder.png"),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.30,
            ),*/
            Column(
              children: <Widget>[

               Image.asset(
                 'assets/SUN SQUARE ALMAZ.jpg',
                 fit: BoxFit.cover, // this is the solution for border
                 width: MediaQuery.of(context).size.height * 0.15,
                 height: MediaQuery.of(context).size.height * 0.15,
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
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(getTranslated(context, 'Bienvenue'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: "Sego"
                      )),
                ),

              ],
            ),
            Container(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.height * 0.03,
              ),
              child: Container(
                padding: EdgeInsets.only(left:20.0,right: 20.0),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[loginButton(),SizedBox(height: 20.0,), createButton()],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "العربية",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,fontFamily: "Mulish"),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                _temp = await setLocale(ARABIC);
                                print(_temp.toString());
                                MyApp.setLocale(context, _temp);
                              }),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "Français",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,fontFamily: "Mulish"),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                _temp = await setLocale(FRENCH);
                                print(_temp.toString());
                                MyApp.setLocale(context, _temp);
                              }),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "English",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,fontFamily: "Mulish"),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                _temp = await setLocale(ENGLISH);
                                print(_temp.toString());
                                MyApp.setLocale(context, _temp);
                              }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //----------------------------------------
  /*Widget loginButton() => InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Container(
          width: 150,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: LightColor.blueLinkedin),//Color(0xcc006a71)
          child: Center(
            child: Text(
              getTranslated(context, 'signin'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: "Mulish"),
            ),
          ),
        ),
      );*/

  Widget loginButton() => RaisedButton(
    onPressed: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    },
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        //side: BorderSide(color:  LightColor.blueLinkedin)
    ),
    color: Colors.blue,//LightColor.blueLinkedin,
    child: Container(
      //margin: EdgeInsets.all(10.0),
      //width:MediaQuery.of(context).size.width * 0.3,
      height: 50,
      child: Center(
        child: Text(
          getTranslated(context, 'signin'),
          style: TextStyle(
              color: LightColor.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: "Sego"),
        ),
      ),
    ),
  );
//-------------------------------------------------
  /*Widget createButton() => InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateAccountPage()));
        },
        child: Container(
          width: 150,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: LightColor.blueLinkedin,//Color(0xcc006a71),
          ),
          child: Center(
            child: Text(
              getTranslated(context, 'signup'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: "Mulish"),
            ),
          ),
        ),
      );*/

  Widget  createButton() => RaisedButton(
    onPressed: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateAccountPage()));
    },
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        //side: BorderSide(color:  LightColor.white)
    ),
    color: LightColor.white,
    child: Container(
      //width:MediaQuery.of(context).size.width * 0.30,
      height: 50,
      child: Center(
        child: Text(
          getTranslated(context, 'signup'),
          style: TextStyle(
              color: LightColor.blueLinkedin,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              fontFamily: "Sego"),
        ),
      ),
    ),
  );
}
