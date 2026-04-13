import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/movie.dart';
import '../data/models/ticket_type.dart';
import '../data/models/showtime.dart';
import '../data/models/theaterroom.dart';
import '../data/models/seat.dart';

import '../data/controllers/showtime_controller.dart';
import '../data/controllers/theater_room_controller.dart';
import '../data/controllers/otp_controller.dart';

import '../enums/otp_type.dart';
import 'payment_web_view.dart';



class BookingScreen extends StatefulWidget {
  final Movie movie;
  const BookingScreen({super.key, required this.movie});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int currentStep = 0;
  String? verificationId;
  TicketType? selectedTicket;
  Showtime? selectedShowtime;
  List<String> selectedSeats = [];

  // Controllers cho các ô nhập liệu
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController voucherController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final ShowtimeController _showtimeController = ShowtimeController();
  final TheaterRoomController _theaterRoomController = TheaterRoomController();

  double discount = 0;
  bool isVoucherApplied = false;
  final String mockOtp = "931267";

  @override
  void initState() {
    super.initState();
    _showtimeController.fetchShowtimes(widget.movie.id);

    _showtimeController.addListener(() => setState(() {}));
    _theaterRoomController.addListener(() => setState(() {}));

    _showtimeController.addListener(_onDataLoaded); // Lắng nghe sự kiện tải data
  }

  void _autoSelectTicketType() {
    if (!_showtimeController.isLoading && _showtimeController.showtimes.isNotEmpty) {
      final uniqueTypes = _showtimeController.showtimes.map((e) => e.ticket_type.id).toSet();
      if (uniqueTypes.length == 1 && selectedTicket == null) {
        setState(() {
          selectedTicket = _showtimeController.showtimes.first.ticket_type;
          currentStep = 1;
        });
      }
    }
  }
  OTPType _detectOTPType(String input) {
    if (input.contains('@')) {
      return OTPType.email;
    }
    return OTPType.sms;
  }

  void _onDataLoaded() {
    if (!_showtimeController.isLoading && _showtimeController.showtimes.isNotEmpty) {
      final uniqueTicketTypes = <int, TicketType>{};
      for (var st in _showtimeController.showtimes) {
        uniqueTicketTypes[st.ticket_type.id] = st.ticket_type;
      }

      if (uniqueTicketTypes.length == 1) {
        setState(() {
          selectedTicket = uniqueTicketTypes.values.first;
          currentStep = 1; // Bắt đầu từ bước 1
        });
      }
    }
  }

  @override
  void dispose() {
    _showtimeController.removeListener(_onDataLoaded);
    _showtimeController.dispose();
    _theaterRoomController.dispose();
    nameController.dispose();
    contactController.dispose();
    voucherController.dispose();
    otpController.dispose();
    super.dispose();
  }
  // --- LOGIC XỬ LÝ ---
  void _onShowtimeSelected(Showtime st) {
    setState(() {
      selectedShowtime = st;
      selectedSeats.clear();
      currentStep = 2;
    });
    // Gọi API lấy sơ đồ ghế dựa trên theater_room_id từ showtime
    _theaterRoomController.fetchSeats(st.theater_room_id, st.theater_room_name);
  }

  void _applyVoucher() {
    String code = voucherController.text.trim().toUpperCase();
    // double totalBefore = (selectedTicket?.price ?? 0) * selectedSeats.length;

    setState(() {
      if (code == "CATHANG4") {
        discount = 14000;
        isVoucherApplied = true;
      } else if (code == "KHACHHANGMOI") {
        discount = 50000;
        isVoucherApplied = true;
      } else {
        discount = 0;
        isVoucherApplied = false;
        _showSnackBar("Mã giảm giá không tồn tại!", Colors.redAccent);
      }
    });
    if (isVoucherApplied) _showSnackBar("Áp dụng mã thành công!", Colors.green);
  }

  void _handleContinue() async {
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
      final contact = contactController.text.trim();
      final type = _detectOTPType(contact);

      await otpCtrl.sendOTP(
        contact,
        type,
            (error) => _showSnackBar(error, Colors.red),
            () {
          _showSnackBar(
            type == OTPType.email
                ? "OTP đã gửi qua email!"
                : "OTP đã gửi qua SMS!",
            Colors.green,
          );
          setState(() => currentStep++);
        },
      );
      return;
    }

