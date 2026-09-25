import 'package:flutter/material.dart';
import 'package:app/models/user.dart';
import 'package:app/models/product.dart';
import 'package:app/widgets/dashboard_card.dart';
import 'package:app/widgets/action_button.dart';
import '../../core/services/product_service.dart';
import '../../core/services/user_service.dart';
import '../auth/login_screen.dart';
import 'manage_products_screen.dart';
import 'manage_users_screen.dart';
import 'view_reports_screen.dart';

int totalProducts = 0;
int totalUsers = 0;
int lowStockCount = 0;

bool loading = true;


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Product> products = [];
  List<AppUser> users = [];

  bool loading = true;

  final productService = ProductService();
  final userService = UserService();

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    setState(() => loading = true);

    final p = await ProductService().getProducts();
    final u = await UserService.getUsers();

    setState(() {
      products = p;
      users = u;
      loading = false;
    });
  }


  void _addProduct(Product product) async {
    bool success = await productService.addProduct(product);

    if (success) {
      setState(() {
        products = List.from(products)..add(product);
      });
    }
  }

  void _removeProduct(int id) async {
    bool success = await productService.deleteProduct(id);

    if (success) {
      setState(() {
        products.removeWhere((p) => p.id == id);
      });
    }
  }

  void _addUser(AppUser user) async {
    bool success = await UserService.addUser(
      user.username,
      user.role,
    );

    if (success) {
      setState(() {
        users = List.from(users)..add(user);
      });
    }
  }

  void _removeUser(String id) async {
    bool success = await UserService.deleteUser(id);

    if (success) {
      setState(() {
        users.removeWhere((u) => u.id == id);
      });
    }
  }


  // Constants Warna
  static const Color orangeAction = Color(0xFFFF9800);
  static const Color greenAction = Color(0xFF4CAF50);
  static const Color blueAction = Color(0xFF2196F3);
  static const Color purpleAction = Color(0xFF9C27B0);
  static const Color topBannerColor = Color(0xFFFF9800); // Oranye

  @override
  Widget build(BuildContext context) {
    int lowStockCount = products.where((p) => p.stock <= 10).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Header Dekoratif Dashboard
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: topBannerColor,
              child: Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.store,
                      color: Colors.white,
                      size: 40,
                    ), // Ikon Toko FnB
                    const SizedBox(height: 5),
                    Text(
                      'Admin Dashboard',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            // Statistik
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  DashboardCard(
                    icon: Icons.local_cafe, // <-- ICON FNB
                    label: 'Total Menu',
                    value: products.length.toString(),
                  ),
                  DashboardCard(
                    icon: Icons.people,
                    label: 'Karyawan',
                    value: users.length.toString(),
                  ),
                ],
              ),
            ),

            // Quick Actions Title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quick Actions',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Tombol Aksi
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  ActionButton(
                    text: 'Manage Products',
                    color: orangeAction,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageProductsScreen(
                          products: products,
                          addProduct: _addProduct,
                          removeProduct: _removeProduct,
                        ),
                      ),
                    ),
                  ),
                  ActionButton(
                    text: 'Manage Karyawan',
                    color: greenAction,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageUsersScreen(
                          users: users,
                          addUser: _addUser,
                          removeUser: _removeUser,
                        ),
                      ),
                    ),
                  ),
                  ActionButton(
                    text: 'Lihat Laporan',
                    color: blueAction,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewReportsScreen(
                          totalProducts: products.length,
                          lowStockCount: lowStockCount,
                          totalUsers: users.length,
                          products: products,
                        ),
                      ),
                    ),
                  ),
                  ActionButton(
                    text: 'Logout',
                    color: purpleAction,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
