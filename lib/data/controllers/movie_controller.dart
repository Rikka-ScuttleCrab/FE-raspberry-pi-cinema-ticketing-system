import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import '../failure.dart';
import 'error.dart';


class MovieController extends ChangeNotifier {
  final MovieRepository _repository = MovieRepository();

  List<Movie> _movies = [];
  bool _isLoading = false;
  Failure? _failure;

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  String? get errorMessage => _failure?.message;

  Future<void> fetchMovies() async {
    _isLoading = true;
    _failure = null;
    notifyListeners();
    debugPrint("CALL API MOVIES");
    try {
      _movies = await _repository.fetchMovies();
    } catch (e) {
      _failure = ErrorHandler.handle(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initData() async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    try {
      _movies = await _repository.fetchMovies();
      
    } catch (e) {
      _failure = ErrorHandler.handle(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}