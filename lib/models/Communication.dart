import 'dart:convert';

import 'package:tcool_flutter/models/AbstractAuditingEntity.dart';
import 'package:tcool_flutter/models/Copropriete.dart';

class Communication extends AbstractAuditingEntity {

  int idCommunication;
  String title;
  String details;

  String attachment;

  Copropriete copropriete ;

  Communication({
    this.idCommunication,
    this.title,
    this.details,
    this.attachment,
    this.copropriete,
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
  );

  //----------------------------------------------------
  @override
  String toString() {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    return encoder.convert(this.toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'idCommunication': idCommunication,
      'title': title,
      'details': details,
      'attachment': attachment,
      'copropriete': copropriete?.toJson(),
      'createdBy' : createdBy,
      'createdDate' : createdDate.toIso8601String(),
      'lastModifiedBy' : lastModifiedBy,
      'lastModifiedDate' : lastModifiedDate.toIso8601String(),
      'version' : version??0
    };
  }


  factory Communication.fromJson(Map<String, dynamic> map) {
    return Communication(
      idCommunication: map['idCommunication'],
      title: map['title'],
      details: map['details'],
      attachment: map['attachment'],
      copropriete: Copropriete.fromJson(map['copropriete']),
      createdBy: map['createdBy'],
      createdDate: DateTime.parse(map['createdDate']),
      lastModifiedBy: map['lastModifiedBy'],
      lastModifiedDate: DateTime.parse(map['lastModifiedDate']),
      version: map['version'],
    );
  }
}
