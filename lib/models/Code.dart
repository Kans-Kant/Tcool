import 'dart:convert';

class Code {
  int id;
  String content;

  Code({int id, String content}){
    this.id = id;
    this.content = content;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
    };
  }

  factory Code.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;

    return Code(
      id: map['id'],
      content: map['content'],
    );
  }

  //----------------------------------------------------
  @override
  String toString() {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    return encoder.convert(this.toJson());
  }

}
