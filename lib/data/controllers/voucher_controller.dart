import 'package:demo/data/models/voucher.dart';
import 'package:flutter/material.dart';
import '../repositories/voucher_repository.dart';
import '../failure.dart';
import 'error.dart';


class VoucherController extends ChangeNotifier {
  final VoucherRepository _repository = VoucherRepository();

  Voucher? _voucher;
  bool _isLoading = false;
  Failure? _failure;

  Voucher? get voucher => _voucher;
  bool get isLoading => _isLoading;
  String? get errorMessage => _failure?.message;

  Future<void> fetchVoucher(String code) async {
    _isLoading = true;
    _failure = null;
    _voucher = null;
    notifyListeners();

    try {
      final res = await _repository.fetchVoucherDetail(code);
      _voucher = res;
    } catch (e) {
      _failure = ErrorHandler.handle(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}