    if (currentStep == 4) {
      if (otpController.text.isEmpty) {
        _showSnackBar("Vui lòng nhập OTP!", Colors.orange);
        return;
      }

      final otpCtrl = Provider.of<OTPController>(context, listen: false);
      final contact = contactController.text.trim();
      final type = _detectOTPType(contact);

      if (type == OTPType.email) {
        await otpCtrl.verifyEmailOTP(
          contact,
          otpController.text,
              (error) => _showSnackBar(error, Colors.red),
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PaymentWebView()),
            );
          },
        );
      } else {
        await otpCtrl.verifyOTP(
          otpController.text,
              (error) => _showSnackBar(error, Colors.red),
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PaymentWebView()),
            );
          },
        );
      }
      return;
    }

    setState(() {
      currentStep++;
    });
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: color)
    );
  }

  // --- GIAO DIỆN TỪNG BƯỚC ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title, style: const TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      // Xử lý hiển thị loading và error của Controller
      body: _showtimeController.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : _showtimeController.errorMessage != null
          ? Center(child: Text(_showtimeController.errorMessage!))
          : _buildStepContent(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
  // Hàm phụ để vẽ chú thích (Ghi chú màu ghế)
  Widget _buildSeatLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendItem("Trống", Colors.grey[800]!),
          const SizedBox(width: 15),
          _legendItem("Đang chọn", Colors.orange),
          const SizedBox(width: 15),
          _legendItem("Đã đặt", Colors.red[900]!),
        ],
      ),
    );
  }

  Widget _legendItem(String text, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0: return _buildTicketTypeStep();
      case 1: return _buildShowtimeStep();
      case 2: return _buildSeatSelectionStep();
      case 3: return _buildInfoAndVoucherStep();
      case 4: return _buildOTPStep();
      default: return const SizedBox.shrink();
    }
  }

  // B0: Chọn loại vé
  Widget _buildTicketTypeStep() {
    // Lọc ra các loại vé Unique từ danh sách showtimes API trả về
    final uniqueTicketTypes = <int, TicketType>{};
    for (var st in _showtimeController.showtimes) {
      uniqueTicketTypes[st.ticket_type.id] = st.ticket_type;
    }
    final ticketTypes = uniqueTicketTypes.values.toList();

    if (ticketTypes.isEmpty) {
      return const Center(child: Text("Hôm nay chưa có suất chiếu cho phim này."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: ticketTypes.length,
      itemBuilder: (context, index) {
        final t = ticketTypes[index];
        return Card(
          color: Colors.grey[900],
          child: ListTile(
            title: Text(
              t.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${t.price.toInt()}đ"),
            onTap: () {
              setState(() {
                selectedTicket = t;
                selectedShowtime = null; // Reset giờ chiếu nếu đổi loại vé
                selectedSeats.clear();   // Reset ghế
                currentStep = 1;
              });
            },
          ),
        );
      },
    );
  }

  // B1: Chọn giờ
  Widget _buildShowtimeStep() {
    // Chỉ lấy các suất chiếu tương ứng với loại vé đã chọn ở B0
    final availableShowtimes = _showtimeController.showtimes
        .where((st) => st.ticket_type.id == selectedTicket?.id)
        .toList();

    if (availableShowtimes.isEmpty) {
      return const Center(child: Text("Không có giờ chiếu phù hợp."));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: availableShowtimes.length,
      itemBuilder: (context, index) {
        final st = availableShowtimes[index];
        bool isSel = selectedShowtime?.id == st.id;

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSel ? Colors.orange : Colors.grey[800],
          ),
          onPressed: () => _onShowtimeSelected(st),
          child: Text(st.starttime),
        );
      },
    );
  }

  // B2: Chọn ghế
  Widget _buildSeatSelectionStep() {
    if (_theaterRoomController.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.orange));
    }

    if (_theaterRoomController.errorMessage != null) {
      return Center(child: Text("Lỗi: ${_theaterRoomController.errorMessage}"));
    }

    final currentRoom = _theaterRoomController.theaterrooms.firstWhere(
          (room) => room.id == selectedShowtime?.theater_room_id,
      orElse: () => TheaterRoom(id: 0, theaterName: '', seats: []),
    );

    if (currentRoom.seats.isEmpty) {
      return const Center(child: Text("Không tìm thấy sơ đồ ghế cho phòng này."));
    }

    List<Seat> sortedSeats = List.from(currentRoom.seats);
    sortedSeats.sort((a, b) {
      // So sánh hàng (A, B, C...)
      int rowCompare = a.seatrow.compareTo(b.seatrow);
      if (rowCompare != 0) return rowCompare;
      // Nếu cùng hàng, so sánh số ghế (1, 2, 3...)
      return a.seatnumber.compareTo(b.seatnumber);
    });

    // 3. TÍNH TOÁN SỐ CỘT (Dựa trên số ghế lớn nhất trong một hàng để grid đều)
    int maxColumns = sortedSeats.map((s) => s.seatnumber).reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          "PHÒNG: ${currentRoom.theaterName.toUpperCase()}",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 18),
        ),
        const SizedBox(height: 10),
        const Text("MÀN HÌNH", style: TextStyle(letterSpacing: 10, color: Colors.grey)),
        const Divider(color: Colors.orange, indent: 40, endIndent: 40, thickness: 2),
        const SizedBox(height: 20),

        Expanded(
          child: InteractiveViewer( // Cho phép zoom nếu phòng quá rộng
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.1,
            maxScale: 2.0,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: maxColumns, // Số cột tự động khớp với số ghế/hàng
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: sortedSeats.length,
              itemBuilder: (context, index) {
                final seat = sortedSeats[index];
                String seatLabel = "${seat.seatrow}${seat.seatnumber}";

                bool isBooked = selectedShowtime?.book_seats.any(
                        (bs) => bs.seatrow == seat.seatrow && bs.seatnumber == seat.seatnumber
                ) ?? false;

                bool isSel = selectedSeats.contains(seatLabel);

                return GestureDetector(
                  onTap: isBooked ? null : () {
                    setState(() {
                      isSel ? selectedSeats.remove(seatLabel) : selectedSeats.add(seatLabel);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: isBooked
                            ? Colors.red[900]
                            : (isSel ? Colors.orange : Colors.grey[800]),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: isSel ? Colors.white : Colors.transparent,
                            width: 1
                        )
                    ),
                    child: Center(
                      child: Text(
                        seatLabel,
                        style: TextStyle(
                            fontSize: maxColumns > 8 ? 8 : 10, // Tự nhỏ chữ nếu quá nhiều cột
                            decoration: isBooked ? TextDecoration.lineThrough : null,
                            color: isBooked ? Colors.white38 : Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        _buildSeatLegend(),
      ],
    );
  }

  // B3: Thông tin & Voucher
  Widget _buildInfoAndVoucherStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Họ tên",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: contactController,
            decoration: const InputDecoration(
              labelText: "Email/Số điện thoại",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "VOUCHER GIẢM GIÁ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: voucherController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _applyVoucher,
                child: const Text("ÁP DỤNG"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // B4: OTP
  Widget _buildOTPStep() {
    final contact = contactController.text.trim();
    final isEmail = contact.contains('@');
    final otpCtrl = Provider.of<OTPController>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "NHẬP MÃ OTP",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        Text(
          isEmail
              ? "Mã OTP đã gửi đến email"
              : "Mã OTP đã gửi đến số điện thoại",
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          child: TextField(
            controller: otpController,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 30, letterSpacing: 15),
            decoration: const InputDecoration(hintText: "000000"),
          ),
        ),

        // 🔥 RESEND BUTTON
        TextButton(
          onPressed: otpCtrl.resendSeconds > 0
              ? null
              : () {
            final type = _detectOTPType(contact);

            otpCtrl.sendOTP(
              contact,
              type,
                  (err) => _showSnackBar(err, Colors.red),
                  () => _showSnackBar("Đã gửi lại OTP!", Colors.green),
            );
          },
          child: Text(
            otpCtrl.resendSeconds > 0
                ? "Gửi lại sau ${otpCtrl.resendSeconds}s"
                : "Gửi lại OTP",
          ),
        ),
      ],
    );
  }

  // Thanh điều hướng dưới cùng
  Widget _buildBottomBar() {
    if (currentStep < 2) return const SizedBox.shrink();

    final otpCtrl = Provider.of<OTPController>(context);

    double total =
        (selectedTicket?.price ?? 0) * selectedSeats.length - discount;

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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),

            // 🔥 disable khi đang gửi hoặc đang countdown
            onPressed: (currentStep == 3 &&
                (otpCtrl.isSending || otpCtrl.resendSeconds > 0))
                ? null
                : _handleContinue,

            child: (currentStep == 3 && otpCtrl.isSending)
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : Text(
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
