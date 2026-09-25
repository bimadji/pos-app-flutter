import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  final int total;
  final VoidCallback onConfirm;
  final VoidCallback onDone;
  final String status;

  const OrderSummary({
    super.key,
    required this.total,
    required this.onConfirm,
    required this.onDone,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final safeStatus = status.isEmpty ? " " : status;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Total", style: TextStyle(fontSize: 18)),
            Text(
              "Rp $total",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3A21),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text("Terima Pesanan", style: TextStyle(fontSize: 16)),
          ),
        ),

        const SizedBox(height: 8),

        Center(
          child: TextButton(
            onPressed: onDone,
            child: const Text("Selesai"),
          ),
        ),
      ],
    );
  }
}
