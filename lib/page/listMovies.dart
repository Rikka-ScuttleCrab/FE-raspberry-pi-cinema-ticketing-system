import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/controllers/movie_controller.dart';
import '../page/movieDetail.dart';
import '../page/order.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  int? selectedmovieId;

  @override
  Widget build(BuildContext context) {
    final movieController = context.watch<MovieController>();
    final movies = movieController.movies;

    if (movieController.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (movieController.errorMessage != null) {
      return Scaffold(body: Center(child: Text(movieController.errorMessage!)));
    }

    if (movies.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Không có phim để hiển thị")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CHỌN PHIM",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          final isSelected = selectedmovieId == movie.id;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedmovieId = isSelected ? null : movie.id;
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    movie.posterPaths.isNotEmpty
                        ? movie.posterPaths[0]
                        : 'https://4kwallpapers.com/images/wallpapers/404-not-found-cute-2048x2048-18164.jpg',
                    fit: BoxFit.cover,
                  ),
                  if (isSelected)
                    Container(
                      color: Colors.black.withOpacity(0.7),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildOverlayButton(
                            icon: Icons.info_outline,
                            label: "CHI TIẾT",
                            color: Colors.blue,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      MovieDetailScreen(movie: movie),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          _buildOverlayButton(
                            icon: Icons.confirmation_num_outlined,
                            label: "MUA VÉ",
                            color: Colors.orange,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderScreen(movie: movie),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  if (!isSelected)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.black54,
                        child: Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverlayButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Column(
          children: [
            Icon(icon, size: 20),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
