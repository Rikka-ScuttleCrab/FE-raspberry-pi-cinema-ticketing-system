import 'package:flutter/material.dart';
import '../models/film.dart'; // Thay đổi đường dẫn import cho đúng
import '../models/ticket_type.dart';
import 'paymentwebview.dart';

class BookingScreen extends StatefulWidget {
  final Film film;
  const BookingScreen({super.key, required this.film});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int currentStep = 0;
  TicketType? selectedTicket;
  String? selectedShowtime;
  List<String> selectedSeats = [];
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Dữ liệu khung giờ mẫu (Bạn có thể đưa vào Model Film nếu muốn)
  final List<String> showtimes = ["09:00", "12:30", "15:45", "18:15", "20:30", "22:45"];

  @override
  void initState() {
    super.initState();
    // Nếu chỉ có 1 loại vé, chọn luôn và nhảy sang bước chọn Khung giờ
    if (widget.film.tickets.length == 1) {
      selectedTicket = widget.film.tickets[0];
      currentStep = 1; 
    }
  }

  void nextStep() => setState(() => currentStep++);
  void prevStep() {
    if (currentStep > 0) {
      // Logic quay lại thông minh
      if (currentStep == 1 && widget.film.tickets.length == 1) {
        Navigator.pop(context);
      } else {
        setState(() => currentStep--);
      }
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.film.name, style: const TextStyle(fontSize: 16)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: prevStep),
      ),
      body: _buildStepContent(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0: return _buildTicketTypeStep();
      case 1: return _buildShowtimeStep(); // Bước mới
      case 2: return _buildSeatSelectionStep();
      case 3: return _buildUserInfoStep();
      default: return const SizedBox.shrink();
    }
  }

  // --- BƯỚC 0: CHỌN LOẠI VÉ ---
  Widget _buildTicketTypeStep() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: widget.film.tickets.length,
      itemBuilder: (context, index) {
        final ticket = widget.film.tickets[index];
        return ListTile(
          tileColor: Colors.grey[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(ticket.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("${ticket.price.toInt()}đ"),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            setState(() => selectedTicket = ticket);
            nextStep();
          },
        );
      },
    );
  }

  // --- BƯỚC 1: CHỌN KHUNG GIỜ ---
  Widget _buildShowtimeStep() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text("CHỌN KHUNG GIỜ CHIẾU", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: showtimes.length,
            itemBuilder: (context, index) {
              bool isSelected = selectedShowtime == showtimes[index];
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.orange : Colors.grey[800],
                ),
                onPressed: () {
                  setState(() => selectedShowtime = showtimes[index]);
                  nextStep();
                },
                child: Text(showtimes[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- BƯỚC 2: CHỌN GHẾ ---
  Widget _buildSeatSelectionStep() {
    return Column(
      children: [
        Text("Giờ chiếu: $selectedShowtime", style: const TextStyle(color: Colors.orange)),
        const SizedBox(height: 10),
        const Text("MÀN HÌNH", style: TextStyle(letterSpacing: 8, color: Colors.grey)),
        const Divider(color: Colors.orange, indent: 50, endIndent: 50),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8, mainAxisSpacing: 8, crossAxisSpacing: 8),
            itemCount: 40,
            itemBuilder: (context, index) {
              String seat = "${String.fromCharCode(65 + (index ~/ 8))}${(index % 8) + 1}";
              bool isSelected = selectedSeats.contains(seat);
              return GestureDetector(
                onTap: () => setState(() => isSelected ? selectedSeats.remove(seat) : selectedSeats.add(seat)),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.orange : Colors.grey[800],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(child: Text(seat, style: const TextStyle(fontSize: 10))),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- BƯỚC 3: THÔNG TIN ---
  Widget _buildUserInfoStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(controller: nameController, decoration: const InputDecoration(labelText: "Họ tên")),
          const SizedBox(height: 15),
          TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Số điện thoại")),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    if (currentStep < 2) return const SizedBox.shrink();
    double total = (selectedTicket?.price ?? 0) * selectedSeats.length;
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Tổng: ${total.toInt()}đ", style: const TextStyle(fontSize: 18, color: Colors.orange, fontWeight: FontWeight.bold)),
          ElevatedButton(
            onPressed: () {
              if (currentStep == 2 && selectedSeats.isNotEmpty) nextStep();
              else if (currentStep == 3 && nameController.text.isNotEmpty) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentWebView()));
              }
            },
            child: Text(currentStep == 3 ? "THANH TOÁN" : "TIẾP THEO"),
          )
        ],
      ),
    );
  }
}