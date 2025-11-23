import 'package:flutter/material.dart';

class Appetizer {
  final String image, name, description;
  final int id;
  final double price;
  final Color bgcolor;

  Appetizer({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.id,
    required this.bgcolor,
  });
}

List<Appetizer> appetizerList = [
  Appetizer(
    id: 0,
    name: 'French Fries',
    description: 'Kentang goreng renyah dengan sedikit taburan garam.',
    price: 32.0, // Rp 32.000
    image: 'assets/images/FrenchFries.png',
    bgcolor: const Color(0xFFFFD180),
  ),
  Appetizer(
    id: 1,
    name: 'Garlic Bread',
    description: 'Roti panggang dengan mentega bawang yang harum.',
    price: 28.0, // Rp 28.000
    image: 'assets/images/GarlicBread.png',
    bgcolor: const Color(0xFFE0A458),
  ),
  Appetizer(
    id: 2,
    name: 'Chicken Wings',
    description: 'Sayap ayam gurih dengan saus BBQ.',
    price: 45.0, // Rp 45.000
    image: 'assets/images/ChickenWings.png',
    bgcolor: const Color(0xFFD4A373),
  ),
  Appetizer(
    id: 3,
    name: 'Onion Rings',
    description: 'Bawang bombay goreng crispy yang nikmat.',
    price: 30.0, // Rp 30.000
    image: 'assets/images/OnionRings.png',
    bgcolor: const Color(0xFFFFCC80),
  ),
  Appetizer(
    id: 4,
    name: 'Spring Rolls',
    description: 'Lumpia sayur renyah dengan saus pedas manis.',
    price: 35.0, // Rp 35.000
    image: 'assets/images/SpringRolls.png',
    bgcolor: const Color(0xFFFFECB3),
  ),
];
