import 'dart:async';
import 'dart:convert';
import 'package:app/screens/customer/rating_screen.dart';
import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../theme/app_theme.dart';
import 'package:web_socket_channel/io.dart';
import '../../utils/email_sender.dart';

class OrderScreen extends StatefulWidget {
  final Map<String, int> cart;
  final List<Product> menus;

  final int tableNumber;
  final String customerName;

  const OrderScreen({
    super.key,
    required this.cart,
    required this.menus,
    required this.tableNumber,
    required this.customerName,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late IOWebSocketChannel channel;
  late Map<String, int> _cart;
  late List<Map<String, dynamic>> _menus;
  late Map<String, Map<String, dynamic>> menuMap = {};

  bool _isOrdered = false;
  DateTime? _orderStartTime;
  int _estimatedSeconds = 0;
  Timer? _timer;
  String _orderStatus = "menunggu dikonfirmasi";

  @override
  void initState() {
    super.initState();
    _cart = Map<String, int>.from(widget.cart);
    _menus = widget.menus.map((p) => p.toJson()).toList();
    menuMap = {for (var m in _menus) m['id'].toString(): m};

    channel = IOWebSocketChannel.connect('ws://192.168.1.10:8080');

    channel.stream.listen((message) {
      try {
        final data = jsonDecode(message);
        if (data['type'] == 'transactions_update') {
          final newStatus = data['status']?[widget.tableNumber.toString()];
          if (newStatus != null && newStatus != _orderStatus) {
            print("Received new status from server: $newStatus");

            if (!mounted) return;

            setState(() {
              _orderStatus = newStatus;

              if (newStatus == 'diproses') {
                _isOrdered = true;
                _orderStartTime = DateTime.now();
                _estimatedSeconds = _calculateEstimateSeconds();
              } else if (newStatus == 'selesai') {
                final itemsForEmail = _cart.entries.map((e) {
                  final menu = menuMap[e.key];
                  return {
                    'name': menu?['name'] ?? '',
                    'qty': e.value,
                    'price': menu?['price'] ?? 0,
                  };
                }).toList();

                sendEmailReceipt(itemsForEmail); // otomatis kirim email

                _cart.clear();
                _isOrdered = false;
                _orderStartTime = null;
                _estimatedSeconds = 0;

                Future.delayed(const Duration(milliseconds: 500), () {
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RatingScreen(
                        cart: widget.cart,
                        menus: widget.menus,
                      ),
                    ),
                  );
                });
              }
            });

            if (newStatus == 'selesai') {
              Future.delayed(const Duration(milliseconds: 100), () {
                sendCartUpdate();
              });
            }
          }
        }
      } catch (e) {
        print("Error parsing server message: $e");
      }
    });
  }

  int get totalPrice {
    int total = 0;
    _cart.forEach((menuId, qty) {
      final menu = _menus.firstWhere(
            (m) => m['id'].toString() == menuId,
        orElse: () => {},
      );

      if (menu.isNotEmpty) {
        final price = menu['price'] is int
            ? menu['price'] as int
            : int.tryParse(menu['price'].toString()) ?? 0;
        total += price * qty;
      }
    });
    return total;
  }

  int get totalItems => _cart.values.fold<int>(0, (p, e) => p + e);

  int _calculateEstimateSeconds() {
    int total = 0;
    _cart.forEach((menuId, qty) {
      if (menuId == 'risol') {
        total += 30 * qty;
      } else if (menuId == 'kopi') {
        total += 300 * qty;
      } else if (menuId == 'teh') {
        total += 60 * qty;
      }
    });
    return total;
  }

  double get orderProgress {
    if (!_isOrdered || _orderStartTime == null || _estimatedSeconds == 0) {
      return 0.0;
    }
    final diff = DateTime.now().difference(_orderStartTime!).inSeconds;
    final value = diff / _estimatedSeconds;
    if (value < 0) return 0.0;
    if (value > 1) return 1.0;
    return value;
  }

