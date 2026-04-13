import 'package:network_info_plus/network_info_plus.dart';

class AppConfig {
  static String _uri = "http://10.0.2.2:8080";

  static Future<void> init() async {
    final info = NetworkInfo();
    String? ip = await info.getWifiIP();

    if (ip == null) return;

    String subnet = ip.substring(0, ip.lastIndexOf('.') + 1);

    _uri = "http://${subnet}3:8080";
  }

  static String get baseUrl => _uri;
}