import 'package:http/http.dart' as http;
import '../../global_variables.dart';

class TicketService {
  Future<http.Response> fetchTickets(int orderId) async {
    return await http.get(
      Uri.parse("$uri/api/v1/tickets/${orderId}"),
      headers: {
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));
  }

  Future<http.Response> sendQr(int orderId) async {
    return await http.post(
      Uri.parse("$uri/api/v1/tickets/send/$orderId"),
      headers: {
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 15));
  }
}