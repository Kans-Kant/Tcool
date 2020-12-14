import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:tcool_flutter/resources/constants.dart';

class Utils {
  static final storage = new FlutterSecureStorage();

  
  /* if the token is expired this method should be called */
  static Future<String> generateNewToken() async {
    Map currentUser = json.decode(await storage.read(key: 'currentUser'));
    print("token expired, generating new new token ...");
    String username = currentUser['username'];
    String password = await storage.read(key: "password");

    Map body = {
      'username': username,
      'password': password,
    };
    var response = await http.post(
      Constants.LOGIN,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      Map parsed = json.decode(response.body);
      await storage.write(key: 'token', value: parsed['token']);
      //modification
      return parsed['token'];
    }
    return null;
  }

  static void showAlertDialog(context, String message) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
                padding: const EdgeInsets.all(20.0), child: Text(message)),
          );
        });
  }



   showSnackBar(String message){
     return SnackBar(
       content: Text(message, style: TextStyle(color: Colors.white),),
       backgroundColor: Color.fromARGB(155, 6, 138, 122),
       duration: Duration(seconds: 3),
     );
   }

  static String dateFormat(String s) {
    var date = s.substring(0, 10);
    var hour = s.substring(11, 19);
    return '$date $hour';
  }

  static Duration parseDuration(String s) {
  int hours = 0;
  int minutes = 0;
  int micros;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
 // micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  return Duration(hours: hours, minutes: minutes);
}

static bool isAdmin(String s){
  return s == "ADMIN";
}

static bool isGestionnaire(String s){
  return s == "GESTIONNAIRE";
}

static bool isIntervenant(String s){
  return s == "INTERVENANT";
}

static Future<String> getCurrentRole() async{
  final storage = new FlutterSecureStorage();
   Map currentUser = json.decode(await storage.read(key: 'currentUser'));
   return currentUser['authorities'][0]['authority'];
}

  // -------------------------------------------------------------------------------------
  static Future<bool> connected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
    return false;
  }

  Future<bool> requestPermissions() async {
    var permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    }

    return permission == PermissionStatus.granted;
  }

}


