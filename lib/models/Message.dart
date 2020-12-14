import 'dart:convert';

import 'package:tcool_flutter/models/AbstractAuditingEntity.dart';

class Message extends AbstractAuditingEntity {
  int idMessage;
  String message;

  Message({
    int idMessage,
    String message,
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
  )
  {
    this.idMessage = idMessage;
    this.message = message;
  }

    //----------------------------------------------------
 @override
  String toString() {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    return encoder.convert(this.toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'idMessage': idMessage,
      'message': message,
      'createdBy' : createdBy,
      'createdDate' : createdDate.toIso8601String(),
      'lastModifiedBy' : lastModifiedBy,
      'lastModifiedDate' : lastModifiedDate.toIso8601String(),
      'version' : version??0
    };
  }

  factory Message.fromJson(Map<String, dynamic> map){
    return Message(
      idMessage: map['idMessage'],
      message: map['message'],
      createdBy: map['createdBy'],
      createdDate: DateTime.parse(map['createdDate']),
      lastModifiedBy: map['lastModifiedBy'],
      lastModifiedDate: DateTime.parse(map['lastModifiedDate']),
      version: map['version'],
    );
  }
}
