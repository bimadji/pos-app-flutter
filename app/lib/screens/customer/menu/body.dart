import 'package:flutter/material.dart';

import '../../../models/menu_appetizer.dart';
import '../../../models/menu_dessert.dart';
import '../../../models/menu_maincourse.dart';
import '../../../models/menu_minuman.dart';

class Body extends StatelessWidget {
  final int selectedTab;

  final Map<String, int>? cart;
  final void Function(String menuId)? onAdd;
  final void Function(String menuId)? onRemove;

  const Body({
    super.key,
    required this.selectedTab,
    this.cart,
    this.onAdd,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final list = _getMenuList();

    return Container(
      color: const Color(0xFFFFF3E0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Menu Pilihan",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(child: buildMenuList(list)),
          ],
        ),
      ),
    );
  }

  // pilih list menu sesuai tab
  List<dynamic> _getMenuList() {
    switch (selectedTab) {
      case 0:
        return appetizerList;
      case 1:
        return mainCourseList;
      case 2:
        return dessertList;
      case 3:
        return minumanList;
      default:
        return appetizerList;
    }
  }

  String _getItemId(dynamic item) {
    if (item is Appetizer) return 'app_${item.id}';
    if (item is MainCourse) return 'main_${item.id}';
    if (item is Dessert) return 'des_${item.id}';
    if (item is Minuman) return 'min_${item.id}';
    return '';
  }

  // grid menu
  Widget buildMenuList(List<dynamic> list) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final item = list[index];
        final String itemId = _getItemId(item);

        final int qty = cart?[itemId] ?? 0;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: item.bgcolor,
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Image.asset(item.image, fit: BoxFit.contain)),
              const SizedBox(height: 8),
              Text(
                item.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "Rp ${(item.price * 1000).toInt()}",
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),

              // kalau ada fungsi keranjang (dipanggil dari HomeScreen)
              if (onAdd != null && onRemove != null)
                Align(
                  alignment: Alignment.bottomRight,
                  child: qty == 0
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add, color: Colors.black),
                            iconSize: 22,
                            onPressed: () => onAdd!(itemId),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                ),
                                iconSize: 20,
                                onPressed: () => onRemove!(itemId),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$qty',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                                iconSize: 20,
                                onPressed: () => onAdd!(itemId),
                              ),
                            ),
                          ],
                        ),
                )
              else
                // kalau dipanggil dari MenuScreen biasa, cuma tombol + dengan print
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.black),
                      iconSize: 22,
                      onPressed: () {
                        // contoh aksi sederhana
                        // ignore: avoid_print
                        print("Pesan: ${item.name}");
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
