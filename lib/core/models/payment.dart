import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class Payment {
  String paymentID;
  String clientID;
  double amount;
  String reference;

  String generateReference() {
    if (reference == null || reference.isEmpty) {
      String uid = Uuid().v1();
      reference = 'booking fee ${amount.round()} $uid';
    }

    return reference;
  }

  Payment(
      {this.paymentID,
      @required this.clientID,
      @required this.amount,
      this.reference});

  Payment.fromMap(Map<String, dynamic> map, String uid) {
    paymentID = uid;
    clientID = map['clientID'];
    amount = map['amount'];
    reference = map['reference'];
  }

  Map<String, dynamic> toJson() =>
      {'clientID': clientID, 'amount': amount, 'reference': reference};
}
