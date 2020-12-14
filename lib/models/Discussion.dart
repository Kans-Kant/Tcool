import 'dart:convert';

import 'package:tcool_flutter/models/AbstractAuditingEntity.dart';

import 'Message.dart';

class Discussion extends AbstractAuditingEntity {

  int idDiscussion;
  String theme;
  String title;
  String details;
  String visibility;
  String status;
  String reference;
  List<Message> msgDiscussions;

  Discussion({
    this.idDiscussion,
    this.theme,
    this.title,
    this.details,
    this.visibility,
    this.status,
    this.reference,
    this.msgDiscussions,
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
      'idDiscussion': idDiscussion,
      'theme': theme,
      'title': title,
      'details': details,
      'visibility': visibility,
      'status': status,
      'reference': reference,
      'msgDiscussions': msgDiscussions?.map((x) => x?.toJson())?.toList(),
      'createdBy' : createdBy,
      'createdDate' : createdDate.toIso8601String(),
      'lastModifiedBy' : lastModifiedBy,
      'lastModifiedDate' : lastModifiedDate.toIso8601String(),
      'version' : version??0
    };
  }


  factory Discussion.fromJson(Map<String, dynamic> map) {
    return Discussion(
      idDiscussion: map['idDiscussion'],
      theme: map['theme'],
      title: map['title'],
      details: map['details'],
      visibility: map['visibility'],
      status: map['status'],
      reference: map['reference'],
      msgDiscussions: List<Message>.from(map['msgDiscussions']?.map((x) => Message.fromJson(x))),
      createdBy: map['createdBy'],
      createdDate: DateTime.parse(map['createdDate']),
      lastModifiedBy: map['lastModifiedBy'],
      lastModifiedDate: DateTime.parse(map['lastModifiedDate']),
      version: map['version'],
    );
  }
}
