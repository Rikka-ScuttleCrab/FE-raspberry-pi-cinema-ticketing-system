import 'package:flutter/material.dart';
import '../repositories/order_respository.dart';
import '../models/order_session.dart';
import '../models/order_detail.dart';
import '../failure.dart';

class OrderController extends ChangeNotifier {
  final OrderRepository _repo = OrderRepository();

  bool isLoading = false;
  String? errorMessage;
  bool isSuccess = false;
  OrderDetail? order;

  Future<void> postOrder(
      OrderSession order, {
        required Function(OrderSession) onSuccess,
        required Function(String) onError,
      }) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await _repo.postOrder(order);

      onSuccess(result);
    } catch (e) {
      onError(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getOrder(
    int orderId,
  ) async {

    isLoading = true;

    errorMessage = null;

    order = null;

    notifyListeners();

    try {

      final result = await _repo.getOrderData(
        orderId,
      );

      order = result;

    }

    on Failure catch (e) {

      errorMessage = e.message;

    }

    catch (e) {

      errorMessage = e.toString();

    }

    finally {

      isLoading = false;

      notifyListeners();

    }
  }
}