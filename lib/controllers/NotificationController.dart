import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Notification.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:http/http.dart' as http;

class NotificationController {
  final storage = FlutterSecureStorage();

  /*********************** get a notification **********************/
  Future<Notification> getNotification(int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.get(Constants.NOTIFICATIONS + "$id",
          headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        return Notification.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getNotification(id, context);
      } else {
        throw Exception('Failed to load notification');
      }
    }
  }

  //------------------- save notification -----------------------------
  Future<void> saveNotification(Notification notif, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.post(
          Constants.NOTIFICATIONS + 'save-notification',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode(notif.toJson()));

      if (response.statusCode == 200) {
        print('Create a new account!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return saveNotification(notif, context);
      } else {
        throw Exception('Failed to save notification!');
      }
    }
  }

  //----------------------- update notification ----------------------------
  Future<void> updateNotification(int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.post(
        Constants.NOTIFICATIONS + 'update/$id',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        print('Create a new account!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return updateNotification(id, context);
      } else {
        throw Exception('Failed to update notification!');
      }
    }
  }

  //--------------------- unread notifications
  Future<List<Notification>> getAllUnreadNotification(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.get(
          Constants.NOTIFICATIONS + 'unread-notifications',
          headers: {"Authorization": "Bearer $token"});
      List<Notification> notifications;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        notifications = list
            .map<Notification>((json) => Notification.fromJson(json))
            .toList();
        return notifications;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllUnreadNotification(context);
      } else {
        throw Exception('Failed to load all notifications!');
      }
    }
  }

  //--------------------- read a notification
  Future<void> readNotification(int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.put(
        Constants.NOTIFICATIONS + 'read/$id',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (response.statusCode == 200) {
        print('Notification readed !!');
      } else if (response.statusCode == 401) {
        print('Get current account');
        String _newToken = await Utils.generateNewToken();
        readNotification(id, context);
      } else {
        throw Exception('Failed to read notification!');
      }
    }
  }
}
