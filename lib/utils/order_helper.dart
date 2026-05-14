import '../data/models/order_session.dart';

class OrderHelper {
  static OrderSession buildOrder({
    required int showtimeId,
    required String name,
    required String contact,
    required List<String> seats,
    required double ticketPrice,
    String? voucherValue,
    int? voucherId,
  }) {
    double subTotal = ticketPrice * seats.length;

    double discount = 0;

    if (voucherValue != null) {
      discount = calculateDiscount(subTotal, voucherValue);
    }

    double total = subTotal - discount;

    return OrderSession(
      showtimeId: showtimeId,
      name: name,
      info: contact,
      voucherId: voucherId,
      total_amount: total.toInt(),
      seats: seats.map((s) {
        final row = s.substring(0, 1);
        final number = int.parse(s.substring(1));
        return SelectedSeat(row: row, number: number);
      }).toList(),
    );
  }

  static double calculateDiscount(double total, String voucherValue) {
    if (voucherValue.isEmpty) return 0;

    voucherValue = voucherValue.trim();

    double discount;

    if (voucherValue.contains('%')) {
      double percent = double.parse(voucherValue.replaceAll('%', ''));
      discount = total * percent / 100;
    } else {
      discount = double.parse(voucherValue);
    }

    if (discount > total) discount = total;

    return discount;
  }
}