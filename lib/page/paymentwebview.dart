import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;

  const PaymentWebView({super.key, required this.paymentUrl});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('/api/v1/payments/return')) {
              final uri = Uri.parse(request.url);
              final isSuccess = uri.queryParameters['vnp_ResponseCode'] == '00';
              final message = isSuccess ? 'Thanh toán VNPay thành công' : 'Thanh toán VNPay thất bại';

              Future.microtask(() {
                if (mounted) {
                  Navigator.of(context).pop({'success': isSuccess, 'message': message, 'params': uri.queryParameters});
                }
              });
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },          onPageStarted: (String url) => setState(() => _isLoading = true),
          onPageFinished: (String url) => setState(() => _isLoading = false),
          onWebResourceError: (WebResourceError error) {
            debugPrint("Lỗi WebView: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("THANH TOÁN VNPAY"),
        backgroundColor: const Color(0xFF005BAA), // Màu đặc trưng VNPay
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.orange)),
        ],
      ),
    );
  }
}