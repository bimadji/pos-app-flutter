import 'package:flutter/material.dart';
import 'body.dart';

// Kalau mau ada keranjang di MenuScreen juga:
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedTab = 0;

  final List<String> categories = [
    "Appetizer",
    "Main Course",
    "Dessert",
    "Minuman",
  ];

  // Keranjang lokal di MenuScreen
  final Map<String, int> _cart = {};

  void addToCart(String menuId) {
    setState(() {
      _cart.update(menuId, (old) => old + 1, ifAbsent: () => 1);
    });
  }

  void removeFromCart(String menuId) {
    if (!_cart.containsKey(menuId)) return;
    setState(() {
      final currentQty = _cart[menuId]!;
      if (currentQty > 1) {
        _cart[menuId] = currentQty - 1;
      } else {
        _cart.remove(menuId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: const Text(
          "Pilih Menu",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TAB KATEGORI
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final bool isSelected = selectedTab == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 12, top: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              const BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.black : Colors.grey.shade600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ISI MENU (GRID)
          Expanded(
            child: Body(
              selectedTab: selectedTab,
              cart: _cart,
              onAdd: addToCart,
              onRemove: removeFromCart,
            ),
          ),
        ],
      ),
    );
  }
}
