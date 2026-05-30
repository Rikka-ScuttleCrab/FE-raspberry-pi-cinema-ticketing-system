import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/controllers/ticket_controller.dart';
import './welcome.dart';
class TicketPrintingScreen extends StatefulWidget {

  final int orderId;

  const TicketPrintingScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<TicketPrintingScreen> createState() =>
      _TicketPrintingScreenState();
}

class _TicketPrintingScreenState
    extends State<TicketPrintingScreen> {

  bool isLoading = true;

  String message =
      "ĐANG GỬI VÉ ĐIỆN TỬ...";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      _sendTicket();
    });
  }

  Future<void> _sendTicket() async {

    final ticketCtrl =
        Provider.of<TicketController>(
      context,
      listen: false,
    );

    final success =
        await ticketCtrl.sendQr(
      widget.orderId,
    );

    if (!mounted) return;

    setState(() {

      isLoading = false;

      message = success

          ? "MÃ QR VÉ ĐÃ ĐƯỢC\nGỬI VỀ EMAIL"

          : "GỬI VÉ THẤT BẠI";
    });

    await Future.delayed(
      const Duration(seconds: 10),
    );

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(

        builder: (_) => const WelcomePage(),
      ),

      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      body: Center(

        child: Padding(

          padding: const EdgeInsets.all(24),

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              if (isLoading)
                const CircularProgressIndicator(
                  color: Colors.orange,
                )

              else
                Icon(

                  message.contains("THẤT BẠI")
                      ? Icons.cancel
                      : Icons.check_circle,

                  color: message.contains("THẤT BẠI")
                      ? Colors.red
                      : Colors.green,

                  size: 120,
                ),

              const SizedBox(height: 30),

              Text(

                message,

                textAlign: TextAlign.center,

                style: TextStyle(

                  color: message.contains("THẤT BẠI")
                      ? Colors.red
                      : Colors.green,

                  fontSize: 28,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              if (!isLoading)
                const Text(

                  "Đang trở về màn hình chính...",

                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}