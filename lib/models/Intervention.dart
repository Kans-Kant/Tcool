import 'dart:convert';
import 'package:tcool_flutter/models/AbstractAuditingEntity.dart';
import 'package:tcool_flutter/resources/models.dart';

import 'Message.dart';

class Intervention extends AbstractAuditingEntity {
  int idIntervention;
  String theme;
  String title;
  String details;
  String compteRendu;
  String evaluation;
  String status;
  String audio;
  String images;
  String location;
  double latitude;
  double longitude;
  Compte intervenant;
  List<Message> msgInterventions;

  Intervention({
    this.idIntervention,
     this.theme,
    this.title,
    this.details,
    this.compteRendu,
    this.evaluation,
    this.status,
    this.audio,
    this.images,
    this.location,
    this.intervenant,
    this.latitude,
    this.longitude,
    this.msgInterventions,
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

    //----------------------------------------------------
 @override
  String toString() {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    return encoder.convert(this.toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'idIntervention': idIntervention,
      'theme': theme,
      'title': title,
      'details': details,
      'compteRedndu': compteRendu,
      'evaluation': evaluation,
      'status': status,
      'audio': audio,
      'images': images,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'intervenant': intervenant?.toJson(),
      'msgInterventions': msgInterventions?.map((x) => x?.toJson())?.toList(),
      'createdBy' : createdBy,
      'createdDate' : createdDate.toIso8601String(),
      'lastModifiedBy' : lastModifiedBy,
      'lastModifiedDate' : lastModifiedDate.toIso8601String(),
      'version' : version??0
    };
  }

  factory Intervention.fromJson(Map<String, dynamic> map) {
    return Intervention(
      idIntervention: map['idIntervention'],
      theme: map['theme'],
      title: map['title'],
      details: map['details'],
      compteRendu: map['compteRendu'],
      evaluation: map['evaluation'],
      status: map['status'],
      audio: map['audio'],
      images: map['images'],
      location: map['location'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      intervenant: Compte.fromJson(map['intervenant']),
      msgInterventions: List<Message>.from(map['msgInterventions']?.map((x) => Message.fromJson(x))),
      createdBy: map['createdBy'],
      createdDate: DateTime.parse(map['createdDate']),
      lastModifiedBy: map['lastModifiedBy'],
      lastModifiedDate: DateTime.parse(map['lastModifiedDate']),
      version: map['version'],
    );
  }

  
}
