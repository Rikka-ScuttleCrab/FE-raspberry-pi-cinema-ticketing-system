import '../failure.dart';
import 'dart:convert';
import '../services/threater_room_service.dart';
import '../models/seat.dart';

class TheaterRoomRepository {
  final TheaterRoomService _service = TheaterRoomService();

  Future<List<Seat>> fetchRoomSeats(int threater_room_id) async {
    try {
      final response = await _service.fetchSeatThis(threater_room_id);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        var TheaterRoomData = data['data'];

        List<dynamic> listData = [];

        if (TheaterRoomData is List) {
          listData = TheaterRoomData;
        } else if (TheaterRoomData is Map && TheaterRoomData['result'] != null) {
          listData = TheaterRoomData['result'];
        }

        return listData.map((e) => Seat.fromMap(e)).toList();
      } else {
        throw ServerFailure(
          "Server error ${response.statusCode}: ${response.body}",
        );
      }
    } catch (e) {
      throw NetworkFailure(
        "Không thể kết nối đến máy chủ, Lỗi Data/Network: $e",
      );
    }
  }
}
