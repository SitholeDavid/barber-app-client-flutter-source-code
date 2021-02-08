import 'package:barber_app_client/core/models/client.dart';
import 'package:barber_app_client/core/models/payment.dart';
import 'package:barber_app_client/core/services/auth_service/auth_service.dart';
import 'package:barber_app_client/core/services/auth_service/auth_service_interface.dart';
import 'package:barber_app_client/core/services/payment_service/payment_service_interface.dart';
import 'package:barber_app_client/core/services/payment_service/payment_service.dart';
import 'package:barber_app_client/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PaymentViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthServiceInterface>();
  final PaymentService _paymentService = locator<PaymentServiceInterface>();
  final NavigationService _navigationService = locator<NavigationService>();

  BuildContext context;
  String loadingText = 'Initializing...';
  double totalCost = 0;

  void initialise(double cost, BuildContext context) async {
    totalCost = cost;

    this.context = context;
    await _paymentService.initialise();
    await makePayment(context);
  }

  Future makePayment(BuildContext context) async {
    Client client = await _authService.getCurrentUser();
    print('CLIENT: ' + client.name + ' ' + client.clientID + '.');
    Payment payment = Payment(clientID: client.clientID, amount: totalCost);

    String result = await _paymentService.startTransaction(
        client.email, payment.amount.round());

    String accessCode = result.split(' ').first;
    String reference = result.split(' ').last;

    Charge charge = Charge()
      ..amount = payment.amount.round() * 100
      ..accessCode = accessCode
      ..currency = 'ZAR'
      ..email = client.email;

    final response = await PaystackPlugin.checkout(context, charge: charge);

    if (response.status == false)
      _navigationService.back(result: false);
    else {
      loadingText = 'Veryfing payment...';
      notifyListeners();

      bool verified = await _paymentService.verifyTransaction(reference);
      _navigationService.back(result: response.status && verified);
    }
  }
}
