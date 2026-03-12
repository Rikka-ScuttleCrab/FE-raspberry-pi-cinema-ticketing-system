
class TicketType {
  final int id;
  final String name;
  final double price;

  TicketType({
    required this.id,
    required this.name,
    required this.price});

  factory TicketType.fromMap(Map<String, dynamic> map) {
    return TicketType(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}