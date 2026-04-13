class Movie {
  final int id;
  final String title;
  final String description;
  final String actors;
  final String ageRating;
  final int durationMin;
  final List<String> categories;
  final List<String> posterPaths;
  final List<String> trailerPaths;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.actors,
    required this.ageRating,
    required this.durationMin,
    required this.categories,
    required this.posterPaths,
    required this.trailerPaths,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      actors: map['actors'] ?? '',
      ageRating: map['age_rating'] ?? '',
      durationMin: map['duration_min'] ?? 0,
      categories: List<String>.from(map['categories'] ?? []),
      posterPaths: (map['posters'] as List<dynamic>? ?? [])
          .map((p) => p['path'] as String)
          .toList(),
      trailerPaths: (map['trailers'] as List<dynamic>? ?? [])
          .map((t) => t['path'] as String)
          .toList(),
    );
  }
}
