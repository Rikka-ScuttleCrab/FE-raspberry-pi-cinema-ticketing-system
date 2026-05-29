import 'package:flutter/material.dart';
import '../models/ticket.dart';
import '../repositories/ticket_repository.dart';
import '../failure.dart';
import 'error.dart';

class TicketController extends ChangeNotifier {
  final TicketRepository _repository = TicketRepository();

  bool _isLoading = false;
  Failure? _failure;

  bool get isLoading => _isLoading;
  String? get errorMessage => _failure?.message;

  Future<List<Ticket>> fetchTickets(int orderId) async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    try {
      final result = await _repository.fetchTickets(orderId);
      return result;
    } catch (e) {
      _failure = ErrorHandler.handle(e);
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendQr(int orderId) async {

    return await _repository.sendQr(orderId);
  }

  
}