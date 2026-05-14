import 'package:flutter/material.dart';
import '../../data/models/ticket_type.dart';

class StepTicketType extends StatelessWidget {
  final List<TicketType> ticketTypes;
  final Function(TicketType) onSelect;

  const StepTicketType({
    super.key,
    required this.ticketTypes,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (ticketTypes.isEmpty) {
      return const Center(child: Text("Hôm nay đã hết suất chiếu cho phim này."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: ticketTypes.length,
      itemBuilder: (context, index) {
        final t = ticketTypes[index];
        return Card(
          color: Colors.grey[900],
          child: ListTile(
            title: Text(t.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${t.price.toInt()}đ"),
            onTap: () => onSelect(t),
          ),
        );
      },
    );
  }
}