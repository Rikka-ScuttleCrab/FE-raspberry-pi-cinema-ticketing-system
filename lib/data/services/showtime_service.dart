import 'package:http/http.dart' as http;
import '../../global_variables.dart';

class ShowtimeService {
  Future<http.Response> fetchTodayShowing(int movie_id) async {
    return await http.get(
      Uri.parse("$uri/api/v1/showtimes/today/${movie_id}"),
      headers: {
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));
  }
}