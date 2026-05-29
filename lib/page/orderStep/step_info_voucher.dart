import 'package:flutter/material.dart';
import '../../data/controllers/voucher_controller.dart';
import 'package:provider/provider.dart';

class StepInfoVoucher extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController contactCtrl;
  final TextEditingController voucherCtrl;
  final VoidCallback onApply;
  final VoidCallback onRemove;
  final dynamic appliedVoucher;

  /// 🔥 NEW DATA
  final String movieTitle;
  final String ticketTypeName;
  final String showtime;
  final String theaterName;
  final List<String> seats;

  const StepInfoVoucher({
    super.key,
    required this.nameCtrl,
    required this.contactCtrl,
    required this.voucherCtrl,
    required this.onApply,
    required this.onRemove,
    required this.appliedVoucher,
    required this.movieTitle,
    required this.ticketTypeName,
    required this.showtime,
    required this.theaterName,
    required this.seats,
  });


  
  bool _isValidEmail(String email) {
    return RegExp(
      r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
    ).hasMatch(email);
  }

  
  @override
  Widget build(BuildContext context) {
    final voucherCtrlProvider = context.watch<VoucherController>();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// INFO
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(
              labelText: "Họ tên",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: contactCtrl,

            keyboardType: TextInputType.emailAddress,

            decoration: InputDecoration(
              labelText: "Email",
              border: const OutlineInputBorder(),

              errorText: contactCtrl.text.isEmpty
                  ? null
                  : _isValidEmail(contactCtrl.text)
                  ? null
                  : "Email không hợp lệ",
            ),

            onChanged: (_) {
              (context as Element).markNeedsBuild();
            },
          ),

          const SizedBox(height: 30),

          /// VOUCHER TITLE
          const Text(
            "VOUCHER GIẢM GIÁ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          /// INPUT + BUTTON
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: voucherCtrl,
                  enabled: appliedVoucher == null, // ❗ khóa nếu đã apply
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Nhập mã voucher",
                  ),
                ),
              ),
              const SizedBox(width: 10),

              /// LOADING
              if (voucherCtrlProvider.isLoading)
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )

              /// APPLY
              else if (appliedVoucher == null)
                ElevatedButton(
                  onPressed: onApply,
                  child: const Text("ÁP DỤNG"),
                )

              /// REMOVE
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: onRemove,
                  child: const Text("HUỶ"),
                ),
            ],
          ),

          const SizedBox(height: 10),

          /// RESULT MESSAGE
          if (appliedVoucher != null)
            Text(
              "Đã áp dụng voucher (-${appliedVoucher.value})",
              style: const TextStyle(color: Colors.green),
            )
          else if (voucherCtrlProvider.errorMessage != null)
            Text(
              voucherCtrlProvider.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          const SizedBox(height: 30),

          const Text(
            "THÔNG TIN VÉ ĐANG CHỌN",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row("Tên Phim", movieTitle),
                _row("Loại vé", ticketTypeName),
                _row("Giờ chiếu", showtime),
                _row("Phòng", theaterName),
                _row("Ghế", seats.join(", ")),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              "$label:",
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20
              ),
            ),
          ),
          Expanded(child: Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20
              )
            )
          ),
        ],
      ),
    );
  }
}