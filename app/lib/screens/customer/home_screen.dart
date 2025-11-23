import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import '../../theme/app_theme.dart';
import '../../core/services/product_service.dart';
import '../../models/product.dart';
import 'order_screen.dart';
import 'rating_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  IOWebSocketChannel? channel;
  int tableNumber = 1;

  int selectedTab = 0;
  String customerName = "";

  final Map<String, int> _cart = {};
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    loadCustomer();
  }

  Future<void> loadCustomer() async {
    final prefs = await SharedPreferences.getInstance();
    customerName = prefs.getString("customer_name") ?? "Customer";
    tableNumber = prefs.getInt("customer_table") ?? 1;

    print("LOADED TABLE NUMBER: $tableNumber");

    channel = IOWebSocketChannel.connect('ws://192.168.1.10:8080');
    // channel = IOWebSocketChannel.connect('ws://10.156.127.235:8080');

    channel!.stream.listen(
          (message) {
        print("SERVER MESSAGE: $message");
      },
      onError: (err) {
        print("WEBSOCKET ERROR: $err");
      },
      onDone: () {
        print("WEBSOCKET CLOSED");
      },
    );

    setState(() {});
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    final products = await ProductService().getProducts();
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  List<Product> getProductsByCategory(String category) {
    return _products.where((p) => p.category == category).toList();
  }

  void addToCart(String productId) {
    setState(() {
      _cart.update(productId, (old) => old + 1, ifAbsent: () => 1);
    });
    sendCartUpdate();
  }

  void removeFromCart(String productId) {
    if (!_cart.containsKey(productId)) return;
    setState(() {
      final currentQty = _cart[productId]!;
      if (currentQty > 1) {
        _cart[productId] = currentQty - 1;
      } else {
        _cart.remove(productId);
      }
    });
    sendCartUpdate();
  }

  void sendCartUpdate() {
    if (channel == null) {
      print("WebSocket belum siap");
      return;
    }

    print("SEND CART → TABLE: $tableNumber, TOTAL: $totalPrice");

    final items = _cart.entries.map((e) {
      final product =
      _products.firstWhere((p) => p.id.toString() == e.key);
      return {
        'id': product.id,
        'name': product.name,
        'qty': e.value,
        'price': product.price
      };
    }).toList();

    final data = {
      'type': 'cart_update',
      'table_number': tableNumber,
      'items': items,
      'total': totalPrice,
      'customer_name': customerName,
    };

    print("DATA DIKIRIM: ${jsonEncode(data)}");

    channel!.sink.add(jsonEncode(data));
  }

  int get totalItems => _cart.values.fold<int>(0, (p, e) => p + e);

  int get totalPrice {
    int total = 0;
    _cart.forEach((productId, qty) {
      final product = _products.firstWhere(
            (p) => p.id.toString() == productId,
        orElse: () => Product(
          id: 0,
          name: '',
          category: '',
          price: 0,
          stock: 0,
          sold: 0,
          createdAt: '',
          image: null,
        ),
      );
      total += product.price * qty;
    });
    return total;
  }

  void _goToOrderScreen() async {
    if (_cart.isEmpty) return;

    final updatedCart = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderScreen(
          cart: Map<String, int>.from(_cart),
          menus: _products,
          tableNumber: tableNumber,
          customerName: customerName,
        ),
      ),
    );

    if (updatedCart != null) {
      setState(() {
        _cart
          ..clear()
          ..addAll(Map<String, int>.from(updatedCart));
      });

      sendCartUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hi, $customerName',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Icon(Icons.notifications_none),
                ],
              ),
            ),

            // TABS + PRODUCTS
            Expanded(
              child: Column(
                children: [
                  // TABS
                  SizedBox(
                    height: 70,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        _buildTabItem(0, 'Appetizer'),
                        _buildTabItem(1, 'Main Course'),
                        _buildTabItem(2, 'Dessert'),
                        _buildTabItem(3, 'Minuman'),
                      ],
                    ),
                  ),

                  // PRODUCTS GRID
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        itemCount: getProductsByCategory(
                            _tabToCategory(selectedTab))
                            .length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, index) {
                          final product = getProductsByCategory(
                              _tabToCategory(selectedTab))[index];
                          final qty = _cart[product.id.toString()] ?? 0;
                          return _buildProductCard(product, qty);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // CART SUMMARY
            if (totalItems > 0)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$totalItems item • Rp $totalPrice',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _goToOrderScreen,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orangePrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Pesan'),
                    ),
                  ],
                ),
              ),

            // BOTTOM NAV
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const _BottomNavItem(
                    icon: Icons.home,
                    label: 'Home',
                    isActive: true,
                  ),
                  _BottomNavItem(
                    icon: Icons.receipt_long,
                    label: 'Order',
                    onTap: _goToOrderScreen,
                  ),
                  _BottomNavItem(
                    icon: Icons.star_border,
                    label: 'Rating',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RatingScreen(
                            cart: Map<String, int>.from(_cart),
                            menus: List<Product>.from(_products),
                          ),
                        ),
                      );
                    },
                  ),
                  _BottomNavItem(
                    icon: Icons.person_outline,
                    label: 'Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product, int qty) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  product.image != null && product.image!.isNotEmpty
                      ? 'assets/images/${product.image}'
                      : 'assets/images/default.jpeg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Rp ${product.price.toInt()}'),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => removeFromCart(product.id.toString()),
                ),
                Text('$qty'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => addToCart(product.id.toString()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12, top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ]
              : [],
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  String _tabToCategory(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'Appetizer';
      case 1:
        return 'Main Course';
      case 2:
        return 'Dessert';
      case 3:
        return 'Minuman';
      default:
        return 'Appetizer';
    }
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.orangePrimary : Colors.grey;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
