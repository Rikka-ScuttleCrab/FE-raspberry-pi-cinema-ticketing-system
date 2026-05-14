import 'package:flutter/material.dart';
import '../repositories/payment_respository.dart';

class PaymentController extends ChangeNotifier {
  final PaymentRepository _repo = PaymentRepository();

  bool isLoading = false;
  String? errorMessage;
  bool isSuccess = false;

  Future<String?> postPayment(
      int amount,
      int orderId, {
        required Function(String url) onSuccess,
        required Function(String error) onError,
      }) async {
    isLoading = true;
    isSuccess = false;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _repo.postPayment(amount, orderId);

      isSuccess = true;
      onSuccess(result);

      return result;
    } catch (e) {
      errorMessage = e.toString();
      onError(errorMessage!);

      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkPaymentStatus(
      int orderId, {
        required Function(String status) onResult,
        required Function(String error) onError,
      }) async {
    try {
      final status = await _repo.getPaymentStatus(orderId);
      onResult(status);
    } catch (e) {
      onError(e.toString());
    }
  }
}