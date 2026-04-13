import '../models/showtime.dart';
import '../failure.dart';
import 'dart:convert';
import '../services/showtime_service.dart';

class ShowtimeRepository {
  final ShowtimeService _service = ShowtimeService();

  Future<List<Showtime>> fetchTodayShowtime(int movie_id) async {
    try {
      final response = await _service.fetchTodayShowing(movie_id);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        var showtimesData = data['data'];

        List<dynamic> listData = [];

        if (showtimesData is List) {
          listData = showtimesData;
        } else if (showtimesData is Map && showtimesData['result'] != null) {
          listData = showtimesData['result'];
        }

        return listData.map((e) => Showtime.fromMap(e)).toList();
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
