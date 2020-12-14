import 'dart:convert';

import 'package:tcool_flutter/models/AbstractAuditingEntity.dart';

class Operation extends AbstractAuditingEntity {
  int idOperation;
  String title;
  String details;
  double amount;
  String typeOp;

  Operation({
    int idOperation,
    String title,
    String details,
    double amount,
    String typeOp,
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
  ) {
    this.idOperation = idOperation;
    this.title = title;
    this.details = details;
    this.amount = amount;
    this.typeOp = typeOp;
  }

    //----------------------------------------------------
 @override
  String toString() {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    return encoder.convert(this.toJson());
  }


  Map<String, dynamic> toJson() {
    return {
      'idOperation': idOperation,
      'title': title,
      'details': details,
      'amount': amount,
      'typeOp': typeOp,
      'createdBy': createdBy,
      'createdDate': createdDate.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
      'lastModifiedDate': lastModifiedDate.toIso8601String(),
      'version': version,
    };
  }

  factory Operation.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Operation(
      idOperation: map['idOperation'],
      title: map['title'],
      details: map['details'],
      amount: map['amount'],
      typeOp: map['typeOp'],
      createdBy: map['createdBy'],
      createdDate: DateTime.parse(map['createdDate']),
      lastModifiedBy: map['lastModifiedBy'],
      lastModifiedDate: DateTime.parse(map['lastModifiedDate']),
      version: map['version'],
    );
  }
}
