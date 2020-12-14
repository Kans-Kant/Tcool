import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Evenement.dart';
import 'package:tcool_flutter/models/Message.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';

import '../models/Evenement.dart';

class EventController {
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
      var response = await http.post(Constants.EVENEMENTS + 'save-evenement',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token"
          },
          body: json.encode(i));
      if (response.statusCode == 200) {
        print('Evenement sauvegardée!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return save(i, context);
      } else {
        throw Exception('Failed save the Event!');
      }
    }
  }

  Future<int> saveEvent(Evenement e, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.post(Constants.EVENEMENTS + 'save-evenement',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token"
          },
          body: json.encode(e.toJson()));
      int ref;
      if (response.statusCode == 200) {
        Map parsed = json.decode(response.body);
        ref = parsed['idEvenement'];
        print('Evenement sauvegardée!');
        return ref;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return saveEvent(e, context);
      } else {
        throw Exception('Failed save the Event');
      }
    }
  }

  /*
 *
 get Intervention by id
*/
  Future<Evenement> getEventById(int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.EVENEMENTS + "$id",
          headers: {"Authorization": "Bearer $_token"});

      if (response.statusCode == 200) {
        return Evenement.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getEventById(id, context);
      } else {
        throw Exception('Failed to load Event');
      }
    }
  }

  /*
 *
 Get All Events  
*/
  Future<List<Evenement>> getAllEvenement(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.EVENEMENTS + 'all',
          headers: {"Authorization": "Bearer $_token"});
      List<Evenement> evenements;
      if (response.statusCode == 200) {
        Iterable list = json.decode(utf8.decode(response.bodyBytes));
        evenements =
            list.map<Evenement>((json) => Evenement.fromJson(json)).toList();
        return evenements;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllEvenement(context);
      } else {
        throw Exception('Failed to get all events!');
      }
    }
  }

  // get events in progress created by the current user
  Future<List<Evenement>> getEventsInProgessOfOwner(
      context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));

      var response = await http.get(
          Constants.EVENEMENTS +
              "in-progress/owned-by/${currentUser['username']}",
          headers: {"Authorization": "Bearer $_token"});
      List<Evenement> events;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        events = list
            .map<Evenement>((json) => Evenement.fromJson(json))
            .toList();
        return events;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getEventsInProgessOfOwner(context);
      }
    }
  }

  // get events created by the current user
  Future<List<Evenement>> getEventsWithOwnerAndStatus(
      context, String status) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));

      var response = await http.get(
          Constants.EVENEMENTS + "owned-by/${currentUser['username']}/$status",
          headers: {"Authorization": "Bearer $_token"});
      List<Evenement> events;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        events =
            list.map<Evenement>((json) => Evenement.fromJson(json)).toList();
        return events;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getEventsWithOwnerAndStatus(context, status);
      }
    }
  }

/*
 *
 Get All In Progress Events  
*/
  Future<List<Evenement>> getAllEventsEnCours(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.EVENEMENTS + 'encours',
          headers: {"Authorization": "Bearer $_token"});
      List<Evenement> evenements;
      if (response.statusCode == 200) {
        Iterable list = json
            .decode(utf8.decode(response.bodyBytes))
            .cast<Map<String, dynamic>>();
        evenements =
            list.map<Evenement>((json) => Evenement.fromJson(json)).toList();
        evenements.map((e) => print(e.toString()));
        return evenements;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllEventsEnCours(context);
      } else {
        throw Exception('Failed to get all In Progress Events!');
      }
    }
  }

  /*
 *
 Get All done Events  
*/
  Future<List<Evenement>> getAllEventsCloturees(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.EVENEMENTS + 'cloturees',
          headers: {"Authorization": "Bearer $_token"});
      List<Evenement> evenements;
      if (response.statusCode == 200) {
        Iterable list = json.decode(utf8.decode(response.bodyBytes));
        evenements =
            list.map<Evenement>((json) => Evenement.fromJson(json)).toList();
        return evenements;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllEventsCloturees(context);
      } else {
        throw Exception('Failed to get all done Events!');
      }
    }
  }

/*
 *
 Get All Canceled Interventions  
*/
  Future<List<Evenement>> getAllEventsAnnulees(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.EVENEMENTS + 'annulees',
          headers: {"Authorization": "Bearer $_token"});
      List<Evenement> evenements;
      if (response.statusCode == 200) {
        Iterable list = json.decode(utf8.decode(response.bodyBytes));
        evenements =
            list.map<Evenement>((json) => Evenement.fromJson(json)).toList();

        return evenements;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllEventsAnnulees(context);
      } else {
        throw Exception('Failed to get all Canceled Events!');
      }
    }
  }

/*
 *
 Update statute to Cancel
*/
  Future<Evenement> annulerStatus(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.EVENEMENTS + 'annuler-status',
          headers: {"Authorization": "Bearer $_token"});
      if (response.statusCode == 200) {
        Evenement result = json.decode(response.body);
        return result;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return annulerStatus(context);
      } else {
        throw Exception('Failed to get all Canceled Events!');
      }
    }
  }

/*
 *
 Update statute Done
*/
  cloturerStatus(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.EVENEMENTS + 'cloturer-status',
          headers: {"Authorization": "Bearer $_token"});
      return response;
    }
  }

  /*
 *
 Add messages
*/
  Future<void> addMessage(Message m, int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.put(Constants.EVENEMENTS + 'add-message/$id',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token"
          },
          body: json.encode(m.toJson()));
      if (response.statusCode == 200) {
        print('new msg Added!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return addMessage(m, id, context);
      } else {
        throw Exception('Failed to update the event!');
      }
    }
  }

  //******************************** Annuler Event **********************************

  Future<void> deleteEvenement(Evenement e, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var id = e.idEvenement;
      var response = await http.delete(Constants.EVENEMENTS + 'delete/$id',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_token"
        },
        /*body: json.encode(d.toJson())*/);

      if (response.statusCode == 200) {
        print('delete event!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return deleteEvenement(e, context);
      } else {
        throw Exception('Failed to delete the event!');
      }
    }
  }
}
