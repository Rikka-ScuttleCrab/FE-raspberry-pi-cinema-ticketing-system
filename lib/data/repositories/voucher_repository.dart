import 'dart:async';
import 'dart:convert';

import '../failure.dart';
import '../models/voucher.dart';
import '../services/voucher_service.dart';

class VoucherRepository {
  final VoucherService _service = VoucherService();

  Future<Voucher> fetchVoucherDetail(String voucherCode) async {
    try {
      final response = await _service.getVoucherData(voucherCode);

      switch (response.statusCode) {

        // SUCCESS
        case 200:
          final Map<String, dynamic> jsonResponse = jsonDecode(
            utf8.decode(response.bodyBytes),
          );

          final voucherData = jsonResponse['data'];

          return Voucher.fromMap(voucherData);

        // NOT FOUND
        case 404:
          throw const ServerFailure(
            "Voucher không tồn tại",
          );

        // UNAUTHORIZED
        case 401:
          throw const ServerFailure(
            "Bạn chưa được xác thực",
          );

        // INTERNAL SERVER ERROR
        case 500:
          throw const ServerFailure(
            "Lỗi server nội bộ",
          );

        // OTHER STATUS
        default:
          throw ServerFailure(
            "Lỗi server: ${response.statusCode}",
          );
      }
    }

    // Giữ nguyên lỗi server
    on ServerFailure {
      rethrow;
    }

    // Timeout
    on TimeoutException {
      throw const NetworkFailure(
        "Kết nối tới máy chủ bị timeout",
      );
    }

    // JSON parse lỗi
    on FormatException {
      throw const UnknownFailure(
        "Dữ liệu trả về không hợp lệ",
      );
    }

    // Các lỗi khác
    catch (e) {
      throw NetworkFailure(
        "Không thể kết nối đến máy chủ: $e",
      );
    }
  }
}