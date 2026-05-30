import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/controllers/movie_controller.dart';
import 'listMovies.dart';

class WelcomePage extends StatefulWidget {

  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _reloadMovies();
  });

  _timer = Timer.periodic(
    const Duration(seconds: 3),
    (timer) {
      final movies =
          Provider.of<MovieController>(
            context,
            listen: false,
          ).movies;

      if (movies.isEmpty) return;

      _currentPage =
          (_currentPage + 1) %
          movies.length;

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(
            milliseconds: 800,
          ),
          curve: Curves.easeInOut,
        );
      }
    },
  );
}

  Future<void> _reloadMovies() async {

    final movieCtrl =
        Provider.of<MovieController>(
      context,
      listen: false,
    );

    await movieCtrl.fetchMovies();

    debugPrint("REFRESH MOVIES");
  }
  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      final movies =
      context.watch<MovieController>().movies;


    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const MovieListScreen(),
            ),
          );

          await _reloadMovies();
        },
        child: Stack(
          children: [
            if (movies.isEmpty)
              const Center(child: Text("Không có phim"))
            else
              PageView.builder(
                controller: _pageController,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    movies[index].posterPaths.isNotEmpty
                        ? movies[index].posterPaths[0]
                        : 'https://4kwallpapers.com/images/wallpapers/404-not-found-cute-2048x2048-18164.jpg',
                    fit: BoxFit.fill,
                  );
                },
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Opacity(
                    opacity: 0.4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "CHẠM ĐỂ MUA VÉ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}