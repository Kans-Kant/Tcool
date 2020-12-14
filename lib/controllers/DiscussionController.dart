import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Discussion.dart';
import 'package:http/http.dart' as http;
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:tcool_flutter/resources/models.dart';

class DiscussionController {
  final storage = FlutterSecureStorage();

  Future<Discussion> getDiscussById(int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.DISCUSSISONS + "$id",
          headers: {"Authorization": "Bearer $_token"});

      if (response.statusCode == 200) {
        return Discussion.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getDiscussById(id, context);
      } else {
        throw Exception('Failed to load discussion');
      }
    }
  }

  // *************************** save a discussion ***********************/
  Future<int> saveDiscussion(Discussion d, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      print(d.toJson());
      var response = await http.post(Constants.DISCUSSISONS + 'save-discussion',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token"
          },
          body: json.encode(d.toJson()));

      int ref;
      if (response.statusCode == 200) {
        Map parsed = json.decode(response.body);
        ref = parsed['idDiscussion'];
        print("discussion sauvegardé");
        return ref;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return saveDiscussion(d, context);
      } else {
        throw Exception('Failed save the discussion!');
      }
    }
  }

  // ******************** add message *****************************/
  Future<void> addMessage(Message m, int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.put(Constants.DISCUSSISONS + 'add-message/$id',
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

  // *************************** update a discussion ***********************/
  Future<void> updateDiscussion(Discussion d, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var id = d.idDiscussion;
      var response = await http.put(Constants.DISCUSSISONS + 'update/$id',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token"
          },
          body: json.encode(d.toJson()));

      if (response.statusCode == 200) {
        print('Update discussion!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return updateDiscussion(d, context);
      } else {
        throw Exception('Failed to update the discussion!');
      }
    }
  }

  /// *************************  get all discussions ********************************/
  Future<List<Discussion>> getAllDiscussions(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.DISCUSSISONS + 'all',
          headers: {"Authorization": "Bearer $_token"});
      List<Discussion> discussions;

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        discussions =
            list.map<Discussion>((json) => Discussion.fromJson(json)).toList();
        return discussions;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllDiscussions(context);
      } else {
        throw Exception('Failed to get all discussions!');
      }
    }
  }

  // get discussions in progress created by the current user
  Future<List<Discussion>> getDiscussionsInProgessOfOwner(
      context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));

      var response = await http.get(
          Constants.DISCUSSISONS +
              "in-progress/owned-by/${currentUser['username']}",
          headers: {"Authorization": "Bearer $_token"});
      List<Discussion> discussions;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        discussions = list
            .map<Discussion>((json) => Discussion.fromJson(json))
            .toList();
        return discussions;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getDiscussionsInProgessOfOwner(context);
      }
    }
  }

  // get discussions by owner and status
  Future<List<Discussion>> getDiscussWithOwnerAndStatus(context, String status) async {
        // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));

      var response = await http.get(Constants.DISCUSSISONS + "owned-by/${currentUser['username']}/$status",
        headers: {"Authorization": "Bearer $_token"});
            List<Discussion> discussions;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        discussions =
            list.map<Discussion>((json) => Discussion.fromJson(json)).toList();
        return discussions;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getDiscussWithOwnerAndStatus(context, status);
      }
    }
  }

  // get all in-progress discussions
  Future<List<Discussion>> getAllDiscussInProgress(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.DISCUSSISONS + 'in-progress',
          headers: {"Authorization": "Bearer $_token"});
      List<Discussion> discussions;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        discussions =
            list.map<Discussion>((json) => Discussion.fromJson(json)).toList();
        return discussions;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllDiscussInProgress(context);
      }
    }
  }

  // get all closed discussions
  Future<List<Discussion>> getAllDiscussClosed(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.DISCUSSISONS + 'closed',
          headers: {"Authorization": "Bearer $_token"});
      List<Discussion> discussions;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        discussions =
            list.map<Discussion>((json) => Discussion.fromJson(json)).toList();
        return discussions;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllDiscussClosed(context);
      } else {
        throw Exception('Failed to load discussions closed!');
      }
    }
  }

  // get all rejected discussions
  Future<List<Discussion>> getAllDiscussRejected(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.DISCUSSISONS + 'rejected',
          headers: {"Authorization": "Bearer $_token"});
      List<Discussion> discussions;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        discussions =
            list.map<Discussion>((json) => Discussion.fromJson(json)).toList();
        return discussions;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllDiscussRejected(context);
      } else {
        throw Exception('Failed to load discussions closed!');
      }
    }
  }

  //******************************** Annuler Discussion **********************************

  Future<void> deleteDiscussion(Discussion d, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var id = d.idDiscussion;
      var response = await http.delete(Constants.DISCUSSISONS + 'delete/$id',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token"
          },
          /*body: json.encode(d.toJson())*/);

      if (response.statusCode == 200) {
        print('delete discussion!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return deleteDiscussion(d, context);
      } else {
        throw Exception('Failed to delete the discussion!');
      }
    }
  }
}
