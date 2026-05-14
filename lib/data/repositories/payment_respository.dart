import '../failure.dart';
import '../services/payment_service.dart';
import 'dart:convert';

class PaymentRepository {
  final PaymentService _service = PaymentService();

  Future<String> postPayment(int amount, int orderId) async {
    try {
      final response = await _service.postPayment(amount, orderId);

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode != 200) {
        throw ServerFailure(
          "Server error ${response.statusCode}: ${response.body}",
        );
      }

      final json = jsonDecode(response.body);

      final checkoutUrl = json['data']['checkoutUrl'];

      if (checkoutUrl == null) {
        throw ServerFailure("Không tìm thấy checkoutUrl");
      }

      return checkoutUrl;
    } catch (e) {
      throw NetworkFailure(
        "Không thể lấy link thanh toán: $e",
      );
    }
  }

  Future<String> getPaymentStatus(int orderId) async {
    try {
      final response = await _service.getPaymentStatus(orderId);

      if (response.statusCode != 200) {
        throw ServerFailure("Status error ${response.statusCode}");
      }

      final json = jsonDecode(response.body);

      return json['data']['status']; // 👉 "PAID"
    } catch (e) {
      throw NetworkFailure("Lỗi check payment: $e");
    }
  }
}
