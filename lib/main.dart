import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'page/welcome.dart';
import 'data/controllers/movie_controller.dart';
import 'data/controllers/otp_controller.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MovieController()..initData(),
        ),
        ChangeNotifierProvider(
          create: (_) => OTPController(),
        ),
      ],
      child: const MovieKioskApp(),
    ),
  );
}

class MovieKioskApp extends StatelessWidget {
  const MovieKioskApp({super.key});

  @override
  Widget build(BuildContext context) {
    final movieController = Provider.of<MovieController>(context, listen: true);

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Galaxy Cinema Kiosk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      ),
      home: movieController.isLoading
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : movieController.errorMessage != null
              ? Scaffold(
                  body: Center(child: Text(movieController.errorMessage!)),
                )
              : WelcomePage(movies: movieController.movies),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();