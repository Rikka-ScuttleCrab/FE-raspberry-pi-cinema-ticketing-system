import 'package:flutter/material.dart';
import '../models/showtime.dart';
import '../repositories/showtime_repository.dart';
import '../failure.dart';
import 'error.dart';


class ShowtimeController extends ChangeNotifier {
  final ShowtimeRepository _repository = ShowtimeRepository();

  List<Showtime> _showtimes = [];
  bool _isLoading = false;
  Failure? _failure;

  List<Showtime> get showtimes => _showtimes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _failure?.message;

  Future<void> fetchShowtimes(int movie_id) async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    try {
      List<Showtime> fetchedList = await _repository.fetchTodayShowtime(movie_id);

      fetchedList.sort((a, b) {
        final timeA = a.starttime.split(':').map(int.parse).toList();
        final timeB = b.starttime.split(':').map(int.parse).toList();

        if (timeA[0] != timeB[0]) {
          return timeA[0].compareTo(timeB[0]);
        }
        return timeA[1].compareTo(timeB[1]);
      });

      _showtimes = fetchedList;
    } catch (e) {
      _failure = ErrorHandler.handle(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}