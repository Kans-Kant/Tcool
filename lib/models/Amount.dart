import 'dart:convert';

class Amount {
  double debitAmount;
  double creditAmount;

    Amount({double debitAmount, double creditAmount}){
    this.debitAmount = debitAmount;
    this.creditAmount = creditAmount;
  }

  Map<String, dynamic> toJson() {
    return {
      'debitAmount': debitAmount,
      'creditAmount': creditAmount,
    };
  }

factory Amount.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Amount(
      debitAmount: map['debitAmount'],
      creditAmount: map['creditAmount'],
    );
  }

 //----------------------------------------------------
 @override
  String toString() {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    return encoder.convert(this.toJson());
  }
}