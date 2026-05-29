import 'dart:convert';
import '../failure.dart';
import '../services/ticket_service.dart';
import '../models/ticket.dart';

class TicketRepository {
  final TicketService _service = TicketService();

  Future<List<Ticket>> fetchTickets(int orderId) async {
    try {
      final response = await _service.fetchTickets(orderId);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final ticketData = data['data'];

        List<dynamic> listData = [];

        if (ticketData is List) {
          listData = ticketData;
        } else if (ticketData is Map && ticketData['result'] != null) {
          listData = ticketData['result'];
        }

        return listData
            .map((e) => Ticket.fromMap(e as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerFailure(
          "Server error ${response.statusCode}: ${response.body}",
        );
      }
    } catch (e) {
      throw NetworkFailure(
        "Không thể kết nối đến máy chủ, lỗi: $e",
      );
    }
  }


  Future<bool> sendQr(int orderId) async {

    try {

      final response =
          await _service.sendQr(orderId);

      if (response.statusCode == 200) {

        final data =
            jsonDecode(
              utf8.decode(response.bodyBytes),
            );

        return data["success"] == true;
      }

      return false;

    } catch (e) {

      return false;
    }
  }
}