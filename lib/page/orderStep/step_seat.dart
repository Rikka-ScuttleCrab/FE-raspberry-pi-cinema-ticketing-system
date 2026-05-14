import 'package:flutter/material.dart';
import '../../data/models/seat.dart';

class StepSeat extends StatelessWidget {
  final List<Seat> seats;
  final List<String> selectedSeats;
  final Function(String) onToggle;
  final List<dynamic> bookedSeats;
  final String theaterName;
  final bool isLoading;
  final String? error;

  const StepSeat({
    super.key,
    required this.seats,
    required this.selectedSeats,
    required this.onToggle,
    required this.bookedSeats,
    required this.theaterName,
    required this.isLoading,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    /// ✅ HANDLE LOADING
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }

    /// ✅ HANDLE ERROR
    if (error != null) {
      return Center(child: Text("Lỗi: $error"));
    }

    if (seats.isEmpty) {
      return const Center(
        child: Text("Không tìm thấy sơ đồ ghế"),
      );
    }

    /// SORT
    List<Seat> sortedSeats = List.from(seats);
    sortedSeats.sort((a, b) {
      int rowCompare = a.seatrow.compareTo(b.seatrow);
      if (rowCompare != 0) return rowCompare;
      return a.seatnumber.compareTo(b.seatnumber);
    });

    int maxColumns =
    sortedSeats.map((s) => s.seatnumber).reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        const SizedBox(height: 10),

        /// TITLE
        Text(
          "PHÒNG: ${theaterName.toUpperCase()}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
            fontSize: 18,
          ),
        ),

        const SizedBox(height: 10),
        const Text("MÀN HÌNH",
            style: TextStyle(letterSpacing: 10, color: Colors.grey)),

        const Divider(
          color: Colors.orange,
          indent: 40,
          endIndent: 40,
          thickness: 2,
        ),

        const SizedBox(height: 20),

        /// GRID
        Expanded(
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.1,
            maxScale: 2.0,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: maxColumns,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: sortedSeats.length,
              itemBuilder: (context, index) {
                final seat = sortedSeats[index];
                String label = "${seat.seatrow}${seat.seatnumber}";

                bool isBooked = bookedSeats.any(
                      (bs) =>
                  bs.seatrow == seat.seatrow &&
                      bs.seatnumber == seat.seatnumber,
                );

                bool isSel = selectedSeats.contains(label);

                return GestureDetector(
                  onTap: isBooked ? null : () => onToggle(label), // ✅ callback
                  child: Container(
                    decoration: BoxDecoration(
                      color: isBooked
                          ? Colors.red[900]
                          : (isSel ? Colors.orange : Colors.grey[800]),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSel ? Colors.white : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: maxColumns > 8 ? 8 : 10,
                          decoration: isBooked
                              ? TextDecoration.lineThrough
                              : null,
                          color: isBooked ? Colors.white38 : Colors.white,
                          fontWeight: FontWeight.bold,
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

  /// LEGEND
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
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(text,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}