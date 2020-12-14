import 'dart:convert';

import 'package:tcool_flutter/models/AbstractAuditingEntity.dart';
import 'package:tcool_flutter/models/EvenementDocs.dart';
import 'package:tcool_flutter/resources/utils.dart';

import 'Message.dart';

class Evenement extends AbstractAuditingEntity {
  int idEvenement;
  String title;
  String details;
  String visibility;
  String status;
  String duration;
  //add event date;
  DateTime eventDate;
  //add a document
  //String document;
  List<EvenementDocs> documents;
  List<Message> msgEvents;

  Evenement({
    this.idEvenement,
    this.title,
    this.details,
    this.visibility,
    this.status,
    this.duration,
    this.eventDate,//event date add
    //this.document, //document soit pièce jointe
    this.documents,
    this.msgEvents,
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
      'idEvenement': idEvenement,
      'title': title,
      'details': details,
      'visibility': visibility,
      'status': status,
      'duration': duration,
      'eventDate': eventDate.toIso8601String(), // add event date
      //'document': document,//pièce jointe
      'documents': documents?.map((x) => x?.toJson())?.toList(),
      'msgEvents': msgEvents?.map((x) => x?.toJson())?.toList(),
      'createdBy' : createdBy,
      'createdDate' : createdDate.toIso8601String(),
      'lastModifiedBy' : lastModifiedBy,
      'lastModifiedDate' : lastModifiedDate.toIso8601String(),
      'version' : version??0
    };
  }

  factory Evenement.fromJson(Map<String, dynamic> map) {
    return Evenement(
      idEvenement: map['idEvenement'],
      title: map['title'],
      details: map['details'],
      visibility: map['visibility'],
      status: map['status'],
      duration: map['duration'],
      eventDate: DateTime.parse(map['eventDate']), // add event date
      //document: map['document'], //pièce jointe
      documents: List<EvenementDocs>.from(map['documents']?.map((x) => EvenementDocs.fromJson(x))),
      msgEvents: List<Message>.from(map['msgEvents']?.map((x) => Message.fromJson(x))),
      createdBy: map['createdBy'],
      createdDate: DateTime.parse(map['createdDate']),
      lastModifiedBy: map['lastModifiedBy'],
      lastModifiedDate: DateTime.parse(map['lastModifiedDate']),
      version: map['version'],
    );
  }


}
