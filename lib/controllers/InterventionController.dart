import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Intervention.dart';
import 'package:tcool_flutter/models/Message.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:http/http.dart' as http;

import 'package:async/async.dart';

import '../models/Intervention.dart';

class InterventionController {
  final storage = FlutterSecureStorage();

/*
 *
 Save Intervention  
*/
  Future<void> save(Map i, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.post(Constants.INTERVENTIONS + 'save-intervention', headers: {"Content-Type": "application/json", "Authorization": "Bearer $_token"}, body: json.encode(i));
      if (response.statusCode == 200) {
        print('Intervention sauvegardée!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return save(i, context);
      }
      throw Exception('Failed save the Intervention!');
    }
  }

  Future<int> saveIntervention(Intervention d, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.post(Constants.INTERVENTIONS + 'save-intervention', headers: {"Content-Type": "application/json", "Authorization": "Bearer $_token"}, body: json.encode(d.toJson()));
      int ref;
      if (response.statusCode == 200) {
        Map parsed = json.decode(response.body);
        ref = parsed['idIntervention'];
        print('intervention sauvegardée!');
        return ref;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return saveIntervention(d, context);
      }
    }
    //throw Exception('Failed save the intervention');
  }

/*
 *
 get Intervention by id
*/
  Future<Intervention> getInterById(int id, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.INTERVENTIONS + "$id", headers: {"Authorization": "Bearer $_token"});

      if (response.statusCode == 200) {
        return Intervention.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getInterById(id, context);
      } else {
        throw Exception('Failed to load Intervention');
      }
    }
  }

/*
 *
 Get All Interventions  
*/
  Future<List<Intervention>> getAllInterventions(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.INTERVENTIONS + 'all', headers: {"Authorization": "Bearer $_token"});
      List<Intervention> interventions;
      if (response.statusCode == 200) {
        Iterable list = json.decode(utf8.decode(response.bodyBytes));
        interventions = list.map<Intervention>((json) => Intervention.fromJson(json)).toList();
        return interventions;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllInterventions(context);
      } else {
        throw Exception('Failed to get all Interventions!');
      }
    }
  }

  // get interventions in progress created by the current user
  Future<List<Intervention>> getInterventionsInProgessOfOwner(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));

      var response = await http.get(Constants.INTERVENTIONS + "in-progress/owned-by/${currentUser['username']}", headers: {"Authorization": "Bearer $_token"});
      List<Intervention> interventions;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        interventions = list.map<Intervention>((json) => Intervention.fromJson(json)).toList();
        return interventions;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getInterventionsInProgessOfOwner(context);
      }
    }
  }

  // get interventions created by the current user
  Future<List<Intervention>> getInterventionsWithOwnerAndStatus(context, String status) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));

      var response = await http.get(Constants.INTERVENTIONS + "owned-by/${currentUser['username']}/$status", headers: {"Authorization": "Bearer $_token"});
      List<Intervention> interventions;
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body).cast<Map<String, dynamic>>();
        interventions = list.map<Intervention>((json) => Intervention.fromJson(json)).toList();
        return interventions;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getInterventionsWithOwnerAndStatus(context, status);
      }
    }
  }

/*
 *
 Get All In Progress Interventions  
*/
  Future<List<Intervention>> getAllInterventionsEnCours(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.INTERVENTIONS + 'encours', headers: {"Authorization": "Bearer $_token"});
      List<Intervention> interventions;
      if (response.statusCode == 200) {
        Iterable list = json.decode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();
        interventions = list.map<Intervention>((json) => Intervention.fromJson(json)).toList();

        return interventions;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllInterventionsEnCours(context);
      } else {
        throw Exception('Failed to get all In Progress Interventions!');
      }
    }
  }

/*
 *
 Get All done Interventions  
*/
  Future<List<Intervention>> getAllInterventionsCloturees(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.INTERVENTIONS + 'cloturees', headers: {"Authorization": "Bearer $_token"});
      List<Intervention> interventions;
      if (response.statusCode == 200) {
        Iterable list = json.decode(utf8.decode(response.bodyBytes));
        interventions = list.map<Intervention>((json) => Intervention.fromJson(json)).toList();
        return interventions;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllInterventionsCloturees(context);
      } else {
        throw Exception('Failed to get all done Interventions!');
      }
    }
  }

/*
 *
 Get All Canceled Interventions  
*/
  Future<List<Intervention>> getAllInterventionsAnnulees(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.INTERVENTIONS + 'annulees', headers: {"Authorization": "Bearer $_token"});
      List<Intervention> interventions;
      if (response.statusCode == 200) {
        Iterable list = json.decode(utf8.decode(response.bodyBytes));
        interventions = list.map<Intervention>((json) => Intervention.fromJson(json)).toList();

        return interventions;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return getAllInterventionsAnnulees(context);
      } else {
        throw Exception('Failed to get all Canceled Interventions!');
      }
    }
  }

