import 'dart:convert';

import 'package:tcool_flutter/models/AbstractAuditingEntity.dart';
import 'package:tcool_flutter/models/Compte.dart';

class Copropriete extends AbstractAuditingEntity {
  int idCopropriete;
  String name;
  String details;
  Compte gestionnaire;
  int nbResidents;
  String city;
  List<Compte> listResidents;

  Copropriete({
    this.idCopropriete,
    this.name,
    this.details,
    this.gestionnaire,
    this.nbResidents,
    this.city,
    this.listResidents,
    String createdBy,
    DateTime createdDate,
    String lastModifiedBy,
    DateTime lastModifiedDate,
    int version
  }) : super(
      createdBy : createdBy,
      createdDate : createdDate,
      lastModifiedBy : lastModifiedBy,
      lastModifiedDate : lastModifiedDate,
      version : version   
  );


  Map<String, dynamic> toJson() {
    return {
      'idCopropriete': idCopropriete,
      'name': name,
      'details': details,
      'gestionnaire': gestionnaire?.toJson(),
      'nbResidents': nbResidents,
      'city': city,
      'listResidents': listResidents?.map((x) => x?.toJson())?.toList(),
      'createdBy' : createdBy,
      'createdDate' : createdDate.toIso8601String(),
      'lastModifiedBy' : lastModifiedBy,
      'lastModifiedDate' : lastModifiedDate.toIso8601String(),
      'version' : version??0
    };
  }

  factory Copropriete.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Copropriete(
      idCopropriete: map['idCopropriete'],
      name: map['name'],
      details: map['details'],
      gestionnaire: Compte.fromJson(map['gestionnaire']),
      nbResidents: map['nbResidents'],
      city: map['city'],
      listResidents: List<Compte>.from(map['listResidents']?.map((x) => Compte.fromJson(x))),
      createdBy: map['createdBy'],
      createdDate: DateTime.parse(map['createdDate']),
      lastModifiedBy: map['lastModifiedBy'],
      lastModifiedDate: DateTime.parse(map['lastModifiedDate']),
      version: map['version'],
    );
  }

 //----------------------------------------------------
 @override
  String toString() {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    return encoder.convert(this.toJson());
  }

}
