import 'dart:convert';

import 'AbstractAuditingEntity.dart';

class Reservation extends AbstractAuditingEntity {
  int idReservation;
  String field;
  // day of reservation
  DateTime day;
  // reservation time
  int startHour;
  // number of persons to use the fields
  int numberOfPersons;
  String phoneNumber;
  String description;

  Reservation({
    this.idReservation,
    this.field,
    this.day,
    this.startHour,
    this.numberOfPersons,
    this.phoneNumber,
    this.description,
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

 @override
  String toString() {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    return encoder.convert(this.toJson());
  }

    Map<String, dynamic> toJson() {
      return {
      'idReservation': idReservation,
      'field': field,
      'day': day.toIso8601String(),
      'startHour': startHour,
      'numberOfPersons': numberOfPersons,
      'phoneNumber': phoneNumber,
      'description': description,
      'createdBy' : createdBy,
      'createdDate' : createdDate.toIso8601String(),
      'lastModifiedBy' : lastModifiedBy,
      'lastModifiedDate' : lastModifiedDate.toIso8601String(),
      'version' : version??0
    };
  }

  factory Reservation.fromJson(Map<String, dynamic> map) {
    return Reservation(
      idReservation: map['idReservation'],
      field: map['field'],
      day: DateTime.parse(map['day']),
      startHour: map['startHour'],
      numberOfPersons: map['numberOfPersons'],
      phoneNumber: map['phoneNumber'],
      description: map['description'],
      createdBy: map['createdBy'],
      createdDate: DateTime.parse(map['createdDate']),
      lastModifiedBy: map['lastModifiedBy'],
      lastModifiedDate: DateTime.parse(map['lastModifiedDate']),
      version: map['version'],
    );
  }

}