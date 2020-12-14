import 'dart:convert';

import 'package:tcool_flutter/models/AbstractAuditingEntity.dart';

class EvenementDocs extends AbstractAuditingEntity {
  int idEventDoc;

  String name;
  String content;
  String extension;



  EvenementDocs(
      {
        int idEventDoc,
        String name,
        String content,
        String extension,
        String createdBy,
        DateTime createdDate,
        String lastModifiedBy,
        DateTime lastModifiedDate,
        int version})
      : super(
            createdBy: createdBy,
            createdDate: createdDate,
            lastModifiedBy: lastModifiedBy,
            lastModifiedDate: lastModifiedDate,
            version: version) {
    this.idEventDoc = idEventDoc;
    this.name = name;
    this.content = content;
    this.extension = extension;
  }

   //----------------------------------------------------
 @override
  String toString() {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    return encoder.convert(this.toJson());
  }

    Map<String, dynamic> toJson() {
    return {
      'idEventDoc': idEventDoc,
      'name': name,
      'content':content,
      'extension':extension,
      'createdBy' : createdBy,
      'createdDate' : createdDate.toIso8601String(),
      'lastModifiedBy' : lastModifiedBy,
      'lastModifiedDate' : lastModifiedDate.toIso8601String(),
      'version' : version??0
    };
  }

   factory EvenementDocs.fromJson(Map<String, dynamic> map){
    return EvenementDocs(
      idEventDoc: map['idEventDoc'],
      name: map['name'],
      content: map['content'],
      extension: map['extension'],
      createdBy: map['createdBy'],
      createdDate: DateTime.parse(map['createdDate']),
      lastModifiedBy: map['lastModifiedBy'],
      lastModifiedDate: DateTime.parse(map['lastModifiedDate']),
      version: map['version'],
    );
  }
}
