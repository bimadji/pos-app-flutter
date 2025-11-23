import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late IOWebSocketChannel channel;

  Map<String, List<Map<String, dynamic>>> transactions = {};

  Map<String, String> status = {};

  @override
  void initState() {
    super.initState();

    channel = IOWebSocketChannel.connect('ws://192.168.1.10:8080');

    channel.stream.listen((message) {
      final data = jsonDecode(message);

      if (data['type'] == 'transactions_update') {
        setState(() {
          // Update transactions
          transactions = Map<String, List<Map<String, dynamic>>>.from(
            data['transactions'].map(
                  (k, v) => MapEntry(k, List<Map<String, dynamic>>.from(v)),
            ),
          );

          // Merge/update status dari server
          if (data.containsKey('status')) {
            status = {
              ...status,
              ...Map<String, String>.from(data['status']),
            };
          }
        });

        print("📢 UPDATE RECEIVED FROM SERVER:");
        print(jsonEncode(data));
      }
    });
  }

  /// Update status dari kasir dan kirim ke server
  void _updateStatus(String tableNumber, String newStatus) {
    setState(() {
      status[tableNumber] = newStatus;
    });

    // Kirim ke server
    channel.sink.add(jsonEncode({
      "type": "status_update",
      "table_number": tableNumber,
      "status": newStatus,
    }));

    print("📤 STATUS SENT: Table $tableNumber -> $newStatus");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFE4),
      appBar: AppBar(
        title: const Text("Pesanan Masuk", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: transactions.entries
            .where((entry) => entry.value.isNotEmpty)
            .map((entry) {
          final tableNumber = entry.key;
          final orders = entry.value;
          final currentStatus = status[tableNumber] ?? "menunggu dikonfirmasi";

          return Container(
            margin: const EdgeInsets.only(bottom: 22),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Meja $tableNumber",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  currentStatus,
                  style: TextStyle(
                    fontSize: 14,
                    color: _statusColor(currentStatus),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                ...orders.map((order) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Customer: ${order['customerName']}",
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      ...List.generate(
                        order['items'].length,
                            (i) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(order['items'][i]['name']),
                              Text("x${order['items'][i]['qty']}"),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Total: Rp ${order['total']}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Divider(height: 30),
                    ],
                  );
                }).toList(),

                // Tombol status untuk kasir: hanya Proses & Selesai
                Row(
                  children: [
                    if (currentStatus == "menunggu dikonfirmasi" || currentStatus == "dikonfirmasi")
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _updateStatus(tableNumber, "diproses"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text("Proses", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    if (currentStatus == "diproses")
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _updateStatus(tableNumber, "selesai"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text("Selesai", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "menunggu dikonfirmasi":
      case "dikonfirmasi":
        return Colors.orange;
      case "diproses":
        return Colors.deepPurple;
      case "selesai":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
