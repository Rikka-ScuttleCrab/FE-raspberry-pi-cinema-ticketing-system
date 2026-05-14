import 'package:flutter/material.dart';

class StepOTP extends StatefulWidget {
  final TextEditingController otpCtrl;
  final VoidCallback onResend;
  final int countdown;

  const StepOTP({
    super.key,
    required this.otpCtrl,
    required this.onResend,
    required this.countdown,
  });

  @override
  State<StepOTP> createState() => _StepOTPState();
}

class _StepOTPState extends State<StepOTP> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());

  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers)
      c.dispose();
    for (var f in _focusNodes)
      f.dispose();
    super.dispose();
  }

  void _updateOTP() {
    widget.otpCtrl.text =
        _controllers.map((c) => c.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "NHẬP MÃ OTP",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text(
            "Vui lòng nhập mã 6 số đã được gửi",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 45,
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),

                  decoration: InputDecoration(
                    counterText: "",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                      BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                      const BorderSide(color: Colors.orange, width: 2),
                    ),
                  ),

                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      /// nhập → sang ô tiếp
                      if (index < 5) {
                        _focusNodes[index + 1].requestFocus();
                      }
                    }
                    _updateOTP();
                  },

                  onSubmitted: (_) => _updateOTP(),

                  /// 🔥 FIX BACKSPACE
                  onTap: () {
                    _controllers[index].selection =
                        TextSelection.fromPosition(
                          TextPosition(offset: _controllers[index].text.length),
                        );
                  },
                ),
              );
            }),
          ),

          const SizedBox(height: 30),

          TextButton(
            onPressed: widget.countdown > 0 ? null : widget.onResend,
            child: Text(
              widget.countdown > 0
                  ? "Gửi lại sau ${widget.countdown}s"
                  : "Gửi lại mã OTP",
              style: TextStyle(
                color:
                widget.countdown > 0 ? Colors.grey : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}