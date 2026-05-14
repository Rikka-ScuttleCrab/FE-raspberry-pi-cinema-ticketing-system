import 'package:http/http.dart' as http;
import '../../global_variables.dart';

class VoucherService {
  Future<http.Response> getVoucherData(String voucherCode) async {
    final url = Uri.parse("$uri/api/v1/vouchers/validate")
        .replace(queryParameters: {
      "voucher_code": voucherCode,
    });

    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));
  }
}