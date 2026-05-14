import 'package:flutter/material.dart';
import '../../data/models/showtime.dart';

class StepShowtime extends StatelessWidget {
  final List<Showtime> showtimes;
  final Showtime? selected;
  final Function(Showtime) onSelect;

  const StepShowtime({
    super.key,
    required this.showtimes,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (showtimes.isEmpty) {
      return const Center(child: Text("Không có suất chiếu"));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: showtimes.length,
      itemBuilder: (context, index) {
        final st = showtimes[index];
        bool isSel = selected?.id == st.id;

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSel ? Colors.orange : Colors.grey[800],
          ),
          onPressed: () => onSelect(st),
          child: Text(st.starttime),
        );
      },
    );
  }
}