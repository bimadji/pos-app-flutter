import 'package:flutter/material.dart';

class Dessert {
  final String image, name, description;
  final int id;
  final double price; // dalam ribuan
  final Color bgcolor;

  Dessert({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.id,
    required this.bgcolor,
  });
}

List<Dessert> dessertList = [
  Dessert(
    id: 0,
    name: 'Chocolate Cake',
    description: 'Kue cokelat lembut dengan topping ganache.',
    price: 48.0, // Rp 48.000
    image: 'assets/images/ChocolateCake.png',
    bgcolor: const Color(0xFFE0BBE4),
  ),
  Dessert(
    id: 1,
    name: 'Ice Cream Vanilla',
    description: 'Es krim vanilla dengan tekstur creamy.',
    price: 32.0, // Rp 32.000
    image: 'assets/images/IceCreamVanilla.png',
    bgcolor: const Color(0xFFFEC8D8),
  ),
  Dessert(
    id: 2,
    name: 'Pudding Caramel',
    description: 'Puding caramel manis dengan saus lembut.',
    price: 30.0, // Rp 30.000
    image: 'assets/images/PuddingCaramel.png',
    bgcolor: const Color(0xFFFFDFD3),
  ),
  Dessert(
    id: 3,
    name: 'Strawberry Cheesecake',
    description: 'Cheesecake lembut dengan topping stroberi.',
    price: 52.0, // Rp 52.000
    image: 'assets/images/StrawberryCheesecake.png',
    bgcolor: const Color(0xFFF6EAC2),
  ),
  Dessert(
    id: 4,
    name: 'Mochi Ice Cream',
    description: 'Mochi lembut berisi es krim premium.',
    price: 42.0, // Rp 42.000
    image: 'assets/images/MochiIceCream.png',
    bgcolor: const Color(0xFFE3F2FD),
  ),
];
