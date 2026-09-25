import 'package:flutter/material.dart';

class Minuman {
  final String image, name, description;
  final int id;
  final double price; // dalam ribuan
  final Color bgcolor;

  Minuman({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.id,
    required this.bgcolor,
  });
}

List<Minuman> minumanList = [
  Minuman(
    id: 0,
    name: 'Caffe Americano',
    description: 'Espresso dengan air panas, rasa rich dan deep.',
    price: 38.0, // Rp 38.000
    image: 'assets/images/CaffeAmericano.png',
    bgcolor: const Color(0xFFCE9034),
  ),
  Minuman(
    id: 1,
    name: 'Blonde Roast Americano',
    description:
        'Roast ringan, lembut dan enak diminum sendiri maupun dengan susu.',
    price: 40.0, // Rp 40.000
    image: 'assets/images/BlondeRoastAmericano.png',
    bgcolor: const Color(0xFF3D82AE),
  ),
  Minuman(
    id: 2,
    name: 'Espresso',
    description: 'Signature espresso dengan rasa karamel manis.',
    price: 35.0, // Rp 35.000
    image: 'assets/images/Espresso.png',
    bgcolor: const Color(0xFF3D6356),
  ),
  Minuman(
    id: 3,
    name: 'Cold Brew',
    description: 'Cold brew dengan foam lembut dan sedikit manis.',
    price: 45.0, // Rp 45.000
    image: 'assets/images/ColdBrew.png',
    bgcolor: const Color(0xFFC980F2),
  ),
  Minuman(
    id: 4,
    name: 'Nitro Cold Brew',
    description: 'Cold brew dengan tekstur creamy dari nitrogen.',
    price: 50.0, // Rp 50.000
    image: 'assets/images/NitroColdBrew.png',
    bgcolor: const Color(0xFFDB657F),
  ),
  Minuman(
    id: 5,
    name: 'Espresso Blend',
    description: 'Espresso blend dengan rasa kuat dan bold.',
    price: 42.0, // Rp 42.000
    image: 'assets/images/EspressoBlend.png',
    bgcolor: const Color(0xFFC1E394),
  ),
  Minuman(
    id: 6,
    name: 'Es Teh',
    description: 'Es teh manis legendaris harga sultan.',
    price: 5000.0, // Rp 5.000.000
    image: 'assets/images/teh.png',
    bgcolor: const Color(0xFF81D4FA),
  ),
];
