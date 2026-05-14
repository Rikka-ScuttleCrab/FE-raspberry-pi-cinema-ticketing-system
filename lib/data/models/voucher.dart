
class Voucher {
  final int id;
  final String value;
  final String messeger;

  Voucher({
    required this.id,
    required this.value,
    required this.messeger
  });

  factory Voucher.fromMap(Map<String, dynamic> map) {
    return Voucher(
      id: map['id'] ?? 0,
      value: map['voucher_value'] ?? '',
      messeger: map['messeger'] ?? '',
    );
  }
}
