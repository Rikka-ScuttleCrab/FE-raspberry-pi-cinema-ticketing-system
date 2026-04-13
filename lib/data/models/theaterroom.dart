import 'seat.dart';

class TheaterRoom {
  final int id;
  final String theaterName;
  final List<Seat> seats;


  TheaterRoom({
    required this.id,
    required this.theaterName,
    required this.seats,
  });

  factory TheaterRoom.fromMap(Map<String, dynamic> map) {
    return TheaterRoom(
      id: map['id'] ?? 0,
      theaterName: map['theater_room_name'] ?? '',
      seats: (map['seats'] as List<dynamic>? ?? [])
          .map((item) => Seat.fromMap(item))
          .toList(),
    );
  }
}
