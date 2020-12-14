import 'dart:convert';

class AppRole {
  int id;
  String role;

  AppRole({int id, String role}){
    this.id = id;
    this.role = role;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
    };
  }

factory AppRole.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return AppRole(
      id: map['id'],
      role: map['role'],
    );
  }

 //----------------------------------------------------
 @override
  String toString() {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    return encoder.convert(this.toJson());
  }

}
