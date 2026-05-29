import 'package:demo/data/controllers/ticket_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/order_helper.dart';
import '../utils/otp_helper.dart';
import '../widgets/order_bottom_bar.dart';

import '../data/models/movie.dart';
import '../data/models/ticket_type.dart';
import '../data/models/showtime.dart';
import '../data/models/theaterroom.dart';
import '../data/models/voucher.dart';
import '../data/models/order_session.dart';

import 'orderStep/order_step.dart';
import 'payment_web_view.dart';
import 'ticketPrint.dart';

import '../data/controllers/showtime_controller.dart';
import '../data/controllers/theater_room_controller.dart';
import '../data/controllers/otp_controller.dart';
import '../data/controllers/voucher_controller.dart';
import '../data/controllers/order_controller.dart';
import '../data/controllers/payment_controller.dart';
import '../data/controllers/ticket_controller.dart';

import '../enums/otp_type.dart';

class OrderScreen extends StatefulWidget {
  final Movie movie;
  const OrderScreen({super.key, required this.movie});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int currentStep = 0;
  TicketType? selectedTicket;
  Showtime? selectedShowtime;
  List<String> selectedSeats = [];
  Voucher? appliedVoucher;
  bool _isVerifyingOTP = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController voucherController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final ShowtimeController _showtimeController = ShowtimeController();
  final TheaterRoomController _theaterRoomController = TheaterRoomController();
  final OrderController orderCtrl = OrderController();

  @override
  void initState() {
    super.initState();

    _showtimeController.fetchShowtimes(widget.movie.id);

    _showtimeController.addListener(_onDataChanged);
    _theaterRoomController.addListener(() => setState(() {}));
    otpController.addListener(_onOtpChanged);
  }

  void _onOtpChanged() {
    if (otpController.text.length == 6 && !_isVerifyingOTP) {
      _isVerifyingOTP = true;

      _handleContinue();
    }
  }

  void _onDataChanged() {
    setState(() {});
    _onDataLoaded();
  }

  void _onDataLoaded() {
    if (!_showtimeController.isLoading &&
        _showtimeController.showtimes.isNotEmpty) {
      final unique = {
        for (var st in _showtimeController.showtimes)
          st.ticket_type.id: st.ticket_type,
      };

      if (unique.length == 1) {
        selectedTicket = unique.values.first;
        currentStep = 1;
      }
    }
  }

  OrderSession _buildOrder() {
    return OrderHelper.buildOrder(
      showtimeId: selectedShowtime!.id,
      name: nameController.text,
      contact: contactController.text,
      seats: selectedSeats,
      voucherId: appliedVoucher?.id,
      ticketPrice: selectedTicket?.price ?? 0,
      voucherValue: appliedVoucher?.value,
    );
  }

  OTPType _detectOTPType(String input) {
    return OTPHelper.detectType(input);
  }

