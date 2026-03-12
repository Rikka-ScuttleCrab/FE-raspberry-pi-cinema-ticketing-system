import 'package:flutter/material.dart';
import '../data/mockdata.dart';
import '../page/movieDetail.dart';
import '../page/booking.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  int? selectedFilmId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CHỌN PHIM", style: TextStyle(fontWeight: FontWeight.bold)),
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
        itemCount: mockFilms.length,
        itemBuilder: (context, index) {
          final film = mockFilms[index];
          final isSelected = selectedFilmId == film.id;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilmId = isSelected ? null : film.id;
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(film.posterImageURL, fit: BoxFit.cover),

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
                                MaterialPageRoute(builder: (_) => MovieDetailScreen(film: film)),
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
                                MaterialPageRoute(builder: (_) => BookingScreen(film: film))
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
                          film.name,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}