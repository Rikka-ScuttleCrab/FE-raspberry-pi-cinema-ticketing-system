import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../data/controllers/payment_controller.dart';
import '../page/ticketPrint.dart';

class PaymentWebView extends StatefulWidget {
  final int orderId;
  final int amount;

  const PaymentWebView({
    super.key,
    required this.orderId,
    required this.amount,
  });

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  InAppWebViewController? webViewController;

  bool isLoading = true;
  String? paymentUrl;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final paymentCtrl =
      Provider.of<PaymentController>(context, listen: false);
      _startCheckingStatus();
      paymentCtrl.postPayment(
        widget.amount,
        widget.orderId,
        onSuccess: (url) {
          setState(() {
            paymentUrl = url;
          });

          webViewController?.loadUrl(
            urlRequest: URLRequest(url: WebUri(url)),
          );
        },
        onError: (err) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err), backgroundColor: Colors.red),
          );
        },
      );
    });
  }
  void _startCheckingStatus() {
    final paymentCtrl =
    Provider.of<PaymentController>(context, listen: false);

    int retry = 0;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2));

      paymentCtrl.checkPaymentStatus(
        widget.orderId,
        onResult: (status) {
          debugPrint("PAYMENT STATUS: $status");

          if (status == "PAID") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    TicketPrintingScreen(orderId: widget.orderId),
              ),
            );
          }
        },
        onError: (err) {
          debugPrint("STATUS ERROR: $err");
        },
      );

      retry++;
      return retry < 50; // tối đa ~20s
    });
  }
  @override
  Widget build(BuildContext context) {
    // final paymentCtrl = Provider.of<PaymentController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("THANH TOÁN"),
        backgroundColor: const Color(0xFF005BAA),
      ),
      body: Stack(
        children: [
          if (paymentUrl != null)
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(paymentUrl!),
              ),

              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  useShouldOverrideUrlLoading: true,
                  mediaPlaybackRequiresUserGesture: false,
                ),
              ),

              onWebViewCreated: (controller) {
                webViewController = controller;
              },

              onLoadStart: (controller, url) {
                setState(() {
                  isLoading = true;
                });
              },

              onLoadStop: (controller, url) async {
                setState(() {
                  isLoading = false;
                });

                // 👉 detect callback success (tuỳ backend PayOS)
                if (url != null && url.toString().contains("success")) {
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TicketPrintingScreen(orderId: widget.orderId),
                      ),
                    );
                  }
                }
              },

              onLoadError: (controller, url, code, message) {
                debugPrint("Load error: $message");
              },

              shouldOverrideUrlLoading:
                  (controller, navigationAction) async {
                final uri = navigationAction.request.url;

                if (uri != null) {
                  debugPrint("Navigating: $uri");
                }

                return NavigationActionPolicy.ALLOW;
              },
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),

          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
        ],
      ),
    );
  }
}