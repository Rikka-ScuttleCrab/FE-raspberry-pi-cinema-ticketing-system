import 'package:flutter/material.dart';
import 'page/welcome.dart';
import 'controller/timeout.dart';
void main() {
  runApp(const MovieKioskApp());
}

class MovieKioskApp extends StatelessWidget {
  const MovieKioskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SessionTimeoutListener(
      timeout: const Duration(minutes: 5),
      onTimeout: () {
        final context = navigatorKey.currentContext;
        if (context != null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const WelcomePage()),
            (route) => false,
          );
        }
      },
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Galaxy Cinema Kiosk',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        ),
        home: const WelcomePage(),
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();