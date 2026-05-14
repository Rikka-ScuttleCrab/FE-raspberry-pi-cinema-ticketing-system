import 'package:demo/data/models/order_session.dart';
import 'package:demo/data/models/order_detail.dart';
import '../failure.dart';
import '../services/order_service.dart';
import 'dart:convert';

class OrderRepository {
  final OrderService _service = OrderService();

  Future<OrderSession> postOrder(OrderSession order) async {
    try {
      final response = await _service.postOrder(order);

      if (response.statusCode != 200) {
        throw ServerFailure(
          "Server error ${response.statusCode}: ${response.body}",
        );
      }

      final json = jsonDecode(response.body);

      final data = json['data'];

      return OrderSession.fromMap(data);
    } catch (e) {
      throw NetworkFailure("Không thể tạo order: $e");
    }
  }

  Future<OrderDetail> getOrderData(int orderId) async {
    try {
      final response = await _service.getOrderData(orderId);

      switch (response.statusCode) {
        case 200:
          final json = jsonDecode(response.body);

          final data = json['data'];

          return OrderDetail.fromMap(data);

        case 404:
          throw const ServerFailure("Không tìm thấy order");

        case 500:
          throw const ServerFailure("Lỗi server nội bộ");

        default:
          throw ServerFailure("Server error ${response.statusCode}");
      }
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw NetworkFailure("Không thể lấy order: $e");
    }
  }
}
