import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Code.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:http/http.dart' as http;

class CodeController {
  final storage = FlutterSecureStorage();
  Future<Code> getCodeById(int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.CODES + "$id",
          headers: {"Authorization": "Bearer $_token"});

      if (response.statusCode == 200) {
        return Code.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getCodeById(id, context);
      } else {
        throw Exception('Failed to load code');
      }
    }
  }

  // *************************** save a code ***********************/
  Future<void> saveCode(Code code, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.post(Constants.CODES + 'save',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token"
          },
          body: json.encode(code.toJson()));

      if (response.statusCode == 200) {
        print('code is saved!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return saveCode(code, context);
      } else {
        throw Exception('Failed save the code!');
      }
    }
  }

  /// *************************  get all Codes ********************************/
  Future<List<Code>> getAllCodes(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.CODES + 'all',
          headers: {"Authorization": "Bearer $_token"});
      List<Code> codes;

      if (response.statusCode == 200) {
        Iterable list = json.decode(utf8.decode(response.bodyBytes));
        codes =
            list.map<Code>((json) => Code.fromJson(json)).toList();
        return codes;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllCodes(context);
      } else {
        throw Exception('Failed to get all codes!');
      }
    }
  }
}
