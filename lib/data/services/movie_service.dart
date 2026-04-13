import 'package:http/http.dart' as http;
import '../../global_variables.dart';
import '../models/movie.dart';

class MovieService {
  Future<http.Response> fetchNowShowing() async {
    return await http.get(
      Uri.parse("$uri/api/v1/movies/now-showing"),
      headers: {
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));
  }

  Future<http.Response> fetchMovieDetail(Movie movie) async {
    return await http.get(
      Uri.parse("$uri/api/v1/movies/${movie.id}"),
      headers: {
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));
  }
}