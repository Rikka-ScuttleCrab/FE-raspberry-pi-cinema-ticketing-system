import 'ticket_type.dart';
import 'category.dart';

class Film {
  final int id;
  final String name;
  List<Category> categories;
  final String posterImageURL;
  final String duration;
  final String description;
  List<TicketType> tickets;

  Film({
    required this.id,
    required this.name,
    required this.categories,
    required this.posterImageURL,
    required this.duration,
    required this.description,
    required this.tickets,
  });

  factory Film.fromMap(Map<String, dynamic> map) {
    return Film(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      posterImageURL: map['posterImageURL'] ?? '',
      duration: map['duration'] ?? '',
      description: map['description'] ?? '',
      categories:
          (map['categories'] as List?)
              ?.map((v) => Category.fromMap(v))
              .toList() ??
          [],
      tickets:
          (map['tickets'] as List?)
              ?.map((v) => TicketType.fromMap(v))
              .toList() ??
          [],
    );
  }
}
