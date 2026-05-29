import 'package:flutter/material.dart';

import '../repositories/recommendation_repository.dart';

class RecommendationController
    extends ChangeNotifier {

  final RecommendationRepository _repository =
      RecommendationRepository();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<dynamic> recommendations = [];

  Future<void> fetchRecommendations(
    int userId,
  ) async {

    _isLoading = true;

    notifyListeners();

    try {

      recommendations =
          await _repository.fetchRecommendations(
        userId,
      );

    } catch (e) {

      recommendations = [];

    } finally {

      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> trackMovie(
    int movieId,
  ) async {

    try {

      await _repository.trackMovie(
        movieId,
      );

    } catch (e) {

      debugPrint(
        "TRACK ERROR: $e",
      );
    }
  }
}