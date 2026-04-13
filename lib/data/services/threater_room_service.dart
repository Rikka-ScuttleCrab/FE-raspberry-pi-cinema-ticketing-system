import 'package:http/http.dart' as http;
import '../../global_variables.dart';

class TheaterRoomService {
  Future<http.Response> fetchSeatThis(int threater_room_id) async {
    return await http.get(
      Uri.parse("$uri/api/v1/theaterrooms/${threater_room_id}"),
      headers: {
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));
  }
}