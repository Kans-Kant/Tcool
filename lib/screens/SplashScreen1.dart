import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Code.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

import 'MainScreen.dart';
import 'acceuil.dart';

class SplashScreen1 extends StatefulWidget {

  @override
  _SplashScreen1State createState() =>
      _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {


  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColor.white,
      body: Stack(
          children: <Widget>[
            Center(
                child:Container(
                  padding: const EdgeInsets.only(top:25),
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Image.asset(
                    "assets/SUN SQUARE ALMAZ.jpg",
                    fit: BoxFit.cover,
                    height: 160,
                  ),
                )
            )
          ]),
    );
  }
}
