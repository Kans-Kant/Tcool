import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:tcool_flutter/resources/models.dart';

class CoproprieteController {
  final storage = FlutterSecureStorage();

  //******************************* get copropriete by id */
  Future<Copropriete> getCopropriete(int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.get(Constants.COPROPRIETES + "$id",
          headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        return Copropriete.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getCopropriete(id, context);
      } else {
        throw Exception('Failed to load co-ownership');
      }
    }
  }

  //-------------------------- save co-ownership---------
  Future<void> saveCopropriete(Copropriete cop, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.post(Constants.COPROPRIETES + 'save',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode(cop.toJson()));

      if (response.statusCode == 200) {
        print('Create a new co-ownership!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return saveCopropriete(cop, context);
      } else {
        throw Exception('Failed to create a co-ownership!');
      }
    }
  }

  //******************* update an co-ownership ***********************/
  Future<void> updateCopropriete(Copropriete cop, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.put(
          Constants.COPROPRIETES + 'update/' + "${cop.idCopropriete}",
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode(cop.toJson()));

      if (response.statusCode == 200) {
        print('Update the co-ownership with id: ' + "${cop.idCopropriete}");
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return updateCopropriete(cop, context);
      } else {
        throw Exception('Failed to update co-ownership');
      }
    }
  }

  //**************************** delete an co-ownership **************** */
  Future<void> deleteCopropriete(int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.delete(Constants.COPROPRIETES + 'delete/$id',
          headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        print('Delete with success');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return deleteCopropriete(id, context);
      } else {
        throw new Exception("Failed to delete the co-ownership with id: $id");
      }
    }
  }

  //******************** get all account*********************/
  Future<List<Copropriete>> getAllCoproprietes(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.get(Constants.COPROPRIETES + 'all',
          headers: {"Authorization": "Bearer $token"});
      List<Copropriete> coownerships;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        coownerships = list
            .map<Copropriete>((json) => Copropriete.fromJson(json))
            .toList();
        return coownerships;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllCoproprietes(context);
      } else {
        throw Exception('Failed to load all co-ownsership!');
      }
    }
  }

  //******************** get all copropriété by compte*********************/
  Future<List<Copropriete>> getAllCoproprietesbyCompte(int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String token = await storage.read(key: 'token');
      var response = await http.get(Constants.COPROPRIETES + 'all/$id',
          headers: {"Authorization": "Bearer $token"});
      List<Copropriete> coownerships;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        coownerships = list
            .map<Copropriete>((json) => Copropriete.fromJson(json))
            .toList();
        return coownerships;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllCoproprietesbyCompte(id, context);
      } else {
        throw Exception('Failed to load all co-ownsership!');
      }
    }
  }
}