  void addToCart(String menuId) {
    setState(() {
      _isOrdered = false;
      _orderStartTime = null;
      _estimatedSeconds = 0;

      _cart.update(menuId, (old) => old + 1, ifAbsent: () => 1);
    });

    sendCartUpdate();
  }

  void removeFromCart(String menuId) {
    if (!_cart.containsKey(menuId)) return;

    setState(() {
      _isOrdered = false;
      _orderStartTime = null;
      _estimatedSeconds = 0;

      final currentQty = _cart[menuId]!;
      if (currentQty > 1) {
        _cart[menuId] = currentQty - 1;
      } else {
        _cart.remove(menuId);
      }
    });

    sendCartUpdate();
  }

  void sendCartUpdate() {
    final items = _cart.entries.map((e) {
      final menu = _menus.firstWhere(
            (m) => m['id'].toString() == e.key,
        orElse: () => {},
      );

      return {
        'id': menu['id'],
        'name': menu['name'],
        'qty': e.value,
        'price': menu['price'],
      };
    }).toList();

    final data = {
      'type': 'cart_update',
      'table_number': widget.tableNumber,
      'customer_name': widget.customerName,
      'items': items,
      'total': totalPrice,
      'status': _orderStatus,
    };

    channel.sink.add(jsonEncode(data));
    print("SENT TO SERVER >>> $data");
  }

  void makeOrder() {
    if (_cart.isEmpty) return;

    setState(() {
      _isOrdered = true;
      _orderStartTime = DateTime.now();
      _estimatedSeconds = _calculateEstimateSeconds();
      _orderStatus = "dikonfirmasi";
    });

    final items = _cart.entries.map((e) {
      final menu = _menus.firstWhere(
            (m) => m['id'].toString() == e.key,
        orElse: () => {},
      );
      return {
        'id': menu['id'],
        'name': menu['name'],
        'qty': e.value,
        'price': menu['price'],
      };
    }).toList();

    final data = {
      'type': 'status_update',
      'table_number': widget.tableNumber,
      'customer_name': widget.customerName,
      'status': _orderStatus, // kirim dikonfirmasi ke server
      'items': items,
      'total': totalPrice,
    };

    channel.sink.add(jsonEncode(data));
    print("Order sent to server: $data");
  }


  void clearCart() {
    setState(() {
      _cart.clear();
      _isOrdered = false;
      _orderStartTime = null;
      _estimatedSeconds = 0;
    });

    sendCartUpdate();
    _timer?.cancel();
  }

  @override
  void dispose() {
    channel.sink.close();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _cart);
          },
        ),
        backgroundColor: AppColors.cream,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Your Order',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Order',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              // ===== Update Text yang rebuild otomatis =====
              Builder(
                builder: (context) {
                  return Text(
                    _orderStatus,
                    style: TextStyle(
                      fontSize: 12,
                      color: _statusColor(_orderStatus),
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              Expanded(
                child: _cart.isEmpty
                    ? const Center(
                  child: Text(
                    'Belum ada pesanan',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                )
                    : ListView(
                  children: _cart.entries.map((entry) {
                    final menuId = entry.key;
                    final qty = entry.value;
                    final menu = menuMap[menuId];
                    if (menu == null) return const SizedBox(); // safety

                    final price = menu['price'] is int
                        ? menu['price'] as int
                        : int.tryParse(menu['price'].toString()) ?? 0;
                    final subtotal = price * qty;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              menu['name'] ?? '',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () => removeFromCart(menuId),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$qty',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: () => addToCart(menuId),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: AppColors.orangePrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Rp $subtotal',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$totalItems items',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    'Rp $totalPrice',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const Text(
                'Order Status',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.orangeLight.withOpacity(0.6),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: orderProgress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.orangePrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _cart.isEmpty ? null : makeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orangePrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text('Pesan'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _cart.isEmpty ? null : clearCart,
                    child: const Text('Clear', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case "menunggu dikonfirmasi":
      return Colors.grey;
    case "dikonfirmasi":
      return Colors.blue;
    case "diproses":
      return Colors.orange;
    case "selesai":
      return Colors.green;
    default:
      return Colors.grey;
  }
}
