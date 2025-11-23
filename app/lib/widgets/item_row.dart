import 'package:flutter/material.dart';
import '../models/item.dart';

class ItemRow extends StatelessWidget {
  final Item item;

  const ItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text("${item.qty}x", style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
