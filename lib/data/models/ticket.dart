class Ticket {
  final int id;
  final String movie_title;
  final DateTime? show_date;
  final String start_time;
  final String theater_room_name;
  final String seat_name;
  final DateTime? created_at;
  final String status;
  // final DateTime? paid_at;

  Ticket(
      this.id,
      this.movie_title,
      this.show_date,
      this.start_time,
      this.theater_room_name,
      this.seat_name,
      this.created_at,
      this.status,
      // this.paid_at
      );

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      map['id'] ?? 0,
      map['movie_title'] ?? '',
      map['show_date'] != null
          ? DateTime.parse(map['show_date']) : null,
      map['start_time'] ?? '',
      map['theater_room_name'] ?? '',
      map['seat_name'] ?? '',
      map['created_at'] != null
          ? DateTime.parse(map['created_at']) : null,
      map['status'] ?? '',
      // map['paid_at'] != null
      //     ? DateTime.parse(map['paid_at']) : null,
    );
  }
}
