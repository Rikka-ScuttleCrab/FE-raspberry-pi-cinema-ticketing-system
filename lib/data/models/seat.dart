class Seat {
  final int id;
  final String seatrow;
  final int seatnumber;

  Seat({
    required this.id,
    required this.seatrow,
    required this.seatnumber});

  factory Seat.fromMap(Map<String, dynamic> map) {
    return Seat(
      id: map['id']?.toInt() ?? 0,
      seatrow: map['seat_row'] ?? '',
      seatnumber: map['seat_number']?.toInt() ?? 0,
    );
  }
}