import '../enums/otp_type.dart';

class OTPHelper {
  static OTPType detectType(String input) {
    if (input.contains('@')) return OTPType.email;
    return OTPType.sms;
  }

  static String formatPhone(String phone) {
    if (phone.startsWith('+')) return phone;

    return '+84' + phone.replaceFirst(RegExp(r'^0+'), '');
  }
}