import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/otp_respository.dart';
import '../../enums/otp_type.dart';

class OTPController extends ChangeNotifier {
  String? verificationId;
  bool isSending = false;
  bool isVerifying = false;
  int resendSeconds = 0;
  Timer? _timer;
  final OTPRepository _repo = OTPRepository();

  // 📤 SEND OTP (AUTO detect)
  Future<void> sendOTP(
      String input,
      OTPType type,
      Function(String) onError,
      Function() onSuccess,
      ) async {
    isSending = true;
    notifyListeners();

    try {
      if (type == OTPType.sms) {
        await _sendSMSOTP(input, onError, onSuccess);
      } else {
        await _sendEmailOTP(input, onError, onSuccess);
      }
      _startCountdown();
    } catch (e) {
      onError(e.toString());
    }

    isSending = false;
    notifyListeners();
  }

  // 📧 EMAIL OTP
  Future<void> _sendEmailOTP(
      String email,
      Function(String) onError,
      Function() onSuccess,
      ) async {
    try {
      await _repo.sendEmailOTP(email);
      onSuccess();
    } catch (e) {
      onError("Gửi OTP email thất bại: $e");
    }
  }

  // 📱 SMS OTP (Firebase)
  Future<void> _sendSMSOTP(
      String phone,
      Function(String) onError,
      Function() onSuccess,
      ) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,

      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        onSuccess();
      },

      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? "Send OTP failed");
      },

      codeSent: (String verId, int? resendToken) {
        verificationId = verId;
        onSuccess();
      },

      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  // 📥 VERIFY OTP (SMS only)
  Future<void> verifyOTP(
      String otp,
      Function(String) onError,
      Function() onSuccess,
      ) async {
    if (verificationId == null) {
      onError("Chưa gửi OTP SMS");
      return;
    }

    isVerifying = true;
    notifyListeners();

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      onSuccess();
    } catch (e) {
      onError("OTP không đúng!");
    }

    isVerifying = false;
    notifyListeners();
  }

  // 📥 Verify OTP
  Future<void> verifyEmailOTP(
      String email,
      String OTPCode,
      Function(String) onError,
      Function() onSuccess,
      ) async {
    try {
      final isValid = await _repo.verifyEmailOTP(email, OTPCode);

      if (isValid) {
        onSuccess();
      } else {
        onError("OTP không đúng!");
      }
    } catch (e) {
      onError("Xác thực OTP email thất bại: $e");
    }
  }

  // ⏱️ Countdown
  void _startCountdown() {
    resendSeconds = 30;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds == 0) {
        timer.cancel();
      } else {
        resendSeconds--;
        notifyListeners();
      }
    });
  }
}