import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:tcool_flutter/resources/models.dart';

class CompteController {
  final storage = FlutterSecureStorage();

  //******************************* get account by id */
  Future<Compte> getAccount(int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.get(Constants.COMPTES + "$id",
          headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        return Compte.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAccount(id, context);
      } else {
        throw Exception('Failed to load account');
      }
    }
  }

  //******************************* get account by id */
  Future<Compte> getCurrentAccount(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));
      var response = await http.get(Constants.COMPTES + "${currentUser['id']}",
          headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        return Compte.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 401) {
        print('Get current account');
        String _newToken = await Utils.generateNewToken();
        return getCurrentAccount(context);
      } else {
        throw Exception('Failed to load account');
      }
    }
  }

  //******************************* get Not readed notifs of account*/
  Future<Compte> getCurrentAccountNoRead(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));
      var response = await http.get(
          Constants.COMPTES + "notif-no-read-cpt/" + "${currentUser['id']}",
          headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        return Compte.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 401) {
        print('Get current account');
        String _newToken = await Utils.generateNewToken();
        getCurrentAccountNoRead(context);
      } else {
        throw Exception('Failed to load account');
      }
    }
  }

  //******************************** save an account */
  Future<void> saveAccount(Compte c, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.post(Constants.COMPTES + 'save-account',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode(c.toJson()));

      if (response.statusCode == 200) {
        print('Create a new account!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return saveAccount(c, context);
      } else {
        throw Exception('Failed to create an account!');
      }
    }
  }

  //******************* update an account************************ */
  Future<void> updateAccount(Compte c, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.put(
          Constants.COMPTES + 'update/' + "${c.idCompte}",
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode(c.toJson()));

      if (response.statusCode == 200) {
        String _newToken = await Utils.generateNewToken();
        print('Update the account with id: ' + "${c.idCompte}");
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return updateAccount(c, context);
      } else {
        throw Exception('Failed to update the account');
      }
    }
  }

  //**************************** delete an account**************** */
  Future<void> deleteAccount(int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.delete(Constants.COMPTES + 'delete/$id',
          headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        print('Delete with success');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return deleteAccount(id, context);
      } else {
        throw new Exception("Failed to delete the account with id: $id");
      }
    }
  }

  //******************** get all account*********************/
  Future<List<Compte>> getAllAccounts(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.get(Constants.COMPTES + 'all',
          headers: {"Authorization": "Bearer $token"});
      List<Compte> accounts;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        accounts = list.map<Compte>((json) => Compte.fromJson(json)).toList();
        return accounts;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllAccounts(context);
      } else {
        throw Exception('Failed to load all accounts!');
      }
    }
  }

  // ********************** get all intervenants accounts *********************/
  Future<List<Compte>> getAllIntervenants(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.get(Constants.COMPTES + 'intervenants',
          headers: {"Authorization": "Bearer $token"});
      List<Compte> accounts;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        accounts = list.map<Compte>((json) => Compte.fromJson(json)).toList();
        return accounts;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllIntervenants(context);
      } else {
        throw Exception('Failed to load all intervenants!');
      }
    }
  }

  // ********************** get all gestionnaires accounts *********************/
  Future<List<Compte>> getAllGestionnaires(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.get(Constants.COMPTES + 'gestionnaires',
          headers: {"Authorization": "Bearer $token"});
      List<Compte> accounts;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        accounts = list.map<Compte>((json) => Compte.fromJson(json)).toList();
        return accounts;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllGestionnaires(context);
      } else {
        throw Exception('Failed to load all gestionnairess accounts!');
      }
    }
  }

  //****************************** notifiy all gestionnaire account************/
  Future<List<Compte>> sendNotificationGestionnaire(
      Notification notification, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.post(Constants.COMPTES + 'notif-gestionnaire',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode(notification));
      List<Compte> accounts;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        accounts = list.map<Compte>((json) => Compte.fromJson(json)).toList();
        return accounts;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return sendNotificationGestionnaire(notification, context);
      } else {
        throw Exception('Failed to notify all gestionaire account!');
      }
    }
  }

  //****************************** notifiy all intervenant account************/
  Future<List<Compte>> addNotificationIntervenant(
      Notification notification, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.post(Constants.COMPTES + 'notif-intervenant',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode(notification));
      List<Compte> accounts;
      if (response.statusCode == 200) {
        print("Gestionnaire notifiée");
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        accounts = list.map<Compte>((json) => Compte.fromJson(json)).toList();
        return accounts;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return addNotificationIntervenant(notification, context);
      } else {
        throw Exception('Failed to notify all intervenant account!');
      }
    }
  }

  //****************************** notifiy all resident account************/
  Future<List<Compte>> sendNotificationResidents(
      Notification notification, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.post(Constants.COMPTES + 'notif-resident',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode(notification));
      List<Compte> accounts;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        accounts = list.map<Compte>((json) => Compte.fromJson(json)).toList();
        return accounts;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return sendNotificationResidents(notification, context);
      } else {
        throw Exception('Failed to notify all resident account!');
      }
    }
  }

  //****************************** notifiy admin account************/
  Future<Compte> sendNotificationToAdmin(
      Notification notification, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.post(Constants.COMPTES + 'notif-acteur/1',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode(notification));
      if (response.statusCode == 200) {
        return Compte.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return sendNotificationToAdmin(notification, context);
      } else {
        throw Exception('Failed to notify the admin');
      }
    }
  }

  //****************************** notifiy user account************/
  Future<Compte> sendNotificationToActeur(
      Notification notification, int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.post(Constants.COMPTES + 'notif-acteur/$id',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode(notification));
      if (response.statusCode == 200) {
        print("envoyé");
        return Compte.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return sendNotificationToActeur(notification, id, context);
      } else {
        throw Exception('Failed to notify the Actor');
      }
    }
  }

  //****************************** notifiy user account by email ************/
  Future<Compte> sendNotificationToActeurByEmmail(
      Notification notification, String email, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.post(
          Constants.COMPTES + 'notif-acteur-by-email/$email',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode(notification));
      if (response.statusCode == 200) {
        print("envoyé");
        return Compte.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return sendNotificationToActeurByEmmail(notification, email, context);
      } else {
        throw Exception('Failed to notify the Actor');
      }
    }
  }

  //------------------------ notification not read of user with id-------------
  Future<List<Notification>> getAllUnreadNotification(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
       Map currentUser;
      if(await storage.read(key: 'currentUser') != null)
       currentUser= json.decode(await storage.read(key: 'currentUser'));
      var response = await http.get(
          Constants.COMPTES + 'notif-no-read/' + "${currentUser['id']}",
          headers: {"Authorization": "Bearer $token"});
      List<Notification> notifications;
      if (response.statusCode == 200) {
        Iterable list = json
            .decode(utf8.decode(response.bodyBytes))
            .cast<Map<String, dynamic>>();
        notifications = list
            .map<Notification>((json) => Notification.fromJson(json))
            .toList();
        return notifications;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllUnreadNotification(context);
      } else {
        throw Exception('Failed to get unread notifications!');
      }
    }
  }

  //------------------------ notification not read of user with id-------------
  Future<List<Notification>> getAllUnreadNotificationV2() async {
    String token = await storage.read(key: 'token');
    Map currentUser = json.decode(await storage.read(key: 'currentUser'));
    var response = await http.get(
        Constants.COMPTES + 'notif-no-read/' + "${currentUser['id']}",
        headers: {"Authorization": "Bearer $token"});
    List<Notification> notifications;
    if (response.statusCode == 200) {
      Iterable list = json
          .decode(utf8.decode(response.bodyBytes))
          .cast<Map<String, dynamic>>();
      notifications = list
          .map<Notification>((json) => Notification.fromJson(json))
          .toList();
      print(notifications);
      return notifications;
    } else if (response.statusCode == 401) {
      String _newToken = await Utils.generateNewToken();
      return getAllUnreadNotificationV2();
    } else {
      throw Exception('Failed to get unread notifications!');
    }
  }

  //------------------------ notification already read of user with id-------------
  Future<List<Notification>> getAllreadNotification(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));
      var response = await http.get(
          Constants.COMPTES + 'notif-already-read/' + "${currentUser['id']}",
          headers: {"Authorization": "Bearer $token"});
      List<Notification> notifications;
      if (response.statusCode == 200) {
        Iterable list = json
            .decode(utf8.decode(response.bodyBytes))
            .cast<Map<String, dynamic>>();
        notifications = list
            .map<Notification>((json) => Notification.fromJson(json))
            .toList();
        return notifications;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllreadNotification(context);
      } else {
        throw Exception('Failed to get read notifications!');
      }
    }
  }
}
