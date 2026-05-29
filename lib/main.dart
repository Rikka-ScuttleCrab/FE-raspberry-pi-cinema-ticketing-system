import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'page/welcome.dart';
import 'firebase_options.dart';
import 'data/controllers/movie_controller.dart';
import 'data/controllers/otp_controller.dart';
import 'data/controllers/voucher_controller.dart';
import 'data/controllers/recommendation_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 4. Khởi tạo Firebase chính thức
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieController()..initData()),
        ChangeNotifierProvider(create: (_) => RecommendationController()),
        ChangeNotifierProvider(create: (_) => OTPController()),
        ChangeNotifierProvider(create: (_) => VoucherController()),
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
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : movieController.errorMessage != null
          ? Scaffold(body: Center(child: Text(movieController.errorMessage!)))
          : WelcomePage(movies: movieController.movies),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
