import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentCreationResponse {
  final String orderId;
  final String paymentUrl;
  final double totalAmount;

  PaymentCreationResponse({
    required this.orderId,
    required this.paymentUrl,
    required this.totalAmount,
  });
}

class VnpayService {
  static const backendBaseUrl = 'http://10.0.2.2:8000'; // emulator Android
  // với máy thật đổi: http://192.168.x.y:8000 hoặc http://localhost:8000 (iOS Simulator)
  static const createPaymentPath = '/api/v1/payments/create';

  static Future<PaymentCreationResponse> createPayment({
    required double amount,
    required String orderInfo,
    String orderType = 'other',
    String bankCode = '',
  }) async {
    final uri = Uri.parse('$backendBaseUrl$createPaymentPath');

    final body = {
      'amount': amount,
      'order_info': orderInfo,
      'order_type': orderType,
      if (bankCode.isNotEmpty) 'bank_code': bankCode,
    };

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Tạo payment thất bại, code=${response.statusCode}, body=${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final paymentUrl = json['payment_url'] as String?;
    final orderId = json['order_id'] as String?;
    final totalAmount = (json['total_amount'] ?? json['amount']) as num?;

    if (paymentUrl == null || orderId == null || totalAmount == null) {
      throw Exception('Response không đúng định dạng: ${response.body}');
    }

    return PaymentCreationResponse(
      orderId: orderId,
      paymentUrl: paymentUrl,
      totalAmount: totalAmount.toDouble(),
    );
  }
}
