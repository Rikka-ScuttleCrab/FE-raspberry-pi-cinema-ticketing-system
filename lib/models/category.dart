
class Category {
  final int id;
  final String name;
  final String description;
  Category({
    required this.id,
    required this.name,
    required this.description,  
    });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }
}