import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../global_variables.dart';

class OTPService {
  Future<http.Response> sendGmailOTP(String email) async {
    return await http.post(
      Uri.parse("$uri/otp/send"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email": email,
      }),
    ).timeout(const Duration(seconds: 10));
  }

  Future<http.Response> verifyEmailOTP(String email, String OTPCode) async {
    return await http.post(
      Uri.parse("$uri/otp/verify"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email": email,
        "otp": OTPCode
      }),
    ).timeout(const Duration(seconds: 10));
  }
}