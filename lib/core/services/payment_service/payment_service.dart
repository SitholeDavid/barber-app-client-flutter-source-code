import 'dart:convert';

import 'package:barber_app_client/core/services/payment_service/payment_service_interface.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class PaymentService extends PaymentServiceInterface {
  HttpsCallable initializeTransaction = CloudFunctions.instance
      .getHttpsCallable(functionName: 'initializeTransaction');
  HttpsCallable verify = CloudFunctions.instance
      .getHttpsCallable(functionName: 'verifyTransaction');

  @override
  Future initialise() async {
    await PaystackPlugin.initialize(
        publicKey: 'pk_test_728add73cec3b2538cd27e9d416ecd0a513d9325');
  }

  @override
  Future<String> startTransaction(String email, int amount) async {
    try {
      var result = await initializeTransaction
          .call(<String, dynamic>{'email': email, 'amount': amount});

      return result.data as String;
    } catch (e) {
      return 'ERROR';
    }
  }

  @override
  Future<bool> verifyTransaction(String reference) async {
    try {
      var result = await verify.call(<String, dynamic>{'reference': reference});

      return result.data as bool;
    } catch (e) {
      return false;
    }
  }
}
