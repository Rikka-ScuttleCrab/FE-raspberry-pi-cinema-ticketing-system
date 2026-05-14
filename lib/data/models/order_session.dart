class OrderSession {
  int? id;
  int? showtimeId;
  String? name;
  String? info;
  List<SelectedSeat> seats;
  int? voucherId;
  int? total_amount;

  OrderSession({
    this.id,
    this.showtimeId,
    this.name,
    this.info,
    this.seats = const [],
    this.voucherId,
    this.total_amount
  });

  /// 🔥 FROM API
  factory OrderSession.fromMap(Map<String, dynamic> map) {
    return OrderSession(
      id: map['order_id'],
      total_amount: map['total_amount']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "showtime_id": showtimeId,
      "guest_name": name,
      "info": info,
      "voucher_id": voucherId,
      "seats": seats.map((e) => e.toMap()).toList(),
    };
  }
}


class SelectedSeat {
  String? row;
  int? number;

  SelectedSeat({this.row, this.number});

  Map<String, dynamic> toMap() {
    return {
      "seat_row": row,
      "seat_number": number,
    };
  }
}