import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/resources/utils.dart';

class ReservationController {

  final storage = FlutterSecureStorage();

  // save reservation
  Future<void> saveReservation(Reservation reservation, context) async {
    // check connection or try again
    if(!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.post(Constants.RESERVATIONS + 'save-reservation',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode(reservation.toJson()));

      if (response.statusCode == 200) {
        print("Create a new reservation");
      } else if(response.statusCode == 401) {
        await Utils.generateNewToken();
        return saveReservation(reservation, context);
      } else {
        throw Exception("Failed to create a reservation!");
      }
    }
  }

  // delete a reservation
  Future<void> deleteReservation(int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.delete(Constants.RESERVATIONS + 'delete/$id',
          headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        print('Delete with success');
      } else if (response.statusCode == 401) {
        await Utils.generateNewToken();
        return deleteReservation(id, context);
      } else {
        throw new Exception("Failed to delete reservation with id: $id");
      }
    }
  }

  // get all reservations
  Future<List<Reservation>> getAllReservations(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.get(Constants.RESERVATIONS + 'all',
          headers: {"Authorization": "Bearer $token"});
      List<Reservation> reservations;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
       reservations = list
            .map<Reservation>((json) => Reservation.fromJson(json))
            .toList();
        return reservations;
      } else if (response.statusCode == 401) {
        await Utils.generateNewToken();
        return getAllReservations(context);
      } else {
        throw Exception('Failed to load all reservation!');
      }
    }
  }
}