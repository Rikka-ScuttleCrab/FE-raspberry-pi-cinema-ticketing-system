import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../global_variables.dart';
import '../models/order_session.dart';

class OrderService {
  Future<http.Response> postOrder(OrderSession order) async {
    return await http
        .post(
          Uri.parse("$uri/api/v1/orders/"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "showtime_id": order.showtimeId,
            "guest_name": order.name,
            "info": order.info,
            "seats": order.seats.map((e) => e.toMap()).toList(),
            "voucher_id": order.voucherId,
          }),
        )
        .timeout(const Duration(seconds: 10));
  }

  Future<http.Response> getOrderData(int orderId) async {
    final url = Uri.parse(
      "$uri/api/v1/orders/$orderId",
    );

    return await http
        .get(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 10));
  }
}
