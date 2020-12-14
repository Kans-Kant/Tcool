import 'dart:convert';

import 'package:tcool_flutter/models/AbstractAuditingEntity.dart';

class Notification extends AbstractAuditingEntity {
  int idNotification;
  String message;
  bool isRead;
  String theme;
  String createdBy;
  DateTime createdDate;
  String lastModifiedBy;
  DateTime lastModifiedDate;
  int version;
  int parentId;

  Notification({
    int idNotification,
    String message,
    bool isRead,
    String theme,
    String createdBy,
    DateTime createdDate,
    String lastModifiedBy,
    DateTime lastModifiedDate,
    int version,
    int parentId
    
  }) : super (
      createdBy : createdBy,
      createdDate : createdDate,
      lastModifiedBy : lastModifiedBy,
      lastModifiedDate : lastModifiedDate,
      version : version
    )
  {
    this.idNotification = idNotification;
    this.message = message;
    this.isRead = isRead;
    this.theme = theme;
    this.parentId = parentId;
  }

    //----------------------------------------------------
 @override
  String toString() {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    return encoder.convert(this.toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'idNotification': idNotification,
      'message': message,
      'isRead': isRead,
      'theme': theme,
      'parentId': parentId,
      'createdBy': createdBy,
      'createdDate': createdDate.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
      'lastModifiedDate': lastModifiedDate.toIso8601String(),
      'version': version??0,
    };
  }

  factory Notification.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Notification(
      idNotification: map['idNotification'],
      message: map['message'],
      isRead: map['isRead'],
      theme: map['theme'],
      parentId: map['parentId'],
      createdBy: map['createdBy'],
      createdDate: DateTime.parse(map['createdDate']),
      lastModifiedBy: map['lastModifiedBy'],
      lastModifiedDate: DateTime.parse(map['lastModifiedDate']),
      version: map['version'],
    );
  }
}
