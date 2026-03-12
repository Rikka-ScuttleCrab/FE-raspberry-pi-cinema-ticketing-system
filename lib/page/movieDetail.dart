import 'package:flutter/material.dart';
import '../models/film.dart';
import '../page/booking.dart';

class MovieDetailScreen extends StatelessWidget {
  final Film film;
  const MovieDetailScreen({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(film.posterImageURL, height: 500, width: double.infinity, fit: BoxFit.fill),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(film.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 18, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(film.duration, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 20),
                      const Icon(Icons.movie, size: 18, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(film.categories.map((e) => e.name).join(', '), style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Nội dung phim", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(film.description, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.white70)),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        // Chuyển sang trang đặt vé
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (_) => BookingScreen(film: film))
                        );
                      },
                      child: const Text("MUA VÉ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}