  void _createOrderAndPay() {
    final order = _buildOrder();

    orderCtrl.postOrder(
      order,
      onSuccess: (orderRes) {
        _showSnackBar("Tạo đơn thành công!", Colors.green);

        final orderId = orderRes.id;
        final amount = orderRes.total_amount;

        if (orderId == null || amount == null) {
          _showSnackBar("Lỗi dữ liệu thanh toán!", Colors.red);
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => PaymentController()),
                ChangeNotifierProvider(create: (_) => TicketController()),
                ChangeNotifierProvider(create: (_) => OrderController()),
              ],
              child: PaymentWebView(
                orderId: orderId,
                amount: amount,
              ),
            ),
          ),
          // MaterialPageRoute(
          //   builder: (_) => MultiProvider(
          //     providers: [
          //       ChangeNotifierProvider(create: (_) => PaymentController()),
          //       ChangeNotifierProvider(create: (_) => TicketController()),
          //       ChangeNotifierProvider(create: (_) => OrderController()),
          //     ],
          //     child: TicketPrintingScreen(orderId: orderId),
          //   ),
          // ),
        );
      },
      onError: (err) {
        _showSnackBar(err, Colors.red);
      },
    );
  }

  @override
  void dispose() {
    _showtimeController.removeListener(_onDataChanged);
    _showtimeController.dispose();
    _theaterRoomController.dispose();

    nameController.dispose();
    contactController.dispose();
    voucherController.dispose();
    otpController.dispose();

    super.dispose();
  }

  // --- LOGIC ---

  void _onShowtimeSelected(Showtime st) {
    setState(() {
      selectedShowtime = st;
      selectedSeats.clear();
      currentStep = 2;
    });

    _theaterRoomController.fetchSeats(st.theater_room_id, st.theater_room_name);
  }

  Future<void> _applyVoucher() async {
    final voucherCtrl = Provider.of<VoucherController>(context, listen: false);

    final code = voucherController.text.trim();

    if (code.isEmpty) {
      _showSnackBar("Nhập mã voucher", Colors.orange);
      return;
    }

    await voucherCtrl.fetchVoucher(code);

    if (voucherCtrl.voucher != null) {
      setState(() => appliedVoucher = voucherCtrl.voucher);
      _showSnackBar("Áp dụng thành công!", Colors.green);
    } else {
      _showSnackBar(voucherCtrl.errorMessage ?? "Lỗi voucher", Colors.red);
    }
  }

  void _removeVoucher() {
    setState(() {
      appliedVoucher = null;
      voucherController.clear();
    });

    _showSnackBar("Đã huỷ voucher", Colors.grey);
  }

  Future<void> _handleContinue() async {
    if (currentStep == 1 && selectedShowtime == null) {
      _showSnackBar("Vui lòng chọn khung giờ!", Colors.orange);
      return;
    }

    if (currentStep == 2 && selectedSeats.isEmpty) {
      _showSnackBar("Vui lòng chọn ít nhất 1 ghế!", Colors.orange);
      return;
    }

    if (currentStep == 3) {
      if (nameController.text.isEmpty || contactController.text.isEmpty) {
        _showSnackBar("Vui lòng nhập đủ thông tin!", Colors.orange);
        return;
      }

      final otpCtrl = Provider.of<OTPController>(context, listen: false);
      final email = contactController.text.trim();

      final isValidEmail = RegExp(
        r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
      ).hasMatch(email);

      if (!isValidEmail) {
        _showSnackBar(
          "Email không hợp lệ",
          Colors.red,
        );
        return;
      }

      await otpCtrl.sendOTP(
          email,
          OTPType.email,
        (err) => _showSnackBar(err, Colors.red),
        () {
          _showSnackBar("Đã gửi mã OTP!", Colors.green);
          setState(() => currentStep = 4);
        },
      );
      return;
    }

    if (currentStep == 4) {
      if (otpController.text.length < 6) return;

      final otpCtrl = Provider.of<OTPController>(context, listen: false);

      final contact = contactController.text.trim();

      void onDone() {
        _isVerifyingOTP = false;
        _createOrderAndPay();
      }

      void onError(String err) {
        _isVerifyingOTP = false;
        _showSnackBar(err, Colors.red);

        otpController.clear();
      }

        otpCtrl.verifyEmailOTP(contact, otpController.text, onError, onDone);
      return;
    }

    setState(() => currentStep++);
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title, style: const TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: _showtimeController.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : _showtimeController.errorMessage != null
          ? Center(child: Text(_showtimeController.errorMessage!))
          : _buildStepContent(),
      bottomNavigationBar: OrderBottomBar(
        currentStep: currentStep,
        ticket: selectedTicket,
        seats: selectedSeats,
        voucher: appliedVoucher,
        onContinue: _handleContinue,
      ),
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        final unique = {
          for (var st in _showtimeController.showtimes)
            st.ticket_type.id: st.ticket_type,
        }.values.toList();

        return StepTicketType(
          ticketTypes: unique,
          onSelect: (t) {
            setState(() {
              selectedTicket = t;
              currentStep = 1;
            });
          },
        );

      case 1:
        return StepShowtime(
          showtimes: _showtimeController.showtimes
              .where((st) => st.ticket_type.id == selectedTicket?.id)
              .toList(),
          selected: selectedShowtime,
          onSelect: _onShowtimeSelected,
        );

      case 2:
        final room = _theaterRoomController.theaterrooms.firstWhere(
          (r) => r.id == selectedShowtime?.theater_room_id,
          orElse: () => TheaterRoom(id: 0, theaterName: '', seats: []),
        );

        return StepSeat(
          seats: room.seats,
          selectedSeats: selectedSeats,
          bookedSeats: selectedShowtime?.book_seats ?? [],
          theaterName: room.theaterName,
          isLoading: _theaterRoomController.isLoading,
          error: _theaterRoomController.errorMessage,
          onToggle: (seat) {
            setState(() {
              selectedSeats.contains(seat)
                  ? selectedSeats.remove(seat)
                  : selectedSeats.add(seat);
            });
          },
        );

      case 3:
        return StepInfoVoucher(
          nameCtrl: nameController,
          contactCtrl: contactController,
          voucherCtrl: voucherController,
          onApply: _applyVoucher,
          onRemove: _removeVoucher,
          appliedVoucher: appliedVoucher,
          movieTitle: widget.movie.title,
          ticketTypeName: selectedTicket?.name ?? "",
          showtime: selectedShowtime?.starttime ?? "",
          theaterName: selectedShowtime?.theater_room_name ?? "",
          seats: selectedSeats,
        );

      case 4:
        final otpCtrl = Provider.of<OTPController>(context);

        return StepOTP(
          otpCtrl: otpController,
          countdown: otpCtrl.resendSeconds,
          onResend: () {
            final type = _detectOTPType(contactController.text.trim());
            otpCtrl.sendOTP(contactController.text, type, (_) {}, () {});
          },
        );

      default:
        return const SizedBox();
    }
  }
}
