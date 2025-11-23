import 'package:flutter/material.dart';

class MainCourse {
  final String image, name, description;
  final int id;
  final double price; // dalam ribuan
  final Color bgcolor;

  MainCourse({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.id,
    required this.bgcolor,
  });
}

List<MainCourse> mainCourseList = [
  MainCourse(
    id: 0,
    name: 'Chicken Steak',
    description: 'Steak ayam juicy dengan saus lada hitam.',
    price: 75.0, // Rp 75.000
    image: 'assets/images/ChickenSteak.png',
    bgcolor: const Color(0xFFCE9034),
  ),
  MainCourse(
    id: 1,
    name: 'Beef Burger',
    description: 'Burger daging sapi premium dengan keju cheddar.',
    price: 72.0, // Rp 72.000
    image: 'assets/images/BeefBurger.png',
    bgcolor: const Color(0xFF6D6875),
  ),
  MainCourse(
    id: 2,
    name: 'Chicken Rice Bowl',
    description: 'Nasi dengan potongan ayam crispy dan saus spicy.',
    price: 55.0, // Rp 55.000
    image: 'assets/images/ChickenRiceBowl.png',
    bgcolor: const Color(0xFF3D6356),
  ),
  MainCourse(
    id: 3,
    name: 'Pasta Carbonara',
    description: 'Pasta creamy dengan smoked beef.',
    price: 80.0, // Rp 80.000
    image: 'assets/images/PastaCarbonara.png',
    bgcolor: const Color(0xFFC980F2),
  ),
  MainCourse(
    id: 4,
    name: 'Grilled Fish',
    description: 'Ikan panggang lembut dengan lemon butter.',
    price: 90.0, // Rp 90.000
    image: 'assets/images/GrilledFish.png',
    bgcolor: const Color(0xFFDB657F),
  ),
  MainCourse(
    id: 5,
    name: 'Risol',
    description: 'Risol spesial isi ragout, kelas sultan.',
    price: 3000.0, // Rp 3.000.000
    image: 'assets/images/risol.png',
    bgcolor: const Color(0xFFFFE082),
  ),
];
