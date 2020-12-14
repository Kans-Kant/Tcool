import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Message.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';

import '../models/Communication.dart';

class CommunicationController {
  final storage = FlutterSecureStorage();

  /*
 *
 Save Event
*/
  Future<void> save(Map i, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.post(Constants.COMMUNICATIONS + 'save-communication',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token"
          },
          body: json.encode(i));
      if (response.statusCode == 200) {
        print('communication sauvegardée!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return save(i, context);
      } else {
        throw Exception('Failed save the communication');
      }
    }
  }

  // *************************** save a communication ***********************/
  Future<int> saveCommunication(Communication c, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      print(c.toJson());
      var response = await http.post(Constants.COMMUNICATIONS + 'save-communication',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token"
          },
          body: json.encode(c.toJson()));

      int ref;
      if (response.statusCode == 200) {
        Map parsed = json.decode(response.body);
        ref = parsed['idCommunication'];
        print("communication sauvegardée");
        return ref;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return saveCommunication(c, context);
      } else {
        Utils.showAlertDialog(context, getTranslated(context, "co_inscrit"));
        throw Exception('Failed save the communication!');
      }
    }
  }

  /*
 *
 get Intervention by id
*/
  Future<Communication> getCommunicationById(int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.COMMUNICATIONS + "$id",
          headers: {"Authorization": "Bearer $_token"});

      if (response.statusCode == 200) {
        return Communication.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getCommunicationById(id, context);
      } else {
        throw Exception('Failed to load Communication');
      }
    }
  }

  /*
 *
 Get All Events
*/
  Future<List<Communication>> getAllCommunication(int id,context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.COMMUNICATIONS + "all/$id",
          headers: {"Authorization": "Bearer $_token"});
      List<Communication> communications;
      if (response.statusCode == 200) {
        Iterable list = json.decode(utf8.decode(response.bodyBytes));
        communications =
            list.map<Communication>((json) => Communication.fromJson(json)).toList();
        return communications;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllCommunication(id,context);
      } else {
        throw Exception('Failed to get all communications!');
      }
    }
  }

  // get events in progress created by the current user
  Future<List<Communication>> getCommunicationsOfOwner(
      context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));

      var response = await http.get(
          Constants.COMMUNICATIONS +
              "owned-by/${currentUser['username']}",
          headers: {"Authorization": "Bearer $_token"});
      List<Communication> communications;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        communications = list
            .map<Communication>((json) => Communication.fromJson(json))
            .toList();
        return communications;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getCommunicationsOfOwner(context);
      }
    }
  }

  //******************************** Annuler Communication **********************************

  Future<void> deleteCommunication(Communication c, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var id = c.idCommunication;
      var response = await http.delete(Constants.COMMUNICATIONS + 'delete/$id',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_token"
        },
        /*body: json.encode(d.toJson())*/);

      if (response.statusCode == 200) {
        print('delete event!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return deleteCommunication(c, context);
      } else {
        throw Exception('Failed to delete the event!');
      }
    }
  }
}
