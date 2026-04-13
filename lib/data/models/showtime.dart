import 'seat.dart';
import 'ticket_type.dart';

class Showtime {
  final int id;
  final String starttime;
  final DateTime dayshow;
  final List<Seat> book_seats;
  final TicketType ticket_type;
  final int theater_room_id;
  final String theater_room_name;

  Showtime({
    required this.id,
    required this.starttime,
    required this.dayshow,
    required this.book_seats,
    required this.ticket_type,
    required this.theater_room_id,
    required this.theater_room_name,
  });

  factory Showtime.fromMap(Map<String, dynamic> map) {
    return Showtime(
      id: map['id'] ?? 0,
      dayshow: map['dayshow'] != null
          ? DateTime.parse(map['dayshow'])
          : DateTime(1970),
      starttime: map['start_time'] ?? '',
      ticket_type: map['ticket_type'] != null
          ? TicketType.fromMap(map['ticket_type'])
          : TicketType(id: 0, name: '', price: 0.0),
      book_seats: (map['booked_seats'] as List<dynamic>? ?? [])
          .map((item) => Seat.fromMap(item))
          .toList(),
      theater_room_id: map['theater_room_id'] ?? 0,
      theater_room_name: map['theater_room_name'] ?? ''
    );
  }
}