import 'package:flutter/material.dart';
import '../models/theaterroom.dart';
import '../repositories/threater_room_repository.dart';
import '../failure.dart';
import 'error.dart';


class TheaterRoomController extends ChangeNotifier {
  final TheaterRoomRepository _repository = TheaterRoomRepository();

  List<TheaterRoom> _theaterrooms = [];
  bool _isLoading = false;
  Failure? _failure;

  List<TheaterRoom> get theaterrooms => _theaterrooms;
  bool get isLoading => _isLoading;
  String? get errorMessage => _failure?.message;

  Future<void> fetchSeats(int threater_room_id, String theater_room_name) async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    try {
      final index = _theaterrooms.indexWhere(
            (room) => room.id == threater_room_id,
      );
      if (index == -1) {
        final seats = await _repository.fetchRoomSeats(threater_room_id);
        final newRoom = TheaterRoom(
          id: threater_room_id,
          theaterName: theater_room_name,
          seats: seats,
        );
        _theaterrooms.add(newRoom);
      }
    } catch (e) {
      _failure = ErrorHandler.handle(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}