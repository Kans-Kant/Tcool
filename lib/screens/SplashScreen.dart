import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcool_flutter/screens/MainScreen.dart';
import 'package:tcool_flutter/screens/SplashScreen1.dart';
import 'package:tcool_flutter/screens/acceuil.dart';

import 'introScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final storage = FlutterSecureStorage();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userExits(context),
      builder: (context, AsyncSnapshot snapshot) {
        // if  user is not signed in, go to LoginPage
        if(!snapshot.hasData)  return IntroScreen();//Acceuil();
        if(snapshot.hasData && snapshot.data ==2) {
              // if user is signed in
              return MainScreen(currentPage: 0,);
          }
        if(snapshot.hasData && snapshot.data ==1) {
          // if user is not signed but entered already the code
          return Acceuil();
        }
        if(snapshot.hasData && snapshot.data ==0) {
          // if user is not signed in and no code is present
          return IntroScreen();
        }
        else {
             // when there is no data
          return IntroScreen();
          }
      },
    );
  }


  /*Future<bool> userExits(context) async {
    String _token = await storage.read(key: 'token');
    Map _currentUser ;
    if( await storage.read(key: 'currentUser') !=null){
      _currentUser = json.decode(await storage.read(key: 'currentUser'));
    }
    print('my token $_token');
    if(_token !=null && _currentUser != null) {
      return true;
    } else{
      return false;
    }
  }*/

  Future<int> userExits(context) async {
    String _token = await storage.read(key: 'token');
    String _code = await storage.read(key: 'code');
    Map _currentUser ;
    if( await storage.read(key: 'currentUser') !=null){
      _currentUser = json.decode(await storage.read(key: 'currentUser'));
    }
    print('my token $_token');
    if(_token !=null && _currentUser != null && _code!=null) {
      return 2;
    }
    if(_token ==null && _currentUser == null && _code!=null) {
      return 1;
    }
    else{
      return 0;
    }
  }
}