import '../failure.dart';
import '../services/otp_service.dart';

class OTPRepository {
  final OTPService _service = OTPService();

  Future<void> sendEmailOTP(String email) async {
    try {
      final response = await _service.sendGmailOTP(email);

      if (response.statusCode != 200) {
        throw ServerFailure(
          "Server error ${response.statusCode}: ${response.body}",
        );
      }
    } catch (e) {
      throw NetworkFailure(
        "Không thể gửi OTP email: $e",
      );
    }
  }

  Future<bool> verifyEmailOTP(String email, String OTPCode) async {
    final response = await _service.verifyEmailOTP(email, OTPCode);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
