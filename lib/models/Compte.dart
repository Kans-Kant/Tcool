import 'dart:convert';

import 'package:tcool_flutter/models/AbstractAuditingEntity.dart';
import 'package:tcool_flutter/models/Copropriete.dart';
import 'package:tcool_flutter/models/Evenement.dart';
import 'package:tcool_flutter/models/Notification.dart';

import 'AppRole.dart';
import 'Discussion.dart';
import 'Intervention.dart';
import 'Operation.dart';

class Compte extends AbstractAuditingEntity {
  int idCompte;
  String avatar;
  String firstName;
  String lastName;
  String immeuble;
  String appartement;
  String email;
  String phone;
  String password;
  List<AppRole> myRoles;
  List<Discussion> myDiscussions;
  List<Evenement> myEvents;
  List<Intervention> myInterventions;
  List<Operation> myOperations;
  List<Notification> myNotifications;
  List<Copropriete> coproprietes;

  Compte({
    int idCompte,
    String avatar,
    String firstName,
    String lastName,
    String immeuble,
    String appartement,
    String email,
    String phone,
    String password,
    List<AppRole> myRole,
    List<Discussion> myDiscussions,
    List<Evenement> myEvents,
    List<Intervention> myInterventions,
    List<Operation> myOperations,
    List<Notification> myNotifications,
    List<Copropriete> coproprietes,
    String createdBy,
    DateTime createdDate,
    String lastModifiedBy,
    DateTime lastModifiedDate,
    int version
  }) : super (
      createdBy : createdBy,
      createdDate : createdDate,
      lastModifiedBy : lastModifiedBy,
      lastModifiedDate : lastModifiedDate,
      version : version
  )
  {
    this.idCompte = idCompte;
    this.avatar = avatar;
    this.firstName= firstName;
    this.lastName = lastName;
    this.immeuble = immeuble;
    this.appartement = appartement;
    this.email = email;
    this.phone = phone;
    this.password = password;
    this.myRoles = myRole;
    this.myDiscussions = myDiscussions;
    this.myEvents = myEvents;
    this.myInterventions = myInterventions;
    this.myOperations = myOperations;
    this.myNotifications = myNotifications;
    this.coproprietes = coproprietes;

  }

  //----------------------------------------------------
 @override
  String toString() {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    return encoder.convert(this.toJson());
  }
  

  Map<String, dynamic> toJson() {
    return {
      'idCompte': idCompte,
      'avatar' : avatar,
      'firstName': firstName,
      'lastName': lastName,
      'immeuble': immeuble,
      'appartement': appartement,
      'email': email,
      'phone': phone,
      'password': password,
      'myRole': myRoles?.map((x) => x?.toJson())?.toList(),
      'myDiscussions': myDiscussions?.map((x) => x?.toJson())?.toList(),
      'myEvents': myEvents?.map((x) => x?.toJson())?.toList(),
      'myInterventions': myInterventions?.map((x) => x?.toJson())?.toList(),
      'myOperations': myOperations?.map((x) => x?.toJson())?.toList(),
      'myNotifications': myNotifications?.map((x) => x?.toJson())?.toList(),
      'coproprietes': coproprietes?.map((x) => x?.toJson())?.toList(),
      'createdBy' : createdBy,
      'createdDate' : createdDate.toIso8601String(),
      'lastModifiedBy' : lastModifiedBy,
      'lastModifiedDate' : lastModifiedDate.toIso8601String(),
      'version' : version??0
    
    };
  }

  factory Compte.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Compte(
      idCompte: map['idCompte'],
      avatar:map['avatar'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      immeuble: map['immeuble'],
      appartement: map['appartement'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
      myRole: List<AppRole>.from(map['myRole']?.map((x) => AppRole.fromJson(x))),
      myDiscussions: List<Discussion>.from(map['myDiscussions']?.map((x) => Discussion.fromJson(x))),
      myEvents: List<Evenement>.from(map['myEvents']?.map((x) => Evenement.fromJson(x))),
      myInterventions: List<Intervention>.from(map['myInterventions']?.map((x) => Intervention.fromJson(x))),
      myOperations: List<Operation>.from(map['myOperations']?.map((x) => Operation.fromJson(x))),
      myNotifications: List<Notification>.from(map['myNotifications']?.map((x) => Notification.fromJson(x))),
      coproprietes: List<Copropriete>.from(map['coproprietes']?.map((x) => Copropriete.fromJson(x))),
      createdBy: map['createdBy'],
      createdDate: DateTime.parse(map['createdDate']),
      lastModifiedBy: map['lastModifiedBy'],
      lastModifiedDate: DateTime.parse(map['lastModifiedDate']),
      version: map['version'],
    );
  }
}

