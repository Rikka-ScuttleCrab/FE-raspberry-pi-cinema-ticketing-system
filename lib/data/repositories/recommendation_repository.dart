import 'dart:convert';

import '../services/recommendation_service.dart';

class RecommendationRepository {

  final RecommendationService _service =
      RecommendationService();

  Future<List<dynamic>> fetchRecommendations(
    int userId,
  ) async {

    try {

      final response =
          await _service.fetchRecommendations(userId);

      if (response.statusCode == 200) {

        return jsonDecode(
          utf8.decode(response.bodyBytes),
        );
      }

      return [];

    } catch (e) {

      return [];
    }
  }

  Future<void> trackMovie(
    int movieId,
  ) async {

    await _service.trackMovie(
      movieId,
    );
  }
}