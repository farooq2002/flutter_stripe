import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeScreen extends StatefulWidget {
  const StripeScreen({super.key});

  @override
  State<StripeScreen> createState() => _StripeScreenState();
}

class _StripeScreenState extends State<StripeScreen> {
  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent("200", "USD");
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!["client_secret"],
        // applePay: PaymentSheetApplePay(),
        style: ThemeMode.dark,
        merchantDisplayName: "US",
      ));
      displayPayment();
    } catch (E) {
      debugPrint(E.toString());
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        "amount": calculatePayment(amount),
        "currency": currency,
        "payment_method_types[]": "card"
      };
      var response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization":
                "Bearer sk_test_51O3vTBFjZlcFvaF0heDfqENtV1vnp6Kups6TWAIjSg0Ic8meW7WOFCU8tZj5lZO1bKJO4hhRDACiNL2sQSZ5oSuT00zt2cJYZ9",
            "Content-Type": "application/x-www-form-urlencoded"
          });
      return jsonDecode(response.body.toString());
    } catch (E) {
      debugPrint(E.toString());
    }
  }

  calculatePayment(String amount) {
    final price = int.parse(amount) * 280;
    return price.toString();
  }

  displayPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet(
          options: const PaymentSheetPresentOptions(timeout: 3));
      setState(() {
        paymentIntent = null;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("PAYMENT SUCCEED!")));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Stripe")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () async {
                await makePayment();
              },
              child: Container(
                height: 45,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.deepPurple),
                child: const Center(
                    child: Text(
                  "PAY",
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
