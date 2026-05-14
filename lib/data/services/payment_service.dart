import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../global_variables.dart';

class PaymentService {
  Future<http.Response> postPayment(int amount, int orderId) async {
    return await http.post(
      Uri.parse("$uri/payment/create/${orderId}"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "amount": amount,
      }),
    ).timeout(const Duration(seconds: 10));
  }

  Future<http.Response> getPaymentStatus(int orderId) async {
    return await http.get(
      Uri.parse("$uri/payment/status-payos/$orderId"),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }
}