import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:tcool_flutter/resources/models.dart';

import 'package:http/http.dart' as http;

class MessageController {
  final storage = FlutterSecureStorage();

  //--------------- save a message
  Future<void> saveMessage(Message message, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: "token");

      var response = await http.post(Constants.MESSAGES + 'save-message',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode(message.toJson()));

      if (response.statusCode == 200) {
        print("Message is saved!");
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return saveMessage(message, context);
      } else {
        throw Exception("Error saving the message!");
      }
    }
  }
}
