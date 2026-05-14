import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/controllers/ticket_controller.dart';
import '../data/controllers/order_controller.dart';
import '../data/models/ticket.dart';
import '../data/models/order_detail.dart';

class TicketPrintingScreen extends StatefulWidget {
  final int orderId;

  const TicketPrintingScreen({super.key, required this.orderId});

  @override
  State<TicketPrintingScreen> createState() => _TicketPrintingScreenState();
}

class _TicketPrintingScreenState extends State<TicketPrintingScreen> {
  List<Ticket> tickets = [];
  OrderDetail? orderDetail;
  bool isPrinting = true;
  String message = "ĐANG XỬ LÝ THANH TOÁN...";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _waitAndPrint();
    });
  }

  Future<void> _waitAndPrint() async {
    final ticketCtrl = Provider.of<TicketController>(context, listen: false);
  
    final orderCtrl = Provider.of<OrderController>(context, listen: false);

    await orderCtrl.getOrder(
      widget.orderId,
    );

    orderDetail = orderCtrl.order;

    /// 🔥 1. FETCH TICKETS (retry nhẹ)
    List<Ticket> result = [];

    for (int i = 0; i < 5; i++) {
      result = await ticketCtrl.fetchTickets(widget.orderId);

      debugPrint("FETCH TICKETS TRY $i: ${result.length}");

      if (result.isNotEmpty) break;

      await Future.delayed(const Duration(milliseconds: 800));
    }


    if (!mounted) return;

    /// ❌ KHÔNG có vé
    if (result.isEmpty) {
      setState(() {
        isPrinting = false;
        message = "KHÔNG NHẬN ĐƯỢC VÉ";
      });
      return;
    }

    /// ✅ có vé → cập nhật UI
    setState(() {
      tickets = result;
      message = "ĐANG IN VÉ...";
    });

    /// 🔥 2. IN VÉ (giả lập)
    for (var t in tickets) {
      await _printTicket(t);
    }

    if (!mounted) return;

    /// 🔥 3. DONE
    setState(() {
      isPrinting = false;
      message = "IN VÉ THÀNH CÔNG";
    });
  }

  Future<void> _printTicket(Ticket t) async {
    debugPrint("PRINT: ${t.movie_title} - ${t.seat_name}");

    /// 👉 thay bằng driver thật
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: isPrinting
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.orange),
                  const SizedBox(height: 20),

                  Text(
                    "ORDER ID: ${widget.orderId}",
                    style: const TextStyle(color: Colors.white),
                  ),

                  const SizedBox(height: 10),

                  Text(message, style: const TextStyle(color: Colors.white)),
                ],
              ),
            )
          /// ❌ FAIL
          : tickets.isEmpty
          ? Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            )
          /// ✅ SUCCESS + HIỂN THỊ VÉ
          : ListView(
              padding: const EdgeInsets.all(16),

              children: [
                /// =====================
                /// TICKETS
                /// =====================
                ...tickets.map((t) {
                  return Card(
                    color: const Color(0xFF1E1E1E),

                    margin: const EdgeInsets.only(bottom: 12),  

                    child: Padding(
                      padding: const EdgeInsets.all(12),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            t.movie_title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text("ID: ${t.id}", style: const TextStyle(color: Colors.white70)),

                          Text("Ngày chiếu: ${t.show_date}", style: const TextStyle(color: Colors.white70)),

                          Text("Giờ chiếu: ${t.start_time}", style: const TextStyle(color: Colors.white70)),

                          Text("Phòng: ${t.theater_room_name}", style: const TextStyle(color: Colors.white70)),

                          Text("Ghế: ${t.seat_name}", style: const TextStyle(color: Colors.white70)),

                          Text("Tạo vào: ${t.created_at}", style: const TextStyle(color: Colors.white70)),

                          const SizedBox(height: 6),

                          Text(
                            "Trạng thái: ${t.status}",
                            style: TextStyle(
                              color: t.status == "CONFIRMED"
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                /// =====================
                /// ORDER DETAIL
                /// =====================
                if (orderDetail != null)
                  Card(
                    color: const Color(0xFF2A2A2A),

                    margin: const EdgeInsets.only(top: 20),

                    child: Padding(
                      padding: const EdgeInsets.all(16),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            "THÔNG TIN ĐƠN HÀNG",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text("Order ID: ${orderDetail!.id}"),

                          Text("Khách hàng: ${orderDetail!.name}"),

                          Text(
                            "Mã thanh toán: ${orderDetail!.paymentOrderCode}",
                          ),

                          Text(
                            "Voucher: ${orderDetail!.voucherCode ?? 'Không có'}",
                          ),

                          Text("Tổng tiền: ${orderDetail!.totalAmount} VNĐ"),

                          Text("Thanh toán lúc: ${orderDetail!.paidAt}"),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