/*
 *
 Update statute to Cancel
*/
  Future<Intervention> annulerStatus(context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.get(Constants.INTERVENTIONS + 'annuler-status', headers: {"Authorization": "Bearer $_token"});
      if (response.statusCode == 200) {
        Intervention result = json.decode(response.body);
        return result;
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return annulerStatus(context);
      } else {
        throw Exception('Failed to get all Canceled Interventions!');
      }
    }
  }

  /*
   * valider une intervention
   */
  Future<void> validerStatus(Intervention i, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.put(Constants.INTERVENTIONS + 'valider-status/' + "${i.idIntervention}", headers: {"Authorization": "Bearer $_token"});
      if (response.statusCode == 200) {
        print("Intervention ${i.idIntervention} validée!");
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return validerStatus(i, context);
      } else {
        throw Exception('Erreur !!');
      }
    }
  }

  /*
   * evaluer une intervention
   */

  Future<void> evaluerIntervention(Intervention i, String compteRendu, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.put(Constants.INTERVENTIONS + 'evaluer-status/' + "${i.idIntervention}/$compteRendu", headers: {"Content-Type": "application/json", "Authorization": "Bearer $_token"}, body: json.encode(i.toJson()));
      if (response.statusCode == 200) {
        print('intervention mise à jour => evaluer!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return evaluerIntervention(i, compteRendu, context);
      }
    }
    //throw Exception('Failed save the intervention');
  }

  //-------------------affecter une intervention
  Future<void> updateIntervention(Intervention i, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.put(Constants.INTERVENTIONS + 'affecter-status/' + "${i.idIntervention}", headers: {"Content-Type": "application/json", "Authorization": "Bearer $_token"}, body: json.encode(i.toJson()));
      if (response.statusCode == 200) {
        print('intervention mise à jour!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return updateIntervention(i, context);
      }
    }
    //throw Exception('Failed save the intervention');
  }

/*
 *
 Update statute Done
*/
  Future<void> cloturerStatus(Intervention i, String evaluation, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var response = await http.put(Constants.INTERVENTIONS + 'cloturer-status/' + "${i.idIntervention}/$evaluation", headers: {"Content-Type": "application/json", "Authorization": "Bearer $_token"}, body: json.encode(i.toJson()));
      if (response.statusCode == 200) {
        print('intervention mise à jour => Cloturée!');
      } else if (response.statusCode == 401) {
        String _newToken = await Utils.generateNewToken();
        return cloturerStatus(i, evaluation, context);
      }
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
      var response = await http.put(Constants.INTERVENTIONS + 'add-message/$id', headers: {"Content-Type": "application/json", "Authorization": "Bearer $_token"}, body: json.encode(m.toJson()));
      if (response.statusCode == 200) {
        print('new msg Added!');
      } else {
        throw Exception('Failed to update the intervention!');
      }
    }
  }

  // upload voice note
  Future<String> uploadAudio(File audio, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      // open a bytestream
      var stream = new http.ByteStream(DelegatingStream.typed(audio.openRead()));

      // get file length
      var length = await audio.length();
      //string to uri
      var uri = Uri.parse(Constants.INTERVENTIONS + 'upload-audio');
      var request = await http.MultipartRequest("POST", uri);
      request.headers['authorization'] = "Bearer $_token";
      // multipart that takes files
      var multipartFile = new http.MultipartFile("file", stream, length, filename: basename(audio.path));
      // add file to mutlipart
      request.files.add(multipartFile);
      // send
      var response = await request.send();
      print(response.statusCode);
      //listen for response
      response.stream.transform(utf8.decoder).listen((event) => {null});
      if (response.statusCode == 200) {
        return basename(audio.path);
      }
      return uploadAudio(audio, context);
    }
  }

  // download voice note
  Future<String> downloadAudio(String name, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      io.Directory dir;
      if (io.Platform.isIOS) {
        dir = await path_provider.getApplicationDocumentsDirectory();
      } else {
        dir = await path_provider.getExternalStorageDirectory();
      }
      var response = await get("${Constants.INTERVENTIONS}audio/$name", headers: {"Authorization": "Bearer $_token"});

      print(dir);
      File audio = new File(join(dir.path, '$name.wav'));
      bool fileExist = await audio.exists();
      if (fileExist) return audio.path;
      audio.writeAsBytesSync(response.bodyBytes);
      return audio.path;
    }
  }

  //******************************** Annuler Event **********************************

  Future<void> deleteIntervention(Intervention i, context) async {
    // check connection or try again
    if (!await Utils.connected()) {
      Utils.showAlertDialog(context, getTranslated(context, "test_connexion"));
    } else {
      String _token = await storage.read(key: 'token');
      var id = i.idIntervention;
      var response = await http.delete(
        Constants.INTERVENTIONS + 'delete/$id',
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $_token"},
        /*body: json.encode(d.toJson())*/
      );

      if (response.statusCode == 200) {
        print('delete the intervention!');
      } else if (response.statusCode == 401) {
        await Utils.generateNewToken();
        return deleteIntervention(i, context);
      } else {
        throw Exception('Failed to delete the intervention!');
      }
    }
  }
}
