import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Amount.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:http/http.dart' as http;

class OperationController {
  final storage = FlutterSecureStorage();

  Future<Operation> getOperationById(int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.OPERATIONS + "$id",
          headers: {"Authorization": "Bearer $_token"});

      if (response.statusCode == 200) {
        return Operation.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getOperationById(id, context);
      } else {
        throw Exception('Failed to load Operation');
      }
    }
  }

  // *************************** save a operation ***********************/
  Future<void> saveOperation(Operation operation, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.post(Constants.OPERATIONS + 'save',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token"
          },
          body: json.encode(operation.toJson()));

      if (response.statusCode == 200) {
        print('Operation is saved!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return saveOperation(operation, context);
      } else {
        throw Exception('Failed save the operation!');
      }
    }
  }

  // *************************** update a discussion ***********************/
  Future<void> updateOperation(Operation op, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var id = op.idOperation;
      var response = await http.put(Constants.OPERATIONS + 'update/$id',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token"
          },
          body: json.encode(op.toJson()));

      if (response.statusCode == 200) {
        print('Update operation!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return updateOperation(op, context);
      } else {
        throw Exception('Failed to update the operation!');
      }
    }
  }

  /// *************************  get all operations ********************************/
  Future<List<Operation>> getAllOperations(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.OPERATIONS + 'all',
          headers: {"Authorization": "Bearer $_token"});
      List<Operation> operations;

      if (response.statusCode == 200) {
        Iterable list = json.decode(utf8.decode(response.bodyBytes));
        operations =
            list.map<Operation>((json) => Operation.fromJson(json)).toList();
        return operations;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllOperations(context);
      } else {
        throw Exception('Failed to get all operations!');
      }
    }
  }

  // get all credits operations
  Future<List<Operation>> getAllCreditsOperations(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.OPERATIONS + 'credits-operations',
          headers: {"Authorization": "Bearer $_token"});
      List<Operation> operations;
      if (response.statusCode == 200) {
        Iterable list = json.decode(utf8.decode(response.bodyBytes));
        operations =
            list.map<Operation>((json) => Operation.fromJson(json)).toList();
        return operations;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllCreditsOperations(context);
      } else {
        throw Exception('Failed to get all operations!');
      }
    }
  }

  // get all debits operations
  Future<List<Operation>> getAllDebitsOperations(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.OPERATIONS + 'debits-operations',
          headers: {"Authorization": "Bearer $_token"});
      List<Operation> operations;
      if (response.statusCode == 200) {
        Iterable list = json.decode(utf8.decode(response.bodyBytes));
        operations =
            list.map<Operation>((json) => Operation.fromJson(json)).toList();
        return operations;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllDebitsOperations(context);
      } else {
        throw Exception('Failed to get all operations!');
      }
    }
  }

  // get amount of each operation
  Future<Amount> getAllAmounts(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.OPERATIONS + "get-amounts",
          headers: {"Authorization": "Bearer $_token"});

      if (response.statusCode == 200) {
        return Amount.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllAmounts(context);
      } else {
        throw Exception('Failed to load amounts');
      }
    }
  }
}
