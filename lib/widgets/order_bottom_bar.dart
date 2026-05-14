import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/controllers/otp_controller.dart';
import '../utils/order_helper.dart';
import '../data/models/ticket_type.dart';
import '../data/models/voucher.dart';

class OrderBottomBar extends StatelessWidget {
  final int currentStep;
  final TicketType? ticket;
  final List<String> seats;
  final Voucher? voucher;
  final VoidCallback onContinue;

  const OrderBottomBar({
    super.key,
    required this.currentStep,
    required this.ticket,
    required this.seats,
    required this.voucher,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    if (currentStep < 2) return const SizedBox.shrink();

    final otpCtrl = Provider.of<OTPController>(context);

    double subTotal = (ticket?.price ?? 0) * seats.length;

    double discount = voucher != null
        ? OrderHelper.calculateDiscount(subTotal, voucher!.value)
        : 0;

    double total = subTotal - discount;

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${total.toInt()} VNĐ",
            style: const TextStyle(
              fontSize: 20,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: (currentStep == 3 &&
                (otpCtrl.isSending || otpCtrl.resendSeconds > 0))
                ? null
                : onContinue,
            child: Text(
              currentStep == 4
                  ? "THANH TOÁN"
                  : (currentStep == 3 ? "GỬI OTP" : "TIẾP THEO"),
            ),
          ),
        ],
      ),
    );
  }
}