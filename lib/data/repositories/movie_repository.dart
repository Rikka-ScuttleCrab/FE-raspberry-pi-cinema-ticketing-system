import '../models/movie.dart';
import '../failure.dart';
import 'dart:convert';
import '../services/movie_service.dart';

class MovieRepository {
  final MovieService _service = MovieService();

  Future<List<Movie>> fetchMovies() async {
    try {
      final response = await _service.fetchNowShowing();

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        var moviesData = data['data'];

        List<dynamic> listData = [];

        if (moviesData is List) {
          listData = moviesData;
        } else if (moviesData is Map && moviesData['result'] != null) {
          listData = moviesData['result'];
        }

        return listData.map((e) => Movie.fromMap(e)).toList();
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

  // Repository lấy chi tiết 1 phim
  Future<Movie> fetchMovieDetail(Movie movie) async {
    try {
      final response = await _service.fetchMovieDetail(movie);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        final movieData = jsonResponse['data'];

        return Movie.fromMap(movieData);
      } else {
        throw ServerFailure("Lỗi server: ${response.statusCode}");
      }
    } catch (e) {
      throw NetworkFailure(
        "Không thể kết nối đến máy chủ, Lỗi Data/Network: $e",
      );
    }
  }
}
