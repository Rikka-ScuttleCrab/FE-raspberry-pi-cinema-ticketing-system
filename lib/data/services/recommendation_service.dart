import 'package:http/http.dart' as http;
import '../../global_variables.dart';

class RecommendationService {

  Future<http.Response> fetchRecommendations(
    int userId,
  ) async {

    return await http.get(
      Uri.parse(
        "$uri/api/v1/recommendations/$userId",
      ),

      headers: {
        'Content-Type': 'application/json',
      },
    ).timeout(
      const Duration(seconds: 10),
    );
  }

  Future<void> trackMovie(
    int movieId,
  ) async {

    final response =
        await http.post(

      Uri.parse(
        "$uri/track/$movieId",
      ),
    );

    if (response.statusCode != 200) {

      throw Exception(
        "TRACK MOVIE FAIL",
      );
    }
  }